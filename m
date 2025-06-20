Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7238D27E06D;
	Fri, 20 Jun 2025 16:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750435418; cv=none; b=fGMht01APo/Cl+GrgMxd2P0kJv7Ii2DqOxnKBf2A8u9iXH6uGaGOcTMDoiy3wH0uKWn5FuZfW7fbKIXxwgGIi7XhjuRVpttE1nr+sdoge1CumHmAEP4CbZcFL7Ps+Vt4rwHgtai3JMpmTYXgm8hgi/64paVCSfpzPqP9Ow+ncRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750435418; c=relaxed/simple;
	bh=Iequzwi+86n8dGQZFXVLDHKK6EnZSLS9t8ckcL1gxys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oIGlQqetToPoSCTZ9XCVEcPR+V2fupftsi1nW+rG24D7HPBkT3qAU0/lB+6FIsArCZvk3YXlL6kNJzPhy4Tr1ZpXW3qeqkV3jvuxAVAykXE3rQ0PS3SKjc18uxuid7tO1kBOUTPDNuICkxOfMN2QSKRKjuTAfZ6Mlf4waV3uR2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B4zdrCfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B4zdrCfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921DEC4CEEF;
	Fri, 20 Jun 2025 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750435416;
	bh=Iequzwi+86n8dGQZFXVLDHKK6EnZSLS9t8ckcL1gxys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B4zdrCfGKoiybDB/pZLmCg19Acjg8LDr8mbquX9IbSLht6b38zcqMYhdvRGBuqVwW
	 xGBcE8uv1mF7isxO7y9/OQhzodL+NfhcW5q3NPBhFPexiVja60bQQdqWok0PCCcJUn
	 q4nVEZqn/wfxqyJG/MqZIw7WTI3MVTDGs/w1zbJ0=
Date: Fri, 20 Jun 2025 18:03:34 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: sashal@kernel.org, stable@vger.kernel.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+aaf0488c83d1d5f4f029@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 6.1/6.6] wifi: cfg80211: init wiphy_work before
 allocating rfkill fails
Message-ID: <2025062021-omen-charger-a00b@gregkh>
References: <A203ED8C00632F28+20250620031949.227937-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A203ED8C00632F28+20250620031949.227937-1-wangyuli@uniontech.com>

On Fri, Jun 20, 2025 at 11:19:49AM +0800, WangYuli wrote:
> From: Edward Adam Davis <eadavis@qq.com>
> 
> [ Upstream commit fc88dee89d7b63eeb17699393eb659aadf9d9b7c ]

What about 6.12.y?  Why forget that kernel?

confused,

greg k-h
