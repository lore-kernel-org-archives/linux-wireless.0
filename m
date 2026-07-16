Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C923B33A032;
	Thu, 16 Jul 2026 22:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.226.149.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784241376; cv=none; b=iojcLVCCFYH4ZYAtKBb/M1IeDVno1tkX7y/vbku/HdRXorYtzLT48Wbp+h3ndLlhU0DA7tVM+EbYVD40T8I25v3AHW0C96iprzYSEz4aDSnlwp1bYi6mMk4S6YQnyy3z3yOyp8RZoIxU/R21kaAUKJLX4e1qTJaGokU7l+BKt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784241376; c=relaxed/simple;
	bh=3nRkUv88r9cKh0IXmbHWf2SIDOCHcKjHAdTtSiaNXXU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=t2Uok7kRMFIqsClQ4jBqs3LKlF59cSPoLeupbcKpaiYXQZ2s3PzL4o+FfcjOjh0V+rxf4I5myivcaCX5vJmFFiLmO5ny6Hs/D41OJzyGU+f7UEqzT9UoPGokK1KL2HD04VBZEoMd2B3SYl+ylMzq0Whc2/YUw7vHnB+MnD+vPIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es; spf=pass smtp.mailfrom=pokerfj.es; arc=none smtp.client-ip=185.226.149.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pokerfj.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pokerfj.es
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <stian@pokerfj.es>)
	id 1wkUgW-0069GC-7A; Fri, 17 Jul 2026 00:36:04 +0200
Received: from [10.9.9.72] (helo=submission01.runbox)
	by mailtransmit03.runbox with esmtp (Exim 4.86_2)
	(envelope-from <stian@pokerfj.es>)
	id 1wkUgV-0002gi-OS; Fri, 17 Jul 2026 00:36:03 +0200
Received: by submission01.runbox with esmtpsa  [Authenticated ID (1471791)]  (TLS1.2:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.95)
	id 1wkUgF-00415X-Rb;
	Fri, 17 Jul 2026 00:35:47 +0200
From: Stian Knudsen <stian@pokerfj.es>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 ath12k: WCN785x firmware resets regulatory domain on resume causing ~7s
 reconnect delay
Date: Fri, 17 Jul 2026 00:35:46 +0200
Message-ID: <-_iDJ_M5RrqACWB0qmtleg@pokerfj.es>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

After resume from suspend, the WCN785x firmware resets its regulatory state to
WORLD and takes approximately 7 seconds to re-discover the country code from AP
beacons. This causes a consistent ~16 second total delay before wifi reconnects
after resume.

This is an improvement request rather than a crash bug: the driver currently
contains no WMI code for saving or restoring regulatory state across
suspend/resume, and I would like to ask whether this is feasible.

Hardware:
Lenovo ThinkPad T14 Gen 5 (BIOS: R2LET40W 1.21)
Wifi: Qualcomm WCN785x Wi-Fi 7 FastConnect 7800 [17cb:1107]
Subsystem: Lenovo [17aa:e0e6]
Kernel: 7.1.3-arch2-1 (Arch Linux, close to vanilla)
Firmware: WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Kernel taint: 0 (untainted)

Observed behavior:
On every resume from suspend, the following sequence is observed in dmesg and wpa_supplicant logs:
kernel: ath12k_wifi7_pci 0000:02:00.0: chip_id 0x2 chip_family 0x4 board_id 0xff soc_id 0x40170200
kernel: ath12k_wifi7_pci 0000:02:00.0: fw_version 0x1103006c fw_build_timestamp 2026-03-06 09:10 ...
wpa_supplicant: wlp2s0: CTRL-EVENT-REGDOM-CHANGE init=DRIVER type=WORLD
[ ~7 seconds pass ]
wpa_supplicant: wlp2s0: CTRL-EVENT-REGDOM-CHANGE init=DRIVER type=COUNTRY alpha2=DE
[ ~9 seconds pass ]
NetworkManager: policy: auto-activating connection 'SSID'
NetworkManager: device (wlp2s0): Activation: successful, device activated.

Total delay from resume to connected: ~16 seconds, 100% reproducible on every
resume.

The device advertises itself as self-managed (phy#0 (self-managed) in iw reg
get). All standard userspace methods of setting the regulatory domain are
ignored by the firmware -- iw reg set, wireless-regdb, cfg80211
ieee80211_regdom modprobe option -- and i found this blog which documents this:
https://www.julienturbide.com/blog/wifi-7-linux-ath12k-wcn785x-regulatory-domain

Grepping the ath12k driver source (7.1.3) reveals no WMI code for saving or
restoring regulatory state across suspend/resume:
 $ grep -r "regdom|regulatory|country.*suspend|suspend.*country" drivers/net/wireless/ath/ath12k/
(no output)

The firmware resets to WORLD on every resume and must re-discover the country
code from AP beacons, taking ~7 seconds.

Is there a WMI command available in the WCN785x firmware to cache and restore
the last known country code on resume, avoiding the need to re-discover it from AP beacons? If so, would it be feasible to add this to the driver's suspend/resume path to reduce the post-resume reconnect delay?
Full dmesg output and wpa_supplicant logs are available on request.


