Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793610023;
	b=OTKEki8DHz6q0YPU+CibfULmtkC0yx1iaa0gyXuau8KeV5W/Fz8yV/0if3WT5iskqQWB
	 xG/68VV9tTvZ8xklNov1Qbjj9OOrw/lDJgZKINDBhWjklLFtrfZOLC+bdZYbgTSsGfrJY
	 ZauyvM7M0JbaWJLp8HREZ+QZ5hArdyXtRoN4BKEF9RqnAIQW+qRJrxS7cAjB/te5R7Gkn
	 0UV2BvjqZuRbWPfmwWLnkvLy+UOvIjx0+u7W+azP43/VdllY4G3C05rSegm8s4UV9EbR5
	 aamkwEudNo0bkIjlskdiRkM/lZgn9YtnZvPWHyRKEr9mfndOZGY4HHBNnZVQSL2xyuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610023;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Message-ID:Subject:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 MIME-Version:Date:X-ZohoMailClient;
	bh=fLisbtzgC19kR3Oj831tpOn3r5LmjasjYLg8ztjYQhQ=;
	b=wtmOBS5HWbOKgtTCGJO9FoI1Q/ug5l40GZ0qi9ybmbMyzVC3IroW+qHzz0wDPUwjxyfl
	 MnCGjoXDMUBzEJp/dXuk8EWYKdfZKfmiMwku/Kfc1wO9PRtCe34mQLeKVjzYWM/YH+PAo
	 PzBi0fIPVyYdDHm39MxN2oJJWvS7A+tRO/BNWNK4k7ujhhTBWkGvqyf+rMvYaGWrPR04l
	 GELRhgt8PQmmdtyv6+k3gp+pQNjUcCDfpN9s4ZY039GoubdI2Z6/Y/o+80kkthGud2qbo
	 57AiHTWG5cppt20phv/CgRUou4Me1VR/wc5lb7HqRSlKxfyb7dBRhswrI5EuZKcIRhw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ph4ntom-rev.uz;
	spf=pass smtp.mailfrom=ph4ntom-rev.uz;
	dkim=pass header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=blBcpwO4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.55
Received: from sender5-of-o55.zoho.com (sender5-of-o55.zoho.com [165.173.182.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD0A606A324
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 09:00:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9AD0A606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ph4ntom-rev.uz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ph4ntom-rev.uz header.i=@ph4ntom-rev.uz header.a=rsa-sha256 header.s=zoho header.b=blBcpwO4
ARC-Seal: i=1; a=rsa-sha256; t=1793610014; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=aN0ME8qmFNRw3pryCCBkM/g4gOK+Vtvnh7AhvjwnjEnVMBMqT+st5Pz6LHayoOl830r0Hka8TreYLDt78uMSkpcqw5VxpHEJKNTZaNGB4EmYbGb9whpLwbqzyRJ1Rxj8hiHgi1hD9rW5chI3vvWIMJR5wcd85/aw3HAh0fexlK8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1793610014; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=fLisbtzgC19kR3Oj831tpOn3r5LmjasjYLg8ztjYQhQ=; 
	b=DQIxf9wpFXWhnIj2/r35zUBLO3oP2mfKtABpfqyDGGCNUBYXJmuJN5D7P+mFTkeDwbcYlDMbwWS/45mLP+sZ4MHe65z531ku3ffDc56Fry1F5D8HJCxR0L2YlUjb9IbSvRwRTEEZBvCt2tCA8s6c7I9XSKrQ0vXhEEk/1LDP1Fo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ph4ntom-rev.uz;
	spf=pass  smtp.mailfrom=owner@ph4ntom-rev.uz;
	dmarc=pass header.from=<owner@ph4ntom-rev.uz>
DKIM-Signature: a=rsa-sha256; b=blBcpwO4GnaWt4HlA4vlEsuzXngIaALT6H0eMz6Z/ROqpAYJDz4LhHh1lSy2uxb8JnqSve3BcOWa95rEZ01iVIFy20/VvXxnNzhWk93pZOI2An3g+AzSvuZuB/MTgJ14wruwtun91/eMUV0HAxurscOQK5D/8+qtl2BkBp8IVPFOCwVL0tSVfVCxGs0VFS1iwj5FS2dWr7aiMVVYb5mEOEinn5LVFiGDl1w8Cbue7FUjCJuUG7uyGOF5vOMknIGNY1Ju8mxfnHIsEwiI6iggD10xgbFo6V+3UhKrFBa0E4Kx584yLCCTmaLrI69QUmKqbYBNgTn6IARF9EEZTIZKIg==; c=relaxed/relaxed; s=zoho; d=ph4ntom-rev.uz; v=1; bh=fLisbtzgC19kR3Oj831tpOn3r5LmjasjYLg8ztjYQhQ=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1793610010240975.8353665356238;
	Mon, 2 Nov 2026 01:00:10 -0800 (PST)
From: ph4ntom-rev <owner@ph4ntom-rev.uz>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>
Message-ID: <1a19b7cce82.5dc2e93-44860545.1830508576953059669@zoho.com>
Subject: Re: [PATCH RFC net-next 0/2] wifi: rtw89: fix monitor mode RX
 filtering and enable raw packet injection
In-Reply-To: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
References: <1a196d6dfbc.35537d221913104450.3720060455831933789@zoho.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 2 Nov 2026 01:00:10 -0800 (PST)
X-ZohoMailClient: External

Hi Ping-Ke,

Thank you very much for the prompt review and constructive feedback!

> I can only see this cover letter. Did I miss something?

Apologies for that! The initial RFC patch diff was not properly inlined in the
first message. I have included the complete unified diff against mainline rtw=
89
at the end of this email for your review.

> The commit a371139d8be9 ("wifi: rtw89: SNIFFER_MODE bit along IEEE80211_CON=
F_MONITOR")
> added a missing bit B_AX_SNIFFER_MODE, which I suppose it can capture
> packets promiscuously. Can you try it?

Regarding commit a371139d8be9 and B_AX_SNIFFER_MODE:
We investigated B_AX_SNIFFER_MODE in R_AX_RX_FLTR_OPT (0xCE20). While setting
B_AX_SNIFFER_MODE opens up basic BSSID address matching in the hardware CAM f=
or
data packets, our testing on RTL8852AE reveals that IEEE 802.11 Control frames
(ACK, RTS, CTS, BlockAck) are handled separately by R_AX_CTRL_FLTR (0xCE24), =
and
data subtypes by R_AX_DATA_FLTR (0xCE2C).

By default in upstream rx_fltr_init(), R_AX_CTRL_FLTR is configured such that
hardware drops Control frames or routes only specific frames to the MCU. When
sniffing in Wireshark/tcpdump, non-associated ACK, RTS, CTS, and BlockAck fra=
mes
are completely missing unless R_AX_CTRL_FLTR is configured with 0x55555555 (w=
here
each 2-bit field =3D 0b01: route to host RX DMA ring). Furthermore, capturing
FCS-corrupted frames requires syncing B_AX_A_CRC32_ERR with FIF_FCSFAIL.

More importantly, B_AX_SNIFFER_MODE only affects the RX path. The remaining
limitations (points 2, 3, and 4) prevent packet injection (raw TX) entirely.

> Please add a guard. But I have never encountered the oops. Could you
> share the steps?

Here are the exact reproduction steps for the NULL vif oops:

1. Bring up a standalone monitor interface (e.g. via iw or airmon-ng):
     # ip link set wlan0 down
     # iw dev wlan0 set type monitor
     # ip link set wlan0 up
     # iw dev wlan0 set freq 2462

2. Inject raw Radiotap frames into the monitor interface:
     # aireplay-ng -9 wlan0
   or:
     # aireplay-ng -0 1 -a 02:00:00:00:00:01 wlan0
   or via a standard Python raw socket:
     sock =3D socket.socket(socket.AF_PACKET, socket.SOCK_RAW, htons(0x0003))
     sock.bind(("wlan0", 0))
     sock.send(radiotap_null_data_frame)

3. Why the oops occurs:
   In net/mac80211/tx.c (ieee80211_monitor_start_xmit()), when transmitting
   frames injected directly through an unassociated monitor interface, mac802=
11
   passes info->control.vif =3D NULL.

   When this frame reaches rtw89_ops_tx():
     static void rtw89_ops_tx(struct ieee80211_hw *hw,
                              struct ieee80211_tx_control *control,
                              struct sk_buff *skb)
     {
         struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
         struct ieee80211_vif *vif =3D info->control.vif;
         struct rtw89_vif *rtwvif =3D vif_to_rtwvif(vif); /* <-- OOPS when vi=
f =3D=3D NULL */

   Evaluating vif_to_rtwvif(NULL) in the local variable declaration unconditi=
onally
   computes container_of(NULL, struct rtw89_vif, pub), dereferencing offset 0=
 and
   triggering:
     BUG: kernel NULL pointer dereference, address: 00000000000000xx
     RIP: 0010:rtw89_ops_tx+0x...

   The same unconditional dereference occurs in rtw89_core_tx_write():
     struct rtw89_vif *rtwvif =3D vif_to_rtwvif(vif);

   Adding a guard that checks if (!vif) and resolves to rtwdev->pure_monitor_=
mode_vif
   (or cleanly drops if rtwvif cannot be resolved) prevents the panic complet=
ely.

> OK. (on rate descriptor handling)

Thank you! In the patch below, we handle rates[0].idx < 0 by mapping to
RTW89_HW_RATE_OFDM6, setting en_wd_info, use_rate, and dis_data_fb, and bound=
ing
tx_cnt_lmt =3D 1 when IEEE80211_TX_CTL_NO_ACK is requested.

> I'd check this in detail with RFC patch. (on firmware scheduler MACID conte=
xt)

Here is the technical mechanism for the firmware scheduler context:

When mac80211 allocates a standalone monitor VIF (IEEE80211_HW_WANT_MONITOR_V=
IF),
rtw89_ops_add_interface() allocates a mac_id and hardware port. However, unli=
ke
managed STA or AP interfaces, rtw89 never calls:
  chip->ops->h2c_default_cmac_tbl()
  chip->ops->h2c_default_dmac_tbl()
  rtw89_fw_h2c_join_info()

As a result, the firmware's internal MAC scheduler leaves that mac_id paused,
and R_AX_MACID_SLEEP_0 (0xC2C0) keeps the queue masked, causing all transmitt=
ed
injected frames to silently stall in hardware queues.

If we register the role as RTW89_SELF_ROLE_CLIENT, the firmware starts an int=
ernal
5-second beacon-loss watchdog and disconnects/pauses the MACID because there =
is no
AP sending beacons.

However, registering as RTW89_SELF_ROLE_AP with RTW89_NET_TYPE_NO_LINK via
rtw89_fw_h2c_join_info() initializes the per-MACID scheduler context in firmw=
are
WITHOUT emitting AP beacons and WITHOUT client beacon-loss timers. Calling
rtw89_fw_h2c_macid_pause(rtwdev, mac_id & 0x1F, mac_id >> 5, false) and clear=
ing
the bit in R_AX_MACID_SLEEP_0 unpauses the TX hardware queue.

Empirical verification on Kali Linux (kernel 7.1.5, RTL8852AE):
- Captured 20,000+ frames on channel 11 in Wireshark with full Radiotap per-a=
ntenna
  RSSI (-18 dBm / -24 dBm), including Beacons, Probes, ACKs, RTS/CTS, and Blo=
ckAcks.
- Tested aireplay-ng -9 with 100% frame delivery (30/30 probe requests answer=
ed,
  average round-trip 1.3 - 1.6 ms).

Below is the complete patch diff for your review:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -1395,9 +1395,14 @@ int rtw89_core_tx_write(struct rtw89_dev *rtwdev, stru=
ct ieee80211_vif *vif,
 			int *txdesc_size)
 {
 	struct rtw89_core_tx_request tx_req =3D {};
-	struct rtw89_vif *rtwvif =3D vif_to_rtwvif(vif);
+	struct rtw89_vif *rtwvif;
 	int ret;
=20
+	if (!vif)
+		vif =3D rtwdev->pure_monitor_mode_vif ? &rtwdev->pure_monitor_mode_vif->pu=
b : NULL;
+	if (!vif)
+		return -ENODEV;
+	rtwvif =3D vif_to_rtwvif(vif);
+
 	tx_req.skb =3D skb;
 	tx_req.tx_type =3D tx_type;
=20
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -26,9 +26,17 @@ static void rtw89_ops_tx(struct ieee80211_hw *hw,
 	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif =3D info->control.vif;
-	struct rtw89_vif *rtwvif =3D vif_to_rtwvif(vif);
+	struct rtw89_vif *rtwvif;
 	struct ieee80211_sta *sta =3D control->sta;
 	u32 flags =3D IEEE80211_SKB_CB(skb)->flags;
 	int ret, qsel;
=20
+	if (!vif)
+		vif =3D rtwdev->pure_monitor_mode_vif ? &rtwdev->pure_monitor_mode_vif->pu=
b : NULL;
+	if (!vif) {
+		ieee80211_free_txskb(hw, skb);
+		return;
+	}
+	rtwvif =3D vif_to_rtwvif(vif);
+
 	if (rtwvif->offchan && !(flags & IEEE80211_TX_CTL_TX_OFFCHAN) &&
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Please let me know your thoughts on this scheduler setup and whether you would
like me to format this as a formal v2 git patch series for wireless-next.

Signed-off-by: ph4ntom-rev <owner@ph4ntom-rev.uz>
