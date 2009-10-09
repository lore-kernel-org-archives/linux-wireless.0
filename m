Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:49852 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZJISxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 14:53:19 -0400
Received: by fxm27 with SMTP id 27so6669252fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2009 11:52:42 -0700 (PDT)
Date: Fri, 9 Oct 2009 16:39:22 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: 2.6.31.[12] ath5k regression
Message-ID: <20091009143922.GA7848@linux-m68k.org>
References: <20090621134954.GA31505@linux-m68k.org> <20090621180447.GA29469@hash.localnet> <20090623174616.GA3914@linux-m68k.org> <20090623202541.GA3635@hash.localnet> <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090705123105.GE2132@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath5k no longer works for me in 2.6.31.[1-2]. 

2.6.31 worked good enough even though in patched 2.6.30.3 the connection and association 
is seemingly more stable.

All tests done in ad-hoc mode with 2 computers, the other end is a rt73usb which
is not quite trouble free either.

I have now confirmed that going back to 2.6.31 the wlan works at least most of the
time and completely stops working after applying this patch on top of 2.6.31

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 029c1bc..ba6d225 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2676,7 +2676,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
                sc->curchan = chan;
                sc->curband = &sc->sbands[chan->band];
        }
-       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
+       ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
        if (ret) {
                ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
                goto err;

One more odd observation - since 2.6.31 "iwlist wlan0 scan" will list my own ad-hoc
network twice although there are really only 2 machines.

messages:
Oct  8 10:44:09 richard kernel: [ 5818.459845] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Oct  8 10:44:09 richard kernel: [ 5818.460301] ath5k 0000:02:00.0: registered as 'phy0'
Oct  8 10:44:09 richard kernel: [ 5818.564470] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)

lspci:
02:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)

Some messages I caught on the other end of the connection:
- after cold booting the ath5k device:
[26996.271773] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSI
D=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[27302.312129] wlan0: sta_find_ibss (active_ibss=0)
[27302.312134]    sta_find_ibss: selected da:d2:d4:53:53:03 current da:d2:d4:53:
53:03
[27302.312136]    did not try to join ibss


- after warm reboot from working 2.6.30.3

[26763.469116] wlan0: dropped frame to 00:22:43:2c:76:0f (unauthorized port)
[26763.931242] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSI
D=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[26763.931248] wlan0: Sending ProbeResp to 00:22:43:2c:76:0f
[26764.469021] wlan0: dropped frame to 00:22:43:2c:76:0f (unauthorized port)
[26764.469115] wlan0: dropped frame to 00:22:43:2c:76:0f (unauthorized port)
[26766.151827] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSI
D=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[26766.151833] wlan0: Sending ProbeResp to 00:22:43:2c:76:0f


Richard
