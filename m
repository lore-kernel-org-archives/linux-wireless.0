Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C15E473C8D
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 08:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941182; cv=none; b=eNw+1MF+JKc0F0A8Gr2KNYp93hjLAtByd++Epo0nKSxG49i4ywSPpOlF/qtBmqOpBnSf3kGyRgk62z2On5haAYfaB8rc1QLgaU1GoGSZnSL3ug28x8l0xtD4j/XBn3/WrFylcolKyBhflTUabP+69hkyGeWpQDkMFC3Gr8XC3sI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941182; c=relaxed/simple;
	bh=b4LGCy/GrxP1awJTsj7G1lWhqhYhfO4g1y2Zo2OpBU4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S8q9Zhr8wFEz1Z5zOzbK3Lp1sEOuP2gJh6yG0qKS1gX9Jpiv1nGpMOSD2P2mVTHUz5nndxRrYJWz+YF6WsjRRuwXVWdd1m6Oo9QU35LbHgSSy+yPgO3+jK8bUF9B8caWT5o0Fma2EAMojMnTwiXX/S4VrNKd1SVOWXT1xblXMWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RQFnFA5H; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQFnFA5H"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d5cad1a6baso52419295ad.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 01:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788941180; x=1789545980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PmWvJz1TICTrxOO/Zb6x1aIAwyMn3XoHLpkJReMqVNM=;
        b=RQFnFA5HLykYJRAD9AxOT7UXrHlzkjUNu0vGe2iMsiGuf3B0HCR+xElZaZ80yQwN//
         4ak2o7Gg65UdJ+EqR7HvnWQNCk9Vh2n9HMy9v7PBtxGG0uiCkMqBcryQaUR0GcL/BA/Z
         I8GDAIh1/JT5XqfGp6VilrhFfX0iUwPP7uoXKhUEeIBqp0r50MLtMzgSUPzH4aK2C+Qa
         afPARpVmglJW1oOjtVHBMmakgVLLXivx8tOXkP7QTU/WXJJfxIn0y7/NyiMZuqDj7NIz
         YvcM1GdKgs8V8qQN87oaXHgS6k+53G5h4UQY9ESlwFyo4R3rNukFvi5dW+72br5Ynjd9
         ojMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788941180; x=1789545980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PmWvJz1TICTrxOO/Zb6x1aIAwyMn3XoHLpkJReMqVNM=;
        b=atpfdFcokYxiz963dsej/nIEBMEE2yoOG7KjMKnH16lqUu9L8o+dqDXRZSJp2qB1Q3
         7Egue/hOBRxxWDu69XxPTEznW++xx+5HjgZu9b+1kF4MYl1L2fEn/QMKQLBCn4Nb6GQ/
         QF4RSopf14t073NJx8NhMnbxQxeZayGKT3z5eMpwP8B3clQ45FAtAmmzQjX4PP3HdW8X
         9q7JhYt6BMQ7IUYfTmkM5AS8ftJHy1+Gjs/CHSm8/Wu/87cQ1i9FCKfXgJDOARAvKHH8
         9m2ftoWcTy9fpJZDw2nVnH1zdxTZO6NozXuGN/jjl2/id7SNbd12B6wMYOfAMbs6XU8G
         JpXA==
X-Gm-Message-State: AFuF++nGMkBGokOxVba/maVzaBEgeXjgXU8QKr2FJM6Kc2nTPi5//w4M
	niFHQVIZT2VPeCQFu1THPkZ4JX0t/O/zlA2xoZcJkzho78J0pNCtMDac4r9sRnIWMEw=
X-Gm-Gg: AYBFou1SxTpBtmv7aRhkr5F+UjGuKgeieGfa9ayWmnhOUFf1YXeX6NOhvgUFcR4HUCf
	DAmAQn+j3aac1cJrVXttKxNO+R79uCApfaru6+kVqD4MxHY79sQ6VzytvsEdSZ9aY9A18G810jV
	lvDDNpKux96dBxl5LZrsmVsrB4flZEhKKk8B2hrrT3fR2Qk9r21jd0Lf4xiSfC8pNPhlTa1toB2
	zNLkokIyRP8Sxc2/dE4Y8Dmqpl1Sz/FZ2CixaEVlBoP3WHVeNuB1/8q+CT26yzHwZnHfIc8KCzx
	IYD48dUlXcz6lEV//2X82MNU4hiLNZ7tXZl1tPgDFjoy/WHe8SkhLeAIZ17H+0dGsn44OcmlzBG
	Mj0Sqt/YKzCWonbg6ovRXAuVtI6RXy/rV/cccVF5PGITiPvOGL8YioVkSwDhJug5/OPJBJVayAH
	f98tVi+YUqpyIUQzySYZT9DUabAKIhqDtGTcrQGy5RQg+wRCDj1pSu4YQlnK9cUeDpcR8UiV+L2
	uTVhu3d7bAibtqUQ0Qihunm1G4cXGpDGwuet920pj7lOdEUqmdPHuZqMIc=
X-Received: by 2002:a17:903:2ec5:b0:2cf:8131:75e8 with SMTP id d9443c01a7336-2db125c412dmr528690055ad.13.1788941180081;
        Wed, 09 Sep 2026 01:06:20 -0700 (PDT)
Received: from localhost.localdomain ([2405:1202:c2a4:2d00:91c9:34c8:7e7b:4100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149c3b80sm69378935ad.63.2026.09.09.01.06.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 01:06:19 -0700 (PDT)
From: Ryohei Hashimoto <laurel.medalist12@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2] wifi: brcmfmac: log the firmware status when a connect fails
Date: Wed,  9 Sep 2026 17:06:03 +0900
Message-ID: <20260909080603.2955-1-laurel.medalist12@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

brcmf_bss_connect_done() receives the firmware event in @e but discards it
on the failure path.  Every failed connect is reported to cfg80211 as
WLAN_STATUS_AUTH_TIMEOUT (16), whatever the firmware actually said, so
userspace only ever sees:

  wlan0: CTRL-EVENT-ASSOC-REJECT bssid=00:00:00:00:00:00 status_code=16

The all-zero BSSID comes from the same place: conn_params is memset to
zero and profile->bssid has not been filled in when the station never
associated.

status_code=16 therefore carries no information about the cause.  It is not
an AP response and it does not mean "authentication timed out" - it is the
only failure value this driver can produce.  This is a recurring source of
confusion: [1] has been open since 2023 with more than twenty follow-ups
and no explanation of the code, and covers BCM4345/6, BCM43430 and
CYW43455 across several kernel versions.  It supersedes [2], filed against
the firmware repository a day earlier and closed in favour of it.

The firmware's own status (BRCMF_E_STATUS_*) is more specific - FAIL,
TIMEOUT, NO_NETWORKS, ABORT and so on - and it is already in hand.  Log it
so the cause can be narrowed down without rebuilding the kernel.

bphy_err() is used rather than brcmf_dbg() or brcmf_info(): it is the form
the rest of this file uses, and of the three it is the only one that is
both visible in a distribution kernel and bounded.  brcmf_dbg(CONN)
expands to no_printk() unless CONFIG_BRCMDBG is set, which is what makes
the reports in [1] and [2] impossible to act on - the people hitting this
run stock kernels.  brcmf_info() expands to a plain pr_info() in a
non-debug build and is not rate limited, and wpa_supplicant retries the
association every few seconds, so it would flood the log.  bphy_err() is
guarded by net_ratelimit() there, so a station retrying against an
unreachable AP prints at most a few lines per second.

All three fields are printed because only some of them are meaningful on
each path into the failure branch.  brcmf_is_nonetwork() keys off @status,
so that is the useful field for a join that never associated - the case in
[1].  brcmf_is_linkdown() keys off @event_code and @flags and does not look
at @status at all, so @status can read 0 there; on those events it is
@reason which carries the 802.11 reason code, as the mapping in
brcmf_map_fw_linkdown_reason() shows.  Printing the three together lets
the reader tell which path was taken instead of guessing from one number.

The status reported to cfg80211 is left alone; changing it would alter what
userspace sees.

[1] https://github.com/RPi-Distro/firmware-nonfree/issues/38
[2] https://github.com/raspberrypi/firmware/issues/1829

Signed-off-by: Ryohei Hashimoto <laurel.medalist12@gmail.com>
---
v2:
  - use bphy_err() instead of brcmf_err(); it is what the rest of
    cfg80211.c uses and it names the wiphy in the message
  - correct the commit message: brcmf_is_linkdown() keys off @flags,
    not @reason
  - tag the target tree in the subject
v1: https://lore.kernel.org/linux-wireless/20260909064125.67844-1-laurel.medalist12@gmail.com/

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 872c488..114dabb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6522,6 +6522,8 @@ brcmf_bss_connect_done(struct brcmf_cfg80211_info *cfg,
 			clear_bit(BRCMF_VIF_STATUS_ASSOC_SUCCESS,
 				  &ifp->vif->sme_state);
 			conn_params.status = WLAN_STATUS_AUTH_TIMEOUT;
+			bphy_err(ifp->drvr, "connect failed: event %u status %u reason %u\n",
+				 e->event_code, e->status, e->reason);
 		}
 		conn_params.links[0].bssid = profile->bssid;
 		conn_params.req_ie = conn_info->req_ie;
