Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59056 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbZALUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] =?utf-8?q?mac80211:=20fix=20"=E2=80=98ret=E2=80=99=20may=20be=20used=20uninitialized"=20warning?=
Date: Mon, 12 Jan 2009 14:48:57 -0500
Message-Id: <1231789741-13433-1-git-send-email-linville@tuxdriver.com> (sfid-20090112_210112_032060_3EE20251)
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/ht.c: In function =E2=80=98ieee80211_start_tx_ba_session=E2=
=80=99:
net/mac80211/ht.c:472: warning: =E2=80=98ret=E2=80=99 may be used unini=
tialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ht.c                |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
 delete mode 100644 arch/arm/mach-integrator/clock.h

diff --git a/arch/arm/mach-integrator/clock.h b/arch/arm/mach-integrato=
r/clock.h
deleted file mode 100644
index e69de29..0000000
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 5f510a1..c5c0c52 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -469,7 +469,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_=
hw *hw, u8 *ra, u16 tid)
 	struct ieee80211_sub_if_data *sdata;
 	u16 start_seq_num;
 	u8 *state;
-	int ret;
+	int ret =3D 0;
=20
 	if ((tid >=3D STA_TID_NUM) || !(hw->flags & IEEE80211_HW_AMPDU_AGGREG=
ATION))
 		return -EINVAL;
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
