Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE8814BF97;
	Sun, 19 Apr 2026 06:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776581284; cv=none; b=qjPnK9+NQVfD5Kd48NkFP4xe68ax5LaH0Jdi5i9/yotvf9xjv96dOg1/5OXJfxDCN+Ph1BHTNHxrZg1gwQhViAfoafFtVvk2NhooXXcff4ukZ60lAO9d1ucTGXdsKFo7m8IBbQDXKHd5L29Qig/N/xGgk/y1xjM2j5y91PxKTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776581284; c=relaxed/simple;
	bh=2MmzG3cRR1aKgD+UKpbqAf7Fhg7bEuEtKpA5yXbLh50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VpwPUQidd5I8MEhljJerqdxQqJefpWiabiefTSUycW8bsY1xt6DZM5RlZhHUGKZRxmSqnCHgDdqEbFkFIKu/C10nxe/YQW6xwQXRsgRYA6XmsA8ElkbT0q7PCo3eI0Z4M0OkHX2J9oRiNHB+UwLAWp3IUXNC9qyT3Kuhdlf86KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSUJxW2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSUJxW2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1ABCC2BCAF;
	Sun, 19 Apr 2026 06:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776581284;
	bh=2MmzG3cRR1aKgD+UKpbqAf7Fhg7bEuEtKpA5yXbLh50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSUJxW2XRzFVGAFiUM6bMl0WxKkzFgG37VNkJWEliljTJpiSMKMfWuu83iaXwhJ2/
	 dPPsFAxmDE3T1J2RRhlR+ErJHkdwQ+sSoHA7ZQyPV1BnqlRkUHE6VuaA7gNBACkBFY
	 ndnkAddc+7WFgR6JZxXWEmtbe551pijfsR9gObFM=
Date: Sun, 19 Apr 2026 08:48:01 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wxm-233 <lty2wxm@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] mac80211: lockdep warning from key debugfs creation
Message-ID: <2026041944-dallying-unsettled-6e38@gregkh>
References: <20260417171253.662-1-2200013188@stu.pku.edu.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417171253.662-1-2200013188@stu.pku.edu.cn>

On Sat, Apr 18, 2026 at 01:12:53AM +0800, Wxm-233 wrote:
> Hello,
> 
> We hit a lockdep warning in the mac80211 key-add path under
> syzkaller-style workloads.
> 
> We reproduced this on 6.19.0-rc5-00042-g944aacb68baf. In the same bug
> bucket, later runs still show the same warning on
> 7.0.0-rc2-g0031c06807cf.
> 
> The warning is:
> 
>   WARNING: possible circular locking dependency detected
> 
> The observed path is:
> 
>   nl80211_new_key()
>     -> rdev_add_key()
>     -> ieee80211_add_key()
>     -> ieee80211_key_link()
>     -> ieee80211_debugfs_key_add()
>     -> debugfs_create_dir()
>     -> start_dirop()
> 
> nl80211_pre_doit() keeps wiphy.mtx held across nl80211_new_key().
> After ieee80211_key_replace() succeeds, ieee80211_key_link()
> immediately creates per-key debugfs entries.
> 
> That debugfs_create_dir() call goes through debugfs_start_creating(),
> simple_start_creating(), and start_dirop(). start_dirop() takes the
> parent inode rwsem and lookup_one_qstr_excl() then allocates a dentry
> with GFP_KERNEL, which introduces fs_reclaim into the lock chain.
> 
> The warning becomes possible because there is already an existing
> dependency from relay_open_buf()/relay_create_buf_file(): that path
> holds relay_channels_mutex and then enters the same debugfs/VFS
> creation flow, which reaches the directory inode lock.
> 
> With both chains present, lockdep reports the cycle:
> 
>   fs_reclaim -> relay_channels_mutex -> inode rwsem -> fs_reclaim
> 
> This looks more like a real locking problem than a pure fuzzing
> artifact. The trigger is a syzkaller-style key creation workload, but
> the questionable part is that mac80211 performs non-essential debugfs
> creation inside the locked key installation path.
> 
> A possible fix direction would be to avoid creating per-key debugfs
> entries while still in the locked add-key path, for example by
> deferring the debugfs population until after the critical section or by
> moving it to a safer asynchronous context.
> 
> Relevant source locations in current trees are:
> 
>   net/wireless/nl80211.c: nl80211_pre_doit(), nl80211_new_key()
>   net/mac80211/key.c: ieee80211_key_link()
>   net/mac80211/debugfs_key.c: ieee80211_debugfs_key_add()
>   fs/namei.c: start_dirop()
> 
> If useful, I can also send the full report/log pair.

Why not send a fix for this so you get full credit for it?

thanks,

greg k-h
