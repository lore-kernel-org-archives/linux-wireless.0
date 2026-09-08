Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D736521204;
	Tue,  8 Sep 2026 09:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860627; cv=none; b=R84SbcV3AOkIsJMQe+htk4onzxKpQcS7/HmtYIH8jLNxOTZgm/rxHP6nhCfqVB63M6Q6ilRP5rX8uFN/HR7jSZNTqoPs1UpK+VaEL1a75NqjcRMLEGCZecVu3WEcnpx+JJnnfyNVKMiKbmZ3y5ytaW1yUTAz/xOj2Q0s8lZm8l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860627; c=relaxed/simple;
	bh=SNlQfLJGwH5xSMDt0hHXrZqLLWry6UvPZjfwOYDVLIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbBUIXjCND5lvQqLIGEsCUjtxtdRMxhgUfW/uJs7jbAbpAJQHGKxrdMNN8LoWkS0dS0/tgzBEszDGmbPdObKIULRBK66ZDf1N+DJl2J2yU28xmGWSR/99LAXzwV1CU9hZ/uvZRiKio+uMPXJkgkxn2xop5pNhgGIC0Gi/XU8kfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b=FvOi+Muv; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=spasswolf@web.de header.b="FvOi+Muv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1788860623; x=1789465423; i=spasswolf@web.de;
	bh=iu30+b5QM22TFZHLYqmwV7JbJwOlHCmmiiW/Odjg9jE=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FvOi+Muvq5AQ9V6MYG/sC766uAX26TJkpE969T4Nn31E8LjGciy4QrDyifuCuRD/
	 4B6efiNOU7qV7Kxh2ucLfRcRzWJcfvF8XbEnGHKsJ5aWR7L1gwF0II48uvlOw5q1Y
	 oaIK7spAikacOJAQfWJFduP97+qlFm3LFGz2qJDApyZMlZzi2CP2xfX/QdoJziDBo
	 Dghzx34t+OL+lCLwrrPz/Kusm8buPK/PWaNpZK6ACUsoG++i+ZBGKZ99mFxE164nr
	 ZL2x666fxHscDsHBSzlsWQHeDvfUV+yEWcAxuqUbXodJuCxlV+C3upzJ/JlDNymf/
	 3+xcXnOvEhdi/pzoNA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MQ8Wg-1xGzN83x68-00JjEX; Tue, 08
 Sep 2026 11:43:43 +0200
From: Bert Karwatzki <spasswolf@web.de>
To: Johannes Berg <johannes.berg@intel.com>
Cc: Bert Karwatzki <spasswolf@web.de>,
	linux-wireless@vger.kernel.org,
	linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	johannes@sipsolutions.net
Subject: [PATCH] mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
Date: Tue,  8 Sep 2026 11:43:40 +0200
Message-ID: <20260908094341.12196-1-spasswolf@web.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802105818.0feb7ad61047.Ia506ca211176a3c466bc60e4cc3e506df34a4a67@changeid>  
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CJpzYiPklCvrVCwQj6s5KWzuPEi5II86n1gJlNTseC5M1s8qRTg
 XFnQtbq8t6RSJPfLP0LRc0qXHugWhDHCDNFBMCL1Cix84jjTVwt2joLRLYkaEX4uSo5OEqh
 +/kJ5TsPTmx/QhglhWWSpDiu9jt1aqyMH5Wv3Kz1vdKwERjE3kWlEcDbSPe2tEf1kr251zX
 kzlt3ycKr0rDw2FwgyAIA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3kAMO3LRkc4=;OAu6f91cvcnTHWzk3knBefp/erh
 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

Without this ieee80211_select_key_8023() is never called and wifi never
connects.

Fixes: 0e80db08668b ("wifi: mac80211: fix key selection for encap offload =
frames")

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
=2D--
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 13a51a0a0358..d1d3266697b1 100644
=2D-- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -648,7 +648,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx=
)
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)tx->skb->data;
=20
-	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
 		return ieee80211_select_key_8023(tx);
=20
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
=2D-=20
2.55.0

I noticed that in next-20260907 my wifi adapter fails to connect to the
wireless network. As this still worked in v7.3-rc2 I bisected the issue
and found the offending commit to be this merge:

commit d1352d1b277913736903eff185191c4f9723e0de
Merge: 7e615d9c216c 1b60ed34f712
Author: Mark Brown <broonie@kernel.org>
Date:   Mon Sep 7 13:26:24 2026 +0100

    Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel=
/git/wireless/wireless-next.git

So I examined the patch created by
git diff 7e615d9c216c d1352d1b2779
by applying it piece by piece to commit 7e615d9c216c.

The result of this procedure was the patch above as a minimal fix in
next-20260907.

The wirless hardware used is this:
09:00.0 Network controller [0280]: MEDIATEK Corp. MT7925 802.11be 160MHz 2=
x2 PCIe Wireless Network Adapter [Filogic 360] [14c3:7925]

Using printk()s in ieee80211_select_key_8023() (in next-20260907) I
noticed that ieee80211_select_key_8023() is never called when using
the info->control.flags test.

Bert Karwatzki
