Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793596212;
	b=lxfZOHtZlRO91gNdObw0AtizGII4HLaDlR1TEzgdXE6htgfijCmlNQjvTGHoA7A4eMlC
	 l1SoZu/4ci4BtygU3aUvMIQm64QMaJq+enx6Y5LQf1k8dg2g5+iBGl1CgVC7Da0GKMNww
	 xjyGT43fgM8Au7uhXQ4s8/aydC6piwN/XSScYaMFxrAaNDi4J8RmiTAU4a71G1XH24w3i
	 oArghQw8X6n6shfJdPlkLtWfElSNj6ZmEneXfvnZSdtCvzCKCly9ANQaGmw6MXhGJ7Avr
	 eBjfSAx26pF78MErEFMnq2GvQ35sIf1ddzbbiQFyEAX+tOSd21eQAw5xhDUitJG3Hhg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793596212;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pC5b5twFF+SxzkhSXejiKzdM406HFo2duDeDWQZ2ajs=;
	b=b63TIs796TFCPY8glxNzP2kPQSfDvE3l7qbu7PcjV1DntuuS2Kq8+EwzAnMKTg7+al1L
	 I6ALOXMIujett0kyZtmphSgaoT6UnvwyaVBont3ZMYVACmDJX8jUVYYureCHSVA96WmVQ
	 nYCeduol41H/lIHQ5lKUgnsjfiGzvVJ/eF3G64nQQejvnYj21agQUk14Lyd3s+sOcoVl4
	 Wvtajy51ObvSOD4f1fho252a4JzJFnYhIZaDfgy7+4RKp7ZefidnNu2wF8fvqrKRgwDDr
	 AtbusH33Zdb3dev6fcVRs0b8qlfA00U9ZUYVpX/8YHpyrEtaSawKOzCaTM5EQYStMqA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SdUXXzaV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05430606A324;
	Mon,  2 Nov 2026 05:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SdUXXzaV
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793596211;
	b=iE5Ld6iqu4tGhrACU7jt7aVb/6EOZSPSCp34QRz2JYiBHdUd7sJ9uG+S68M2rZH7t/Jv
	 Sb72KJS3xMVLoVfZdgbM18eK3cq8t0gCxocZj3chPckMS6bNCZyfR4C0bN3Jf67qE0lpp
	 48d2UHyD/5gyI7izokdlT3CLDLRb6z55/ia7GDHhEzfHuRVcFcwXFghZa6LIl7kx8LQ5S
	 xU0Q7CiaDuPajh4CRnXzo8ZGTbw/AfA0FLFmJY7wPyvNWUlYQYsMW5jiMVjiW+DAf9bXW
	 orV/kgNPmhDxydVCJ7aeMXvBwPc15A/FUEuh1dGdgAOIed0obs5NWM1Mob291S4layw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793596211;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pC5b5twFF+SxzkhSXejiKzdM406HFo2duDeDWQZ2ajs=;
	b=l4+aZmyhMdQR9Rcy2SnIYpYz0uDRXuJXxLVujqF1Hd3SmBIb02u/uuutgLdDTzuDZs1C
	 FeKDIXjoWm7SnezKf2f17czLirbtZalSsiuqBXk88cgrcC+0GGG4lwSw0e++aXMK1FLNo
	 GtDyDRNQUHJzBZvjPZNyXi7Pkx1nNWx0Ugc6qm6E9SlnGV1UKVjn2SQi1D+LsB+bpkBsS
	 ywvYfmfhxAAIGiu2EyxTX9YFBuoVJ1QR9lWlW2QqrnatGLvZsKuym3vykCiXUKrLhp9Az
	 QSoBkPgBxaZuJYohsfmWFJ2EeLxRsGp2xprJL67sypNh36MyDmP0lZH5i+/yqBkNZCg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E140A1F000C1;
	Mon,  2 Nov 2026 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793596211;
	bh=pC5b5twFF+SxzkhSXejiKzdM406HFo2duDeDWQZ2ajs=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=SdUXXzaVaAM6U4RZGDjlZ/y3AbjbHWye6ZX7NQk2kj4+qUh0z38xo4INI47Kbz5MY
	 5t/E4WqJIeZOrD9yQsCUOHdU+g9sF4LmqGKT/ZgFrj9p9ycvxkcE3D/7zcpHLCq1Ao
	 WmnVB5/HMLDU0ke66pNUr/+oVs4WrojteISqCsqGIj4awOSh7zAhQG0oVkWlqYFfWB
	 0yz/m9aMZZay0TjSFAPvzECibMzKr5tmqbbIqidvGFOCr+M6eC8YdEegcvQepLBz3e
	 H4UyqJe6nvcBTw6FET7BQKcHZVfDh/qfxyqKDatzMeyKQFzWD6emsG9wJ3RRolqfMP
	 22REGg5KdEPLQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4339F46378;
	Mon,  2 Nov 2026 05:10:10 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 23:10:10 -0600
Subject: [PATCH ath-next] wifi: ath11k: don't report a QCN9074's chan-info
 noise floor
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
Message-Id: <20261101-b90-qcn9074-chan-info-nf-v1-1-aa0a99ba7ba6@gmail.com>
X-B4-Tracking: v=1; b=H4sIADEb6GoC/yWMQQ6CMBBFr0Jm7STTKgJexbhoy1TGxaBtNSSEu
 1t0+fL/eytkTsIZLs0KiT+SZdYK5tBAmJzeGWWsDJbs2Rgy6AfCV9CBuhPuDxSNM2rEsSd3bPu
 2885C1Z+Joyy/9BVcmVB5KXD7L/ntHxzKXoZt+wKQB4RahgAAAA==
X-Change-ID: 20261101-b90-qcn9074-chan-info-nf-d80a35857ba2
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793596209; l=3286;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=te6WMy5xu/GQ3oR7I7RbrttS24vmR5JQGlg47fN/BYU=;
 b=5VJ/Pz90aEwcbk5GCIHHTA0lTd2rLG+H8/yyaGQjxH8jG3s125XWb5/pdt+Ikr9i5hnZ/FG5I
 E/fKuVMW4VUBcgkRscdQOdhy2YU0Ctv4CrNFxp0S2iexnDp8zxdOw5v
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

On a QCN9074 (and the QCN9072, which uses its hw_params) the noise floor
in WMI_CHAN_INFO_EVENTID's START_RESP is a fixed value, not a
measurement. On an Arista C-360 the QCN9072 scan radio read -107 dBm
+-1 on every 2.4, 5 and 6 GHz channel it visited (150 ms dwells), busy or
quiet: 5540 at 52 % busy read -110, its lowest. The IPQ8074's own radios,
on the same channels at the same time, read -95 to -98 and followed the
channel (-96, -97, -96 on 5200/5220/5240; -95 on 5785, -98 on 5885),
where the QCN9072 read -108, -107, -107, -107 and -106. -107 is also
below the ~-101 dBm thermal noise of 20 MHz.

Leave the noise out of a QCN9074's off-channel survey entries, so that
nothing takes the placeholder for a noise floor; their time and busy
counts are unchanged, as is every other chip.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.r4-00683-QCAHKSWPL_SILICONZ-1

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
 drivers/net/wireless/ath/ath11k/core.c | 1 +
 drivers/net/wireless/ath/ath11k/hw.h   | 2 ++
 drivers/net/wireless/ath/ath11k/wmi.c  | 8 +++++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index 766ae27306f43..d6848789dcff4 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -392,6 +392,7 @@ static const struct ath11k_hw_params ath11k_hw_params[] = {
 		.cfr_support = false,
 		.cfr_num_stream_bufs = 0,
 		.cfr_stream_buf_size = 0,
+		.chan_info_nf_invalid = true,
 	},
 	{
 		.name = "wcn6855 hw2.0",
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 4996536fbd14f..202430fa5b0da 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -231,6 +231,8 @@ struct ath11k_hw_params {
 	bool cfr_support;
 	u32 cfr_num_stream_bufs;
 	u32 cfr_stream_buf_size;
+	/* chan-info's noise floor is a fixed value, not a measurement */
+	bool chan_info_nf_invalid;
 };
 
 struct ath11k_hw_ops {
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 08fd6795ed9e7..7c8b605b622cd 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8031,9 +8031,11 @@ static void ath11k_chan_info_event(struct ath11k_base *ab, struct sk_buff *skb)
 	if (ch_info_ev.cmd_flags == WMI_CHAN_INFO_START_RESP) {
 		survey = &ar->survey[idx];
 		memset(survey, 0, sizeof(*survey));
-		survey->noise = ch_info_ev.noise_floor;
-		survey->filled = SURVEY_INFO_NOISE_DBM | SURVEY_INFO_TIME |
-				 SURVEY_INFO_TIME_BUSY;
+		survey->filled = SURVEY_INFO_TIME | SURVEY_INFO_TIME_BUSY;
+		if (!ab->hw_params.chan_info_nf_invalid) {
+			survey->noise = ch_info_ev.noise_floor;
+			survey->filled |= SURVEY_INFO_NOISE_DBM;
+		}
 		survey->time = div_u64(ch_info_ev.cycle_count, cc_freq_hz);
 		survey->time_busy = div_u64(ch_info_ev.rx_clear_count, cc_freq_hz);
 	}

---
base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
change-id: 20261101-b90-qcn9074-chan-info-nf-d80a35857ba2

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


