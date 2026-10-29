Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793275685;
	b=EBnmdoeZnz0ZdR2OcgUBv4j9eeE47A9rw1hWrZlMOQoUYge/n5CU8Vmr/Ym507lkU/Bf
	 fznWQv8x4sT1BLxsbfMdIX310eys4BF6iiW9G5p5oNprV9zAqYClY1Hb6HlQ72Rup4I+G
	 VeruEblcYr6ltuc7lfNuoGovEQSVJPhsuWewMjTSoaqipf7R3MAdhK+EFRh3zOjpmNxyW
	 1f/94XiCUfgcme0qSo5ktxzrYlmzwkvNsf75+SSDGSau71vCmzCIcyWv/ewOasopyykWx
	 f4m5Lz/fpeT+mTsu45cg/xobkUMXgefRpZnUsJ7XzpdvG8Yv4+YYclP0gwcfbhd3QeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275685;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eZ22/2ihBZuRYoMMXlwinYX9sdB0aTg/WqKfiHjALN0=;
	b=5eWmjcjB/uOhSXmnSgNZVWGobzI/zKyLnh5n5FPTUExLLFBjONBu4sbuiacNGtPqsuRp
	 60H8bNAqbRtD1ZC7pIDEhvf7mJlS6BYu0AkhWW31zfqCXzcriCpD7ry7Nn1Zz6G0vI5fN
	 YTNvUjLTaF3ZUb4xqmshPRb5SQCaSh6/xa9ycxxyCMXQKutTeKKfg5VIWFaDVwKXUaLXy
	 qbIFJeG3oPMtrZHb3F9taPbpcl/JU1tek+XVgqnhPd4eOzoCT2KzzGtWeFEdG1TRqGQ5D
	 j3CAZQ2ES2/xw/TjYU9iEq9HJE6Zb2QDYusvu8SHZf4ExFXDTtYY2XhmpQpd71wDabw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlpxLCSm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36F3606A31A;
	Thu, 29 Oct 2026 12:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DlpxLCSm
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793275684;
	b=zWkzU+5sN4evVkPJwGAfPo6Z5bAoZH9MoCSjdbV6P/ze6o0KdSvIbK5US+GV2zLGcBou
	 +4smkK0NSNzE5IC73uTgwQ5y4ayOKgewK4usJcvANC6frbKHDGQWCS73DdrLnqWCyr/xQ
	 wGA0IWuH7HWTKuOPR04FoJsZF4Kxp3Nf/x0/cL3Ksh76jUIKBy2vpHn7clRje8saoG6JQ
	 phZw9A9ihOQqfE/QBP35TxT4th+PV9i4Qh9EwIR2Ipw24e2vscdIalFXk9Ceja9mDzqb+
	 jdbh9S7Xugrihb2FHSL88AmMKWOeI+hLk9E7WDP8QL6Y3RmZFU/qD41TgvEW6ul+EjA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793275684;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=eZ22/2ihBZuRYoMMXlwinYX9sdB0aTg/WqKfiHjALN0=;
	b=xZLS1vGuCC8hhuY7h/utxDUkaL+NDB88rt6r1Q6gDZljk5vvwp+XWQTN95iZDGM5U6yf
	 hS8fFt49zbgRuur3XYq21gnYmn9ger8ghrtvxwvpz9ogm820uZhQpSjw9tSi+e5OfC8xy
	 KW8lmU6sza7U8HqkYUyXMgmDBOUeHrqBRWjyORs3iDT83C4r1gGqgc4JEldC5w6bOGH5A
	 RXATG6f8H6LbQH9yX2EyF0CxWlbjByYVFCX0gyWuZFPgL+0o+iRG33PsKtCtWIMSynhUM
	 hg17Ibxs8GVT52e8+nrPlbUMIRQ/rvL9Rl/BfSifuYYfcxleot9BLIIJNjU/nFzonnQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1245C1F01825;
	Thu, 29 Oct 2026 12:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275684;
	bh=eZ22/2ihBZuRYoMMXlwinYX9sdB0aTg/WqKfiHjALN0=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=DlpxLCSmc9upG3CJoNGtGl29sANDyZte80K+Kx9qoUxUvxZwSfK7aB+3HNYXMvmgs
	 3hrDT3xpaO2y+fajQR0SdGDp+XYc+Q8zbLkW/USf9wwVq1Ko7X5Pv2sux46KuHoukM
	 gVe56gqgjLLNC7xMH1w2e4ZYwGddRD2A/c0FvzZe8dohG+oDXUt2aON1OBMi5wibIJ
	 /JC3ygvWSRb2OoajTMa73ng93GOSyHlb2fGxgJmqugBaOkEBc/uJO7+CMcNeAvqWRq
	 Sgcx7o/qEQ/8bS/Q3ZJbV3KrEpKkKYhAOBQZy0yMOhHub/HW1J7G2lnmAl6lVyzQUA
	 F/UkNYwNmrx3Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6A2E445836;
	Thu, 29 Oct 2026 12:08:03 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Thu, 29 Oct 2026 07:08:03 -0500
Subject: [PATCH ath-next] wifi: ath11k: stop every vdev before starting
 them on a new channel
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-ath11k-csa-stop-vdevs-v1-1-4f7c94422a66@gmail.com>
X-B4-Tracking: v=1; b=H4sIACI342oC/yWMQQqDMBAAvyJ77kKy1EL6ldLDNllrWoiSjUEQ/
 95Uj8Mws4FKjqJw7zbIUqPGKTWwlw78yOktGENjIEM3a8ghl9HaL3pl1DLNWINUxcG4wHylnno
 HrZ2zDHE9vg9oCSZZCzxPo8vrI778t7DvP/NvC1ODAAAA
X-Change-ID: 20261029-ath11k-csa-stop-vdevs-f09daa425259
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-wireless@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793275682; l=5190;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=bBP0WQR79rtL6Evxb1jkylTLJeI12NDSekdwCY42Dyg=;
 b=lhNhFtC5hVdaq94i4v2tq0yXk0eDs2yi37jKI4Jp/zQFZdQHJlB9SCCHzLteLjRyZ50/9NvPn
 LSAzUg+1PVIBSzjTwhpGgyTtTnJLLBRyL3qaw4v8fNc/7Gw9veQXfIM
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

On a channel switch, ath11k_mac_update_vif_chan() restarts each vdev
that is up on the new channel (WMI_VDEV_RESTART_REQUEST). On an IPQ8074
5 GHz radio the transmit rates collapse after that, and stay low until
the radio is stopped and started again. From a client heard at -70 dBm,
after a fresh start on channel 149 the downlink was 76 Mbit/s, with the
firmware sending 16-55 % of its PPDUs at MCS 0-4 (HTT PDEV_TX_RATE
stats). After two switches, 149 -> 157 -> 149, it was 7 Mbit/s three
times in a row, with 98-100 % at MCS 0-4, and the uplink fell from 120
to 16-65 Mbit/s. Stations that join after the switch are affected too.

Sending the HE MU and sounding modes again after the restart does not
help, nor does stopping and starting the vdevs one at a time, which
leaves the others started on the old channel. Taking every vdev down
and stopping it before any of them starts on the new channel, as a
fresh start of the radio does, helps: after the same two switches,
68.5, 107.8 and 86.2 Mbit/s down (ten runs after switches: median 84;
fresh starts: median 92).

Do that, and keep the restart for a vdev that could not be stopped. A
vdev start leaves the HE MU and sounding modes at the firmware's
defaults, so set them again, as enabling the beacon does on the first
start.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
Found on the IPQ8074 5 GHz radios of an Arista C-360 and C-260 running
OpenWrt, each with four AP vdevs up, where a management system moves
the radio to another channel by CSA. On the C-260 the downlink after
the same two switches was 245.7, 234.6 and 241.1 Mbit/s with this patch,
against 257.3 from a fresh start.

Not tested: station, mesh or monitor vdevs, and any chip but IPQ8074.
a4146249a333 ("ath11k: skip sending vdev down for channel switch")
dropped a vdev down before the restart because QCA6390 firmware crashed
on it; here the down is followed by a stop and a start, not a restart,
but I could not try that on a QCA6390 or WCN6855.

The investigation and the patch were done with Claude Code
(claude-opus-5-5): it compared ath11k's WMI debug log of a fresh start
with that of a CSA, wrote and ran the variants on the APs, and wrote this
patch and its changelog. The downlink figures are iperf3 runs from a
QCN9072 client; the MCS shares are deltas of the HTT PDEV_TX_RATE stats.
Built with W=1 on ath-next.
---
 drivers/net/wireless/ath/ath11k/mac.c | 41 ++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1a237adaa37d..a9b940c2da41 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -7793,6 +7793,7 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 	int ret;
 	int i;
 	bool monitor_vif = false;
+	unsigned long stopped = 0;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -7802,6 +7803,33 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 
 	/* TODO: Update ar->rx_channel */
 
+	/* Take every vdev that is up down and stop it before any of them
+	 * starts on the new channel, as a fresh start of the radio does.
+	 * Restarting the vdevs in place, or stopping and starting them one
+	 * at a time while the others stay started, leaves the radio sending
+	 * at far lower rates on the new channel until it is restarted.
+	 */
+	for (i = 0; i < n_vifs && i < BITS_PER_LONG; i++) {
+		arvif = ath11k_vif_to_arvif(vifs[i].vif);
+
+		if (!arvif->is_started || !arvif->is_up)
+			continue;
+
+		ret = ath11k_wmi_vdev_down(ar, arvif->vdev_id);
+		if (ret)
+			ath11k_warn(ab, "failed to down vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+
+		ret = ath11k_mac_vdev_stop(arvif);
+		if (ret) {
+			ath11k_warn(ab, "failed to stop vdev %d: %d\n",
+				    arvif->vdev_id, ret);
+			continue;
+		}
+
+		stopped |= BIT(i);
+	}
+
 	for (i = 0; i < n_vifs; i++) {
 		arvif = ath11k_vif_to_arvif(vifs[i].vif);
 
@@ -7815,7 +7843,18 @@ ath11k_mac_update_vif_chan(struct ath11k *ar,
 		 * Firmware expect vdev_restart only if vdev is up.
 		 * If vdev is down then it expect vdev_stop->vdev_start.
 		 */
-		if (arvif->is_up) {
+		if (i < BITS_PER_LONG && (stopped & BIT(i))) {
+			ret = ath11k_mac_vdev_start(arvif, vifs[i].new_ctx);
+			if (ret) {
+				ath11k_warn(ab, "failed to start vdev %d: %d\n",
+					    arvif->vdev_id, ret);
+				continue;
+			}
+
+			/* as enabling the beacon did for the first start */
+			ath11k_mac_set_he_txbf_conf(arvif);
+		} else if (arvif->is_up) {
+			/* the vdev could not be stopped */
 			ret = ath11k_mac_vdev_restart(arvif, vifs[i].new_ctx);
 			if (ret) {
 				ath11k_warn(ab, "failed to restart vdev %d: %d\n",

---
base-commit: 7b14c8f4a9615579b09cbcdc4515b65ae6124753
change-id: 20261029-ath11k-csa-stop-vdevs-f09daa425259

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


