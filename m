Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63134 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZASJCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 04:02:51 -0500
Received: by bwz14 with SMTP id 14so7895949bwz.13
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 01:02:49 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] iwl3945: fix some warnings when compiled  without debug
Date: Mon, 19 Jan 2009 09:55:04 +0100
MIME-Version: 1.0
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=utf-8
Message-Id: <200901190955.04622.helmut.schaa@gmail.com> (sfid-20090119_100256_705388_7BA8EF01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46ix the following warnings if compiled without CONFIG_IWLWIFI_DEBUG.

drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl39=
45_rx_reply_add_sta=E2=80=99:
drivers/net/wireless/iwlwifi/iwl3945-base.c:2748: warning: unused varia=
ble =E2=80=98pkt=E2=80=99
drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl39=
45_rx_scan_results_notif=E2=80=99:
drivers/net/wireless/iwlwifi/iwl3945-base.c:2903: warning: unused varia=
ble =E2=80=98notif=E2=80=99
drivers/net/wireless/iwlwifi/iwl3945-base.c: In function =E2=80=98iwl39=
45_rx_scan_complete_notif=E2=80=99:
drivers/net/wireless/iwlwifi/iwl3945-base.c:2928: warning: unused varia=
ble =E2=80=98scan_notif=E2=80=99

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/=
wireless/iwlwifi/iwl3945-base.c
index b437cac..15d36d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2744,7 +2744,9 @@ static void iwl3945_rx_reply_alive(struct iwl_pri=
v *priv,
 static void iwl3945_rx_reply_add_sta(struct iwl_priv *priv,
 				 struct iwl_rx_mem_buffer *rxb)
 {
+	#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;
+	#endif=20
=20
 	IWL_DEBUG_RX("Received REPLY_ADD_STA: 0x%02X\n", pkt->u.status);
 	return;
@@ -2898,9 +2900,11 @@ static void iwl3945_rx_scan_start_notif(struct i=
wl_priv *priv,
 static void iwl3945_rx_scan_results_notif(struct iwl_priv *priv,
 				      struct iwl_rx_mem_buffer *rxb)
 {
+	#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;
 	struct iwl_scanresults_notification *notif =3D
 	    (struct iwl_scanresults_notification *)pkt->u.raw;
+	#endif
=20
 	IWL_DEBUG_SCAN("Scan ch.res: "
 		       "%d [802.11%s] "
@@ -2923,8 +2927,10 @@ static void iwl3945_rx_scan_results_notif(struct=
 iwl_priv *priv,
 static void iwl3945_rx_scan_complete_notif(struct iwl_priv *priv,
 				       struct iwl_rx_mem_buffer *rxb)
 {
+	#ifdef CONFIG_IWLWIFI_DEBUG
 	struct iwl_rx_packet *pkt =3D (void *)rxb->skb->data;
 	struct iwl_scancomplete_notification *scan_notif =3D (void *)pkt->u.r=
aw;
+	#endif
=20
 	IWL_DEBUG_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 		       scan_notif->scanned_channels,
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
