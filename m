Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33143793DE
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 17:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420581; cv=none; b=RjHx+Hx082rKV3XdFwxCVUkRhhYq7MesCW2pdFe1powzeq4jzCHnCg+SYO2eZEY2/T8+jK7qu81OskUuhj4nG4IG3OFjWpY9Cg0emczfoNRAmTdDUsPt570IjeYOxceK0+M+qtHkeQmTNpsTFTXafX1mWe8XVehKCnktJYxwTmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420581; c=relaxed/simple;
	bh=K3ZITh8TrwNoRq0QwdUOQbQjYERm4RsYnPBzkBoYiwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbsX3535tWKiVU1EOlI5mAbHYk5epbJFoMDwTOyFdWxPcTkilbwW0QQC9KzmPDgSMZx3cKKWVAn2k1mHn4XxIOUMR1zz8WblccSXFBczmA3jFJCQuPGEWBaygJjOKQsTvHUUyJYNvQNIXq8DJ+DbygFC2uF3IpiFlH0THW7oKPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ArlOxxXd; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ArlOxxXd"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c214321dc32so406704666b.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787420577; x=1788025377; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ftNd6Rqboz6yz0GJ3lruJ17651I4VX02H1X2TJeM0ak=;
        b=ArlOxxXd+JSgmXrf7ajGFTRfBVe+afKcQ2p1TD+QH6XA0QcTYEKPvUMqxcFh7bK+U0
         8zUzShfEffwFaftv9NB9vBWm9+7dJO29JK3YzjXRSRnbNuHzmK5K1pU5dWH6FAWO4rnS
         hT3OT0r4W2QV809juX50ByQrSggLWzd/6UqcL8AnSpBao6clC89HXLNMj/0DdmrmIgSm
         okshJw0MV2QJ8PTF1FoE2ASkVAhMy9HqNLb8qK5h9oT9gOoyr0+W/mzhFycBoXbE0HoF
         p634lmTQ2jF4xQnl61BIDUYy70gjt5J87GEkLNrOs1y7M/OD3XbmsDOQIzFitm3C3Shs
         6P5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787420577; x=1788025377;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ftNd6Rqboz6yz0GJ3lruJ17651I4VX02H1X2TJeM0ak=;
        b=HHdyTSy4TvyDsxpLwsysvPDTS29tcS/2VrbL6b1r48QySy1xhtVVhNe6H4vhbN6ATY
         iI/c/7dgkquBgKIqvavMKZP7HDAMCPUx6bZfS5nsTPZ0kplpaYrM7QDyXQWBqFmq0mxU
         VKEt1V/oWgte48rnq1QkWdG6HSDldp8URZsMik6gbltccbi1kwQ2xzPF4daS65UDsQG9
         H8pADXLewtoHcFEiwXCFPejJYYtWFIPuhOkqWzoavEM9xiLuXxcPcEIhQwTjzjPp6SZy
         fB5Opn9oxa0CTkM6f+j9VPTmhgTUQchp+y/Tog1qsYVBG5VgB7o0PSwsmIRdJGJgH2P+
         /lhw==
X-Gm-Message-State: AFuF++n0TpAJ9avC2fe+MOql1lXJ+32FVuAAB1vDp4pcHKWT7MJIWcB1
	neSfiNzAHidJQ7n6oANUeYwEbCitXFZmCZXfqJNWypgnvnNo7nTPB/wVkMiPrMhP
X-Gm-Gg: AR+sD13hGYx02HU1Ylj9FCtEt0KW+5YB3bU21R80vtZVq2WBiKA8yr3QY9xWYRu5CHZ
	YxIqcSXvKJKHigRkD/xZQmdGep/wbuWqDvB5LZMrFijyDIqABtQAP+gB7ZyW0dVjFAofbsqpxtb
	kFx6BOyOQAn9ERL2xDdOILRU+gqElw3sVa+Tww30fU1k4aeKov9wsvSdmuDKHNA31L6qiv0O8jH
	ZQJ49WjLXfLoK5qi2HTVOFWIL86kvIHrdh+ziUA71eGao7Q/nOUeF5C+IWEiX/QxD6aL8Twpk41
	jEwmjnQQb2oGbh7ayOgurrJJHk3O8T94MmkfjIqOQ4u2bBJk8UyJ3PLd8qiVyB6i16wQsl/lWgm
	AVrZ95c/rPr+ItPH44apvM3F2115smEQ2uuODrSm0jC4y//+Dnr6KQ7UzsQvwuKQpU503JeH0au
	28V61FSvFD4juJ7PfaQqQoR4RL+OQXkK5XhjJegC1xXksbK9DzeAV5Xh6NP93DJBgcEGBI75z0Y
	a/8QpsDEQQ0Az61Z6riWWXU3SCh
X-Received: by 2002:a17:907:d0d:b0:c24:87e5:6491 with SMTP id a640c23a62f3a-c2487e58617mr1219703466b.2.1787420577426;
        Sat, 22 Aug 2026 10:42:57 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm334367466b.57.2026.08.22.10.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 10:42:57 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: andres parra <andres.parrab@gmail.com>
Subject: [RFC PATCH 3/4] wifi: rtw89: handle P2P_DEVICE in net_type/self_role switch
Date: Sat, 22 Aug 2026 19:42:28 +0200
Message-ID: <20260822174229.65643-4-andres.parrab@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260822174229.65643-1-andres.parrab@gmail.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rtw89_vif_type_mapping() has a second switch (vif->type) beyond the
wifi_role mapping already fixed -- this one sets net_type/self_role
and also ends in a default: WARN_ON(1). Live-tested on real hardware
(RTL8922AE): the moment wpa_supplicant/NetworkManager requested a
P2P-Device wdev (NL80211_CMD_START_P2P_DEVICE), this WARN_ON fired
immediately, confirmed via the exact call chain this project's
BUILD_LOG.md had already traced by hand: nl80211_start_p2p_device ->
ieee80211_start_p2p_device -> ieee80211_do_open -> drv_add_interface ->
rtw89_ops_add_interface -> __rtw89_ops_add_iface_link ->
rtw89_vif_type_mapping.

This second switch was present in the original research grep
(core.c:5702, two switch(vif->type) sites found) but was not actually
read/analyzed at the time -- a real gap in that research pass, caught
by this live test rather than by review.

Add NL80211_IFTYPE_P2P_DEVICE alongside the existing MONITOR case,
which also just breaks without setting net_type/self_role: a
P2P-Device interface has no BSS/association state, so leaving these at
their zero-initialized defaults (RTW89_NET_TYPE_NO_LINK,
RTW89_SELF_ROLE_CLIENT) is correct, same reasoning already applied to
MONITOR.

Verified live: after this fix, wpa_supplicant successfully created a
real P2P-Device wdev (confirmed via `iw dev`: phy#1 now lists a
non-netdev interface, type P2P-device, alongside wlan0), with zero
WARN/BUG in dmesg for the whole boot, and normal STA association/
roaming continuing to work correctly (multiple successful associate/
reassociate cycles observed with this driver loaded).

Signed-off-by: andres parra <andres.parrab@gmail.com>
---
 core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/core.c b/core.c
index c8f12ef..b4f8d27 100644
--- a/core.c
+++ b/core.c
@@ -5734,6 +5734,7 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwvif_link, bool assoc)
 		rtwvif_link->addr_cam.sec_ent_mode = RTW89_ADDR_CAM_SEC_NORMAL;
 		break;
 	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 	default:
 		WARN_ON(1);
-- 
2.55.0

