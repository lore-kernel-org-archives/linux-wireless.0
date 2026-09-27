Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35DD3502A7;
	Sun, 27 Sep 2026 12:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790511054; cv=none; b=oO+MHhfchl7qOhd3OaoaqLoe3U9krRAU0Z0scgfHiPsjLMtqwMtDAdj9xbmF/4Y5PqPyJZAc61ABEiQb1ifKixs+MKQp4y0xjpttdYNgePO2jTz6GsI1gE9zUuH9CN91yRMt5S0K4z245jB3NIo+Es8O0oXGtWjJof+ooZ0BpJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790511054; c=relaxed/simple;
	bh=2sPiSOQCyrAQETQfEjJGSVZdtZCpPUJAVgRoeb95QUw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hl/0/3AaWUnMl+sFWwhfjBMMjh1EqKaX6vilQiuB6AFxPtXW8HyVHXuAwdl7msjauSNULCFxOQVfvLBtsqwLLSuohxgom2UCAoX76jBHzdkBhB4eEWNFbhyD4Lr4UYp/EwpaC3WafVyNfVB3+J3VJQrJ7K/ldoNe7UC/Wn3F8U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzQp5yCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzQp5yCe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40B16C2BCB3;
	Sun, 27 Sep 2026 12:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790511054;
	bh=2sPiSOQCyrAQETQfEjJGSVZdtZCpPUJAVgRoeb95QUw=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=TzQp5yCe2vbYYOmckq5HBrH98wj6csRiwXkE/b4aSqvAPz0LwU3znrEv570DeHJch
	 trY//UU4JVo8D0r6cqnCftyu5+9QJPHdSeBH3rk+ONNZr44iSpxnEVq+GNRMnqddYr
	 RKLKjqJfzF0JaOdPhIvIFMFKfAByOiJP+BiBYt7sW+2+bo5FJLrtd3dNBug99FUG3j
	 ymD5WNxjd4AtSECnZawE5WJA9GC8vfE8ohTnLa0zKvC61Itk0KQkHD5oH6oc/tBuuS
	 7RWlzJfrIfem4Ys0ldgIR5Jq5Eh8KpWCTkYbldbjRb3+dQZFfSgt4qIvCet4ZYJR1k
	 4T9P5cRtzzc0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20BDEC98324;
	Sun, 27 Sep 2026 12:10:54 +0000 (UTC)
From: Shunsuke Nagashima via B4 Relay <devnull+shunsuke.nagashi.ma@kernel.org>
Date: Sun, 27 Sep 2026 21:10:53 +0900
Subject: [PATCH ath-next] wifi: ath10k: fix status of bundled mgmt tx
 completions
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260927-ath10k-bundle-status-v1-1-a1eea048ada9@nagashi.ma>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QrCMAwAf2Xk2UDTyab+iuyh3aKLSpUmlcHYv
 1v18TjuVlDOwgqnZoXMb1F5pgq0a2CcQ7oyylQZvPOdO/oeg83k7hhLmh6MasGKot8TtUR97A4
 t1PSV+SLLb3uGWmDixWD4Gy3xxqN9r7BtH49IqaaCAAAA
X-Change-ID: 20260927-ath10k-bundle-status-24113117b683
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org, 
 ath10k@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Shunsuke Nagashima <shunsuke@nagashi.ma>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790511053; l=4037;
 i=shunsuke@nagashi.ma; s=20260927; h=from:subject:message-id;
 bh=QVBqzIPmQp3OWeyU/QcVzxRKR56mMIsg5DYITxXG7a0=;
 b=Xh9i1dtS2Uvv2kkPH5bVj24nVno/K5pjBuHO5R5bjTsNGn3jtXkxMz5Ub6h8qHADFnMhUw8tt
 gtPPLvNDl8gABQCrDEXZowB+aHiKTWfUjrIxiX/hSsVvGcS1LYXmIfm
X-Developer-Key: i=shunsuke@nagashi.ma; a=ed25519;
 pk=5WP8Bzifiy3DFoCeQ1lLy2osPmlNAkq71Un7ly9lbpk=
X-Endpoint-Received: by B4 Relay for shunsuke@nagashi.ma/20260927 with
 auth_id=1069
X-Original-From: Shunsuke Nagashima <shunsuke@nagashi.ma>
Reply-To: shunsuke@nagashi.ma

From: Shunsuke Nagashima <shunsuke@nagashi.ma>

ath10k_wmi_event_mgmt_tx_bundle_compl() takes the completion status of
each report from desc_ids[i] instead of status[i]. Any non-zero status
is handled as "not acked", so a bundled report is marked as acked if
and only if its descriptor id is 0, whatever status the firmware
returned.

The bundle handler read status[i] when it was added in
commit cc123fac978f ("ath10k: Handle bundled tx completion for
management frames"). The commit named in the Fixes tag replaced it
with desc_ids[i].

Seen on WCN3990 in station mode with a WPA3-SAE AP. This firmware
advertises mgmt-tx-by-reference and completes some management frames
in bundles. A debug build printed status[] for each bundled report and
could switch between the old and the fixed line. A sniffer watched the
AP channel. The firmware status[] matched the capture in all 39
bundled reports (15 with the old line, 24 with the fixed one): the 30
frames with status[] 1 were never seen on that channel, and the 9
frames with status[] 0 were acked.

With the old line, 6 of the 15 reports gave mac80211 the wrong ack
result:

 - 4 frames that were never seen on the air were reported as acked.
   Each report arrived after mac80211 had already timed out the
   authentication, so they had no visible effect in these runs.
 - 2 SAE commit frames that were acked on the air were reported as not
   acked. They were the second and third of three tries. mac80211 gave
   up on the authentication 239 us after the last report, although the
   AP's SAE replies came about 5 to 8 ms later, so that connection
   attempt failed.

Take the status from status[i].

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0.c10-00459-QCAHLSWMTPLZ-1

Fixes: 4b816f170b1f ("ath10k: add support for ack rssi value of management tx packets")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse
Signed-off-by: Shunsuke Nagashima <shunsuke@nagashi.ma>
---
Tested on a comma four (WCN3990) with a v7.2-based kernel
(7.2.0-vamos-7626c37). It also carries three out-of-tree ath10k
patches (MAC address, in-order rx A-MSDU, SET_KEY wait); none of
them touch wmi.c or wmi-tlv.c.

- Debug build that prints status[] per bundled report and can switch
  between the old and the fixed line, with a sniffer on the AP
  channel: 6 connect/reconnect runs (5 WPA3-SAE, 1 WPA2-PSK),
  39 bundled reports.
- Build with only this patch: 6 connect/reconnect runs (5 WPA3-SAE,
  1 WPA2-PSK), no debug output. No warnings, no firmware crashes.
  One first connect failed and one reconnect was slow, for a
  different reason that was also seen with the old line: the AP did
  not ack, and the firmware held back some Auth frames.

Not tested: status 2 or 3 inside a bundle (only 0 and 1 were seen),
AP mode, other chips and firmware versions.

I worked on this with Claude (claude-opus-5-5) and Codex
(gpt-6-astra). They helped go through the logs and sniffer captures,
write the debug build, and write the English of this changelog. I ran
the tests on the device and reviewed the change myself.
---
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index e57588c19..67be6e817 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2512,7 +2512,7 @@ int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb
 	for (i = 0; i < num_reports; i++) {
 		memset(&param, 0, sizeof(struct mgmt_tx_compl_params));
 		param.desc_id = __le32_to_cpu(arg.desc_ids[i]);
-		param.status = __le32_to_cpu(arg.desc_ids[i]);
+		param.status = __le32_to_cpu(arg.status[i]);
 
 		if (test_bit(WMI_SERVICE_TX_DATA_ACK_RSSI, ar->wmi.svc_map))
 			param.ack_rssi = __le32_to_cpu(arg.ack_rssi[i]);

---
base-commit: 753baa59527f8e606c49eac25692b8b08918a3a9
change-id: 20260927-ath10k-bundle-status-24113117b683

Best regards,
--  
Shunsuke Nagashima <shunsuke@nagashi.ma>


