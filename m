Received: from enxio.de (enxio.de [91.210.227.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6F723645D
	for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 06:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.210.227.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787810473; cv=none; b=dJAslelkpGac5cPxCez52htv5bTm6jDTBPH90CZ7g2TMcprpGFXetJjdblVoDHDiTEf3q/4MycsXUuq6yPWZ0omwGGR9Xs2KW+80gHjNPfHfiNQ1JyWWOHSLE7fAtZALP+enIylkIcXGh7VLjOo90bPlUb3RvuSUI+pIDwxHCOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787810473; c=relaxed/simple;
	bh=r2n2VScm62GdFbicZXvcFoGUfhIMy0g7yZ9+6G25TiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mSu9LJd1MQMp9HY7EiixLksZGL+9HxOIU3IGvh7MawRVD4ldwotcn5Bu5u4FoD7cchZ7YC+h7AgCfH4V/PnZzEx4h8T/SP/DaEdCDRw12uV1t5g/G6zHCzh8aZOvaI52/+JmEfgs+NANVzU68BO0b57CjtIj8tp3Wf/DneGj4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de; spf=pass smtp.mailfrom=enxio.de; arc=none smtp.client-ip=91.210.227.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=enxio.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enxio.de
Received: from [95.157.48.181] (helo=roja.toh.cx)
	by enxio.de with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <anthrop@enxio.de>)
	id 1wzSup-00000007AeC-2YIN;
	Thu, 27 Aug 2026 07:44:43 +0200
Received: from localhost ([127.0.0.1])
	by roja.toh.cx with esmtp (Exim 4.94.2)
	(envelope-from <anthrop@enxio.de>)
	id 1wzSup-003T3B-01; Thu, 27 Aug 2026 07:44:43 +0200
From: Thomas Hilber <anthrop@enxio.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com, linux-mediatek@lists.infradead.org
Subject: AP drops STA data frames for ~130-170ms after 4-way handshake
 completes (ath9k_htc, mt76; not brcmfmac)
Date: Thu, 27 Aug 2026 07:44:42 +0200
Message-ID: <20260827074442.826644@enxio.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

When an AP runs on a mac80211 SoftMAC driver, data frames sent by a
freshly associated station are acknowledged at the MAC layer but never
reach the network stack for ~130-170ms after the WPA2 4-way handshake
has completed. The same station against FullMAC APs shows no such gap.

Because the frames are hardware-ACKed, the station receives no
backpressure and TCP cannot detect the loss; a dropped SYN therefore
costs a full initial RTO (~1.3s) rather than a retransmit.


Test setup
----------

One station, five APs, measured one at a time, everything else held
constant: same SSID, same WPA2-PSK passphrase, channel 11, hw_mode=g,
ieee80211n=1, 20MHz, hostapd v2.10, AP bridged to the wired LAN. The
station associates, sends one short TCP request, disconnects and deep
sleeps, repeating about once per second, so every cycle is a fresh
association. 100-140 cycles per AP. No other stations associated.

  AP  radio                    driver              kernel
  --  -----------------------  ------------------  -----------------
  1   Espressif ESP32 softAP   vendor stack        (ESP-IDF v5.5.5)
  2   MediaTek MT7986          mt76      SoftMAC   6.12.51
  3   Broadcom CYW43455        brcmfmac  FullMAC   6.18.39
  4   Atheros AR9271 (USB)     ath9k_htc SoftMAC   6.18.39
  5   Atheros AR958x           ath9k     SoftMAC   excluded, see below

Station: ESP32-C5, ESP-IDF v5.5.5.

APs 3 and 4 are the *same machine, same kernel, same hostapd binary,
same bridge, same channel*, differing only in radio and driver.


Results
-------

"attempts" is the number of TCP connect() attempts the station needed
before one succeeded; it retries every 30ms. Time is the median from
association to a completed TCP handshake.

  AP  driver              n    attempts   assoc->connected
  --  ------------------  ---  --------   ----------------
  1   vendor (FullMAC)    132     1.00           2.7 ms
  3   brcmfmac (FullMAC)  140     1.01           4.8 ms
  4   ath9k_htc (SoftMAC) 105     5.04         134   ms
  2   mt76 (SoftMAC)      118     6.19         168   ms

Association itself is 23-30ms on all four; the entire difference is in
how long the AP takes to start passing the station's data frames.


Air trace
---------

Captured with a separate monitor-mode radio (AR9271 on an unrelated
host), against AP2. Times relative to the station's Assoc Request:

    +0.0 ms   ASSOC-REQ    from STA
    +3.2 ms   ASSOC-RESP   to STA
    +7.8 ms   EAPOL        from STA      (4-way)
   +12.5 ms   EAPOL        from STA
   +15.1 ms   DATA (enc)   from STA      <- ACKed by AP
   +45.2 ms   DATA (enc)   from STA      <- ACKed
   +76 / +105 / +135 / +165 ms           <- ACKed (BlockAck)
  +178.1 ms   DATA (enc)   to STA        <- first downlink; SYN-ACK

Every one of those uplink data frames is acknowledged. None of them
appears on the AP's netdev: tcpdump on the AP interface sees no TCP SYN
until roughly the +165ms frame.

Corresponding hostapd -dd output for the same association:

  .697155  AP-STA-CONNECTED
  .697237  nl80211: Set STA flags ... flags_or=0x1
  .698663  IEEE 802.1X: authorizing port
  .698795  WPA: pairwise key handshake completed (RSN)
  .698816  EAPOL-4WAY-HS-COMPLETED

The port is authorized 0.2ms before the handshake-complete line, so
hostapd is not the one holding the frames back. Association to
EAPOL-4WAY-HS-COMPLETED is a median of 70.7ms (n=229).

There is no group-key handshake in these logs, and the behaviour is
unchanged with RADIUS accounting absent from the configuration.


Why this looks like mac80211 rather than one driver
---------------------------------------------------

Two SoftMAC drivers from unrelated vendors (ath9k_htc, mt76) both show
it; two FullMAC/firmware-offloaded stacks (brcmfmac, Espressif) both do
not. The AP3/AP4 pair isolates this to the radio and driver with
everything else identical.

That suggests the pairwise key becomes usable for RX some time after
hostapd authorizes the controlled port, rather than atomically with it.
I have not instrumented the kernel, so the split above is inference
from black-box behaviour, not from code inspection - happy to run
whatever tracing would settle it.


Anticipated objection
---------------------

The station does transmit its first data frame ~3ms after sending EAPOL
4/4, i.e. before the AP has finished installing the key. That is legal,
and more importantly the AP acknowledges those frames, so the station
has no way to learn they were discarded. FullMAC APs carry the very
same frames from the very same station without loss.


AP5 excluded
------------

The AR958x card came up in regulatory domain 00 advertising 30 dBm;
"iw reg set DE" corrected it to 20 dBm. Even then, association and the
4-way handshake succeed while no data frame ever reaches the netdev, so
that card looks miscalibrated and is not reported as a data point.


Reproducing
-----------

Any station that sends immediately on association will show it. The
metric that makes it obvious is "TCP connect attempts before success"
with a short (20-40ms) per-attempt timeout; with a normal blocking
connect it is masked as a single ~1.3s stall, which is how it went
unnoticed here for a long time.

Happy to provide pcaps, full hostapd -dd logs, or to test patches.

I am not subscribed to the list; please keep me on Cc for replies.

Thanks,
Thomas Hilber
