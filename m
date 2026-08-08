Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FD23DB326;
	Sat,  8 Aug 2026 14:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.67.55.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786200491; cv=none; b=CoUFVhhyY11dmPB1fx56aoqQzFoPDEJZYAB5P5oexJQ9v/i84LfQKn6BnX4B7W0Dn4l/gBsh3GmU7ZrUvc+SU/UKOMijYzRbCNVlGJxQRQ5SLYMhVQB/ajxPbcx0prh2dixmbFTaXbw7KGMvv8bpcWjAGK8vPIX/ca3GnbD3ZNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786200491; c=relaxed/simple;
	bh=yTTFd8O1LYrFw7p0Qs/OST2M6/47gL4Fm++Y1YgNMMk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=jRW5EAK9l/iGhzMbMVsGoJiyML1xxdKktip+7Raz6rK68hvISEj5Uz+bvXnbEBGIINivzt0D452JeZ+ftC8AtZAtlej9n5XM7wGPJlvzuGQwN7E69m5cBf47eYFAwN2tk3pUwNrTTQGDYv/O6AAm+Whw/FiqZO3g/xQ6Di3v6SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com; spf=pass smtp.mailfrom=surriel.com; dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b=XWPPdfur; arc=none smtp.client-ip=96.67.55.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=surriel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=surriel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=surriel.com header.i=@surriel.com header.b="XWPPdfur"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=b9Ey9HydJ5tvmYklKCi/JaUrXhz1LSF8DSZDroT9ynE=; b=XWPPdfur3dwBrmHv5ZUxN7iqgK
	CXXr0OyNfGJ1T5qLvAp50i+Zx9cfvLKS6P02+ewZ5+rl7Yc4S13D0k3coq1JUyc7I+vPfd6iZbD6f
	IZXBEDSInk9NnKi/P5vq8OVvYK2YjB484d0r7j6YRNJiHULMpxRwMWbvEhY1zQuVHxq9rdCNhRfgY
	7RGNfpkCg+CnMvCjBsAoZIddEIYSPZS0tqgcPWfWIcvM2mjTCv6z0hrqgzqC759YKc2sOtNyw6Tj8
	zLp3FqeMRt32onqkx+cbqZtVYHVV3ux8lx2Q+4B0TTu/rF9T5V0H8/6WnbZOTEZvbW1u1+Fbffdn5
	XIcb6RHA==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wsiL5-000000001DA-21sd;
	Sat, 08 Aug 2026 10:47:55 -0400
Date: Sat, 8 Aug 2026 10:47:55 -0400
From: Rik van Riel <riel@surriel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: mac80211: avoid WARN in set_bitrate_mask when sdata
 not in driver
Message-ID: <20260808104755.319c686e@fangorn>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

ieee80211_set_bitrate_mask() checks if the interface is running via
ieee80211_sdata_running(), but it does not check if the interface is
still present in the driver.

When sdata is running but IEEE80211_SDATA_IN_DRIVER is not set, the
call reaches drv_set_bitrate_mask() in driver-ops.h which hits

  wlan1: Failed check-sdata-in-driver check, flags: 0x0
  WARNING: net/mac80211/driver-ops.h:884 at drv_set_bitrate_mask

Syzkaller triggers this via wext SIOCSIWRATE ioctl. The Call Trace shows
wext_ioctl_dispatch() in wext-core.c dispatching the ioctl, calling
ioctl_standard_call() for SIOCSIWRATE, which calls cfg80211_wext_siwrate()
in wext-compat.c. That builds a bitrate mask and calls
rdev_set_bitrate_mask() which ends up in ieee80211_set_bitrate_mask() in
cfg.c. The interface is marked running via SDATA_STATE_RUNNING but
flags is 0, so check_sdata_in_driver() fails.

When the interface is being torn down, or when wext ioctl is issued
during interface bringup before drv_add_interface() sets IN_DRIVER, the
running check passes while IN_DRIVER is clear.

Check IEEE80211_SDATA_IN_DRIVER in ieee80211_set_bitrate_mask() before
calling the driver, returning -ENETDOWN. This avoids the WARN_ONCE in
driver-ops.h and matches other cfg.c operations that bail early when not
in driver.

This change should be safe because wiphy mutex is held in
cfg80211_wext_siwrate() via guard(wiphy), and IN_DRIVER is set/cleared
under RTNL and wiphy paths in drv_add_interface() and
drv_remove_interface() in driver-ops.c, so the check is race-free
against driver add/remove. Returning -ENETDOWN is the same error other
not-running paths use and does not introduce new locking.

Reported-by: syzbot+af177aa139efdd13a9da@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=af177aa139efdd13a9da
Link: https://lore.kernel.org/all/6a75205c.59b6c763.2bba34.00c3.GAE@google.com/
Fixes: 554a43d5e77e ("mac80211: check sdata_running on ieee80211_set_bitrate_mask")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 43f142624d33..b66baa98b98d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -4113,6 +4113,9 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
+	if (!(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return -ENETDOWN;
+
 	/*
 	 * If active validate the setting and reject it if it doesn't leave
 	 * at least one basic rate usable, since we really have to be able
-- 
2.55.0


