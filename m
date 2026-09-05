Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117BF5478D;
	Sat,  5 Sep 2026 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788633958; cv=none; b=h7yD4BDwd3fL4Fm42YJIG7X7BwJDLAYpmPcZ/e3Blv1UUVWS4W6pB/I5voM9F0CRQFt7zVFm21cKfOPvyk5QGeKLhPPeW5Ani0o1HIh97G/MQ74iqDR+aEvit6UBWj7fA8oiuuoF9HckRRTUSG5H7jQgY3RKCuyD6pkk7Cc80Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788633958; c=relaxed/simple;
	bh=A5WYoYJGPksF4SlhsnebSk2XOMVxE1RM7R/R0ylAkMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml7u81P1owU/A9hFCDylRhv7ZjabC/SP42AtqiRZC7nxxEHNPeo/TkSC73tZ4CALijiRBGws5YkZSMGfNYQzKWS7ZwUEWvFWfCdkPMMqJl6NwfGIsj6lM5qyqZFH5q39sN7SK97rCWVjbqp2UweDSzHzQ/7RrLV97SdBe5KUWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bX51lFzJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bX51lFzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C600F1F00A3D;
	Sat,  5 Sep 2026 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788633956;
	bh=sx65DJpNyhboJaajpJO1jJBfCnGS4AGckNMvfVqKdLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bX51lFzJjYzcVIXAYeq95vlzEGE8iMm2nWnwjdE4TIE4koPh/hcAz1NG5y4IYOuZy
	 e0CnExlvEyICyd7KwoH/NHUVgXBHFTZIr5shBJN8yJ6gf2j5DXg3VRv1dcEipsMxRd
	 lV1iNXos/kRE6TKbhRGk1CdxZHSqBIU2zmyug8K0f8MbNseXYd1gq+DUbQTlIbqSz2
	 JW3h5nGPML/irWNdOo85+f+/ZvnAt2Aw+N1A8b4U7EC5rymet5Lq++chSVa35jb0v7
	 K0LhY2udnT95jVrIeltRB7dUizdnFT+ZqRL3yESyLrR4ZLST5mbupE4oareo43WVPB
	 XfJUwr3IEOLXQ==
From: Simon Horman <horms@kernel.org>
To: omermetekaya0@gmail.com
Cc: Simon Horman <horms@kernel.org>,
	linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net,
	kvalo@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+adeb8550754921fece20@syzkaller.appspotmail.com,
	syzbot+101224300649c3eb8af4@syzkaller.appspotmail.com,
	syzbot+8141dcbd23a8f857798a@syzkaller.appspotmail.com,
	syzbot+b0ae8f1abf7d891e0426@syzkaller.appspotmail.com,
	syzbot+d6bbe0f5705cb8a5aa2b@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls
Date: Sat,  5 Sep 2026 19:45:45 +0100
Message-ID: <20260905184545.172168-1-horms@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903151542.486376-2-omermetekaya0@gmail.com>
References: <20260903151542.486376-2-omermetekaya0@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev/#/patchset/20260903151542.486376-2-omermetekaya0@gmail.com?part=1
---
wifi: cfg80211: avoid holding rtnl_mutex across all cfg80211_leave() calls

This commit changes reg_check_chans_work() to iterate over cfg80211_rdev_list
using RCU instead of holding rtnl_mutex for the entire loop. It acquires
rtnl_mutex on a per-device basis to prevent task hangs.

> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index a8336baf85dc6..a2e0d1cf8317c 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -2466,12 +2466,21 @@ static void reg_check_chans_work(struct work_struct *work)
>  	struct cfg80211_registered_device *rdev;
>  
>  	pr_debug("Verifying active interfaces after reg change\n");
> -	rtnl_lock();
> -
> -	for_each_rdev(rdev)
> +	/*
> +	 * Acquire rtnl per-device instead of holding it for the entire loop;
> +	 * cfg80211_leave() can be slow and starve other rtnl waiters otherwise.
> +	 * wiphy_unregister() holds rtnl across list_del_rcu() + synchronize_rcu(),
> +	 * so rdev cannot be freed while we hold rtnl_lock() below.
> +	 */
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
> +		rcu_read_unlock();

[Severity: High]
Does dropping the RCU read lock here remove the lifetime protection of the
current rdev element while waiting for rtnl_lock()?

If a concurrent thread unregisters the device (for example, via
wiphy_unregister()), it could acquire rtnl_lock, remove the device with
list_del_rcu(), and call synchronize_rcu().

Because the RCU read lock was dropped by the work thread here,
synchronize_rcu() could complete and allow the unregister thread to free rdev
before this thread acquires the rtnl lock.

> +		rtnl_lock();
>  		reg_leave_invalid_chans(&rdev->wiphy);

[Severity: High]
Can this regression lead to a use-after-free?

If rdev was freed during the race window while waiting for rtnl_lock(),
accessing rdev->wiphy here would read from freed memory.

> -
> -	rtnl_unlock();
> +		rtnl_unlock();
> +		rcu_read_lock();
> +	}

[Severity: High]
Will the list_for_each_entry_rcu() macro implicitly dereference
rdev->list.next to continue the iteration after the loop body finishes?

If rdev was freed while the lock was dropped, does this result in another
use-after-free when advancing to the next list element?

> +	rcu_read_unlock();
>  }
