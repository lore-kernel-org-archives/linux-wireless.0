Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50706 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2LVDnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 22:43:14 -0500
Received: by mail-ee0-f47.google.com with SMTP id e51so2694320eek.34
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 19:43:13 -0800 (PST)
Subject: [PATCH -stable 3.7] carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, quantheory@gmail.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 22 Dec 2012 04:35:24 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201212220435.24719.chunkeey@googlemail.com> (sfid-20121222_044318_682398_7C267D55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sean reported that as of 3.7, his AR9170 device no longer works
because the driver fails during initialization. He noted this
is due to:
"In carl9170/fw.c, ar->hw->wiphy is tagged with
NL80211_IFTYPE_MESH_POINT support if the firmware has Content
after Beacon Queuing. This is both in interface_modes and the
only iface_combinations entry.

If CONFIG_MAC80211_MESH is not set, ieee80211_register_hw
removes NL80211_IFTYPE_MESH_POINT from interface_modes, but
not iface_combinations.

wiphy_register then checks to see if every interface type in
every interface combination is in interface_modes.
NL80211_IFTYPE_MESH_POINT was removed, so you get a WARN_ON
warning and it returns -EINVAL, giving up."

Unfortunately, the iface_combination (types) feature bitmap
in ieee80211_iface_limit is part of a const member in the
ieee80211_iface_combination struct. Hence, the MESH_POINT
feature flag can't be masked by wiphy_register in the
same way as interface_modes in ieee80211_register_hw.

Cc: <stable@vger.kernel.org>
Reported-by: Sean Patrick Santos <quantheory@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
only compile tested.
---
 drivers/net/wireless/ath/carl9170/fw.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index aaebecd..63fd9af 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -336,8 +336,12 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
 			if_comb_types |=
 				BIT(NL80211_IFTYPE_AP) |
-				BIT(NL80211_IFTYPE_MESH_POINT) |
 				BIT(NL80211_IFTYPE_P2P_GO);
+
+#ifdef CONFIG_MAC80211_MESH
+			if_comb_types |=
+				BIT(NL80211_IFTYPE_MESH_POINT);
+#endif /* CONFIG_MAC80211_MESH */
 		}
 	}
 
-- 
1.7.10.4

