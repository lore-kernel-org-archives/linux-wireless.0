Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34452 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933563AbcIOIMQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 04:12:16 -0400
Received: by mail-lf0-f65.google.com with SMTP id k12so1632251lfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2016 01:12:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: brcmf_txfinalize misses 802.1x packet leading to infinite WARNINGs
Date: Thu, 15 Sep 2016 10:11:35 +0200
Message-Id: <20160915081135.24477-1-zajec5@gmail.com> (sfid-20160915_101227_091096_F32E6AE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Yesterday I explained on OpenWrt forum [0] that there are 2 problems
leading to WARNINGs triggered by brcmf_netdev_wait_pend8021x.

The first one is firmware problem with A-MPDU implementation. I already
reported this in "AMPDU stalls with brcmfmac4366b-pcie.bin triggering
WARNINGs" e-mail thread [1].

Another one (I'm reporting right now) is related to brcmfmac and its
counting of 802.1x packets. The idea is simple:
1) In ndo_start_xmit callback there is check for ETH_P_PAE and code
   increasing 802.1x counter by 1.
2) In brcmf_txfinalize there is check for ETH_P_PAE and code decreasing
   802.1x counter by 1.
This is needed as some operations have to be handled without any 802.1x
packet pending.

Thanks to my debugging code (you can find it at the end) I just noticed
that:
1) Sometimes (very rarely) brcmf_txfinalize doesn't detect 802.1x packet
2) brcmu_pkt_buf_free_skb gets called and skb gets freed
3) Counter remains not-decreased and brcmf_netdev_wait_pend8021x will
   always time out.

I'm not sure why this could be happening. The check for ETH_P_PAE looks
exactly the same in both places. My only idea so far is firmware
corrupting skb data. This fools brcmfmac code and my debugging code was
lucky enough to keep tracing skbs (by their addresses) to notice that.

I'm going to extend my debugging patch by making a copy of eth header
and comparing it with corrupted one. As this bug occurs very rarely it
make take days or weeks to get any update.

I'd love to hear any comment meanwhile.

[0] https://forum.openwrt.org/viewtopic.php?pid=338235#p338235
[1] https://marc.info/?t=147383216200001&r=1&w=2

[ 1438.965889] brcmfmac: CONSOLE: 028168.028 wl0.3: wlc_send_bar: seq 0xee tid 0
[ 1438.993255] brcmfmac: CONSOLE: 028168.055 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.000743] brcmfmac: CONSOLE: 028168.060 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.008060] brcmfmac: CONSOLE: 028168.067 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.015568] brcmfmac: CONSOLE: 028168.073 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.022786] brcmfmac: CONSOLE: 028168.077 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.030150] brcmfmac: CONSOLE: 028168.078 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.037342] brcmfmac: CONSOLE: 028168.081 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.044554] brcmfmac: CONSOLE: 028168.088 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.051756] brcmfmac: CONSOLE: 028168.090 wl0.3: wlc_send_bar: seq 0xef tid 0
[ 1439.362540] brcmfmac: CONSOLE: 028168.425 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.369827] brcmfmac: CONSOLE: 028168.431 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.378367] brcmfmac: CONSOLE: 028168.432 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.385590] brcmfmac: CONSOLE: 028168.434 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.392839] brcmfmac: CONSOLE: 028168.435 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.400041] brcmfmac: CONSOLE: 028168.438 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.407226] brcmfmac: CONSOLE: 028168.440 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.414848] brcmfmac: CONSOLE: 028168.447 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.422069] brcmfmac: CONSOLE: 028168.451 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.429269] brcmfmac: CONSOLE: 028168.454 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.436454] brcmfmac: CONSOLE: 028168.455 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.443653] brcmfmac: CONSOLE: 028168.457 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.450848] brcmfmac: CONSOLE: 028168.459 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.458031] brcmfmac: CONSOLE: 028168.462 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.465229] brcmfmac: CONSOLE: 028168.465 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.472426] brcmfmac: CONSOLE: 028168.468 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.479623] brcmfmac: CONSOLE: 028168.471 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.486807] brcmfmac: CONSOLE: 028168.472 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.494008] brcmfmac: CONSOLE: 028168.474 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.501200] brcmfmac: CONSOLE: 028168.476 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.510826] brcmfmac: CONSOLE: 028168.479 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.518032] brcmfmac: CONSOLE: 028168.487 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.525252] brcmfmac: CONSOLE: 028168.489 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.532456] brcmfmac: CONSOLE: 028168.492 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.539647] brcmfmac: CONSOLE: 028168.497 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.755188] brcmfmac: CONSOLE: 028168.815 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.762642] brcmfmac: CONSOLE: 028168.819 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.769854] brcmfmac: CONSOLE: 028168.821 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.777087] brcmfmac: CONSOLE: 028168.823 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.784293] brcmfmac: CONSOLE: 028168.824 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.791861] brcmfmac: CONSOLE: 028168.826 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.799057] brcmfmac: CONSOLE: 028168.829 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.806275] brcmfmac: CONSOLE: 028168.831 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.813480] brcmfmac: CONSOLE: 028168.833 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.820673] brcmfmac: CONSOLE: 028168.836 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.827864] brcmfmac: CONSOLE: 028168.837 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1439.835062] brcmfmac: CONSOLE: 028168.840 wl0.3: wlc_send_bar: seq 0xf0 tid 0
[ 1440.260527] brcmfmac: CONSOLE: 028169.323 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.267852] brcmfmac: CONSOLE: 028169.327 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.275216] brcmfmac: CONSOLE: 028169.331 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.282426] brcmfmac: CONSOLE: 028169.334 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.289630] brcmfmac: CONSOLE: 028169.336 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.296819] brcmfmac: CONSOLE: 028169.337 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.304448] brcmfmac: CONSOLE: 028169.340 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.311666] brcmfmac: CONSOLE: 028169.349 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.318857] brcmfmac: CONSOLE: 028169.357 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.326062] brcmfmac: CONSOLE: 028169.360 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.333262] brcmfmac: CONSOLE: 028169.363 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.340457] brcmfmac: CONSOLE: 028169.365 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.347640] brcmfmac: CONSOLE: 028169.366 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.356135] brcmfmac: CONSOLE: 028169.368 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.363382] brcmfmac: CONSOLE: 028169.372 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.370587] brcmfmac: CONSOLE: 028169.374 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.377774] brcmfmac: CONSOLE: 028169.377 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.384973] brcmfmac: CONSOLE: 028169.380 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.392173] brcmfmac: CONSOLE: 028169.383 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.399370] brcmfmac: CONSOLE: 028169.384 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.406558] brcmfmac: CONSOLE: 028169.386 wl0.3: wlc_send_bar: seq 0xf2 tid 0
[ 1440.414653] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c72e7c80] ***BUG*** skb:c70ddc00 skb->dev:c72e7800 skb->dev->name:wlan1-1
[ 1440.957565] brcmfmac: CONSOLE: 028170.020 wl0.3: wlc_send_bar: seq 0xf3 tid 0
[ 1440.964891] brcmfmac: CONSOLE: 028170.027 wl0.3: wlc_send_bar: seq 0xf3 tid 0
[ 1442.342916] brcmfmac: CONSOLE: 028171.405 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.350203] brcmfmac: CONSOLE: 028171.412 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.357617] brcmfmac: CONSOLE: 028171.415 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.364835] brcmfmac: CONSOLE: 028171.418 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.372032] brcmfmac: CONSOLE: 028171.420 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.379324] brcmfmac: CONSOLE: 028171.422 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.386520] brcmfmac: CONSOLE: 028171.424 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.393722] brcmfmac: CONSOLE: 028171.427 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.400922] brcmfmac: CONSOLE: 028171.429 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.408113] brcmfmac: CONSOLE: 028171.431 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.415310] brcmfmac: CONSOLE: 028171.432 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.422514] brcmfmac: CONSOLE: 028171.434 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.429708] brcmfmac: CONSOLE: 028171.436 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.436897] brcmfmac: CONSOLE: 028171.437 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.444094] brcmfmac: CONSOLE: 028171.439 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.452465] brcmfmac: CONSOLE: 028171.442 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.459706] brcmfmac: CONSOLE: 028171.444 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.466901] brcmfmac: CONSOLE: 028171.448 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.474105] brcmfmac: CONSOLE: 028171.451 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.481303] brcmfmac: CONSOLE: 028171.453 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.488493] brcmfmac: CONSOLE: 028171.455 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.495692] brcmfmac: CONSOLE: 028171.457 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.502889] brcmfmac: CONSOLE: 028171.458 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.510085] brcmfmac: CONSOLE: 028171.459 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.517270] brcmfmac: CONSOLE: 028171.461 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.762397] brcmfmac: CONSOLE: 028171.822 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.769694] brcmfmac: CONSOLE: 028171.827 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.776886] brcmfmac: CONSOLE: 028171.829 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.784098] brcmfmac: CONSOLE: 028171.832 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.791640] brcmfmac: CONSOLE: 028171.835 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.798837] brcmfmac: CONSOLE: 028171.842 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.806048] brcmfmac: CONSOLE: 028171.846 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.813249] brcmfmac: CONSOLE: 028171.847 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.820446] brcmfmac: CONSOLE: 028171.848 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.827636] brcmfmac: CONSOLE: 028171.850 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.834834] brcmfmac: CONSOLE: 028171.851 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.842033] brcmfmac: CONSOLE: 028171.853 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.849864] brcmfmac: CONSOLE: 028171.855 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.857061] brcmfmac: CONSOLE: 028171.858 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.864281] brcmfmac: CONSOLE: 028171.859 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.871478] brcmfmac: CONSOLE: 028171.861 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.878669] brcmfmac: CONSOLE: 028171.862 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.885867] brcmfmac: CONSOLE: 028171.864 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.893066] brcmfmac: CONSOLE: 028171.866 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.900265] brcmfmac: CONSOLE: 028171.867 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.907453] brcmfmac: CONSOLE: 028171.869 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.914650] brcmfmac: CONSOLE: 028171.870 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.921846] brcmfmac: CONSOLE: 028171.872 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1442.929031] brcmfmac: CONSOLE: 028171.875 wl0.3: wlc_send_bar: seq 0xf4 tid 0
[ 1443.764523] brcmfmac: CONSOLE: 028172.824 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1447.993455] brcmfmac: CONSOLE: 028177.053 wl0.3: wlc_send_bar: seq 0xf7 tid 0
[ 1449.926507] brcmfmac: CONSOLE: 028178.988 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.934078] brcmfmac: CONSOLE: 028178.993 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.941446] brcmfmac: CONSOLE: 028178.996 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.948875] brcmfmac: CONSOLE: 028179.000 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.956184] brcmfmac: CONSOLE: 028179.006 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.963782] brcmfmac: CONSOLE: 028179.012 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.971078] brcmfmac: CONSOLE: 028179.015 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.978356] brcmfmac: CONSOLE: 028179.017 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.985644] brcmfmac: CONSOLE: 028179.019 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1449.992924] brcmfmac: CONSOLE: 028179.024 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.000690] brcmfmac: CONSOLE: 028179.026 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.007978] brcmfmac: CONSOLE: 028179.027 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.015289] brcmfmac: CONSOLE: 028179.030 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.022575] brcmfmac: CONSOLE: 028179.035 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.029857] brcmfmac: CONSOLE: 028179.036 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.037135] brcmfmac: CONSOLE: 028179.038 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.044419] brcmfmac: CONSOLE: 028179.042 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.051710] brcmfmac: CONSOLE: 028179.045 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.058991] brcmfmac: CONSOLE: 028179.047 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.066280] brcmfmac: CONSOLE: 028179.049 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.073560] brcmfmac: CONSOLE: 028179.053 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.080843] brcmfmac: CONSOLE: 028179.055 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.088121] brcmfmac: CONSOLE: 028179.058 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.095405] brcmfmac: CONSOLE: 028179.061 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.102691] brcmfmac: CONSOLE: 028179.062 wl0.3: wlc_send_bar: seq 0x115 tid 0
[ 1450.661523] brcmfmac: CONSOLE: 028179.723 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.668918] brcmfmac: CONSOLE: 028179.729 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.676514] brcmfmac: CONSOLE: 028179.734 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.683897] brcmfmac: CONSOLE: 028179.744 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.691251] brcmfmac: CONSOLE: 028179.751 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.698605] brcmfmac: CONSOLE: 028179.754 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.705904] brcmfmac: CONSOLE: 028179.759 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.713546] brcmfmac: CONSOLE: 028179.761 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.720847] brcmfmac: CONSOLE: 028179.765 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.728127] brcmfmac: CONSOLE: 028179.770 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.735416] brcmfmac: CONSOLE: 028179.772 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.742695] brcmfmac: CONSOLE: 028179.775 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.750607] brcmfmac: CONSOLE: 028179.779 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.757899] brcmfmac: CONSOLE: 028179.788 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.765203] brcmfmac: CONSOLE: 028179.792 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.772492] brcmfmac: CONSOLE: 028179.795 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1450.779774] brcmfmac: CONSOLE: 028179.799 wl0.3: wlc_send_bar: seq 0x11b tid 0
[ 1452.985248] brcmfmac: CONSOLE: 028182.047 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1452.992662] brcmfmac: CONSOLE: 028182.053 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.000038] brcmfmac: CONSOLE: 028182.060 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.007322] brcmfmac: CONSOLE: 028182.062 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.014994] brcmfmac: CONSOLE: 028182.065 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.022299] brcmfmac: CONSOLE: 028182.072 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.029585] brcmfmac: CONSOLE: 028182.074 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.037036] brcmfmac: CONSOLE: 028182.081 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.044338] brcmfmac: CONSOLE: 028182.084 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.051624] brcmfmac: CONSOLE: 028182.087 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.058900] brcmfmac: CONSOLE: 028182.090 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.066184] brcmfmac: CONSOLE: 028182.092 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.073470] brcmfmac: CONSOLE: 028182.094 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.080756] brcmfmac: CONSOLE: 028182.097 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.088792] brcmfmac: CONSOLE: 028182.099 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.096128] brcmfmac: CONSOLE: 028182.104 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.103417] brcmfmac: CONSOLE: 028182.107 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.110711] brcmfmac: CONSOLE: 028182.110 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.117992] brcmfmac: CONSOLE: 028182.117 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.125282] brcmfmac: CONSOLE: 028182.119 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.132566] brcmfmac: CONSOLE: 028182.122 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.139847] brcmfmac: CONSOLE: 028182.124 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.147125] brcmfmac: CONSOLE: 028182.126 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.154408] brcmfmac: CONSOLE: 028182.128 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.161697] brcmfmac: CONSOLE: 028182.132 wl0.3: wlc_send_bar: seq 0x121 tid 0
[ 1453.416116] brcmfmac: CONSOLE: 028182.478 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.423779] brcmfmac: CONSOLE: 028182.482 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.431240] brcmfmac: CONSOLE: 028182.486 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.438528] brcmfmac: CONSOLE: 028182.491 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.446145] brcmfmac: CONSOLE: 028182.496 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.453452] brcmfmac: CONSOLE: 028182.500 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.460738] brcmfmac: CONSOLE: 028182.502 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.468015] brcmfmac: CONSOLE: 028182.504 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.475299] brcmfmac: CONSOLE: 028182.507 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.483067] brcmfmac: CONSOLE: 028182.510 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.490376] brcmfmac: CONSOLE: 028182.516 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.497652] brcmfmac: CONSOLE: 028182.519 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.504944] brcmfmac: CONSOLE: 028182.524 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.512229] brcmfmac: CONSOLE: 028182.527 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.519523] brcmfmac: CONSOLE: 028182.530 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.526801] brcmfmac: CONSOLE: 028182.533 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.534091] brcmfmac: CONSOLE: 028182.535 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.541375] brcmfmac: CONSOLE: 028182.538 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.548649] brcmfmac: CONSOLE: 028182.540 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.555932] brcmfmac: CONSOLE: 028182.544 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.564982] brcmfmac: CONSOLE: 028182.546 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.572314] brcmfmac: CONSOLE: 028182.552 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.579602] brcmfmac: CONSOLE: 028182.557 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.586877] brcmfmac: CONSOLE: 028182.559 wl0.3: wlc_send_bar: seq 0x122 tid 0
[ 1453.789702] brcmfmac: CONSOLE: 028182.847 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1453.849763] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1453.873976] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1454.814699] brcmfmac: CONSOLE: 028183.875 wl0.3: wlc_send_bar: seq 0x125 tid 0
[ 1454.838718] ------------[ cut here ]------------
[ 1454.843449] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1454.859799] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1454.932168] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1454.939403] Hardware name: BCM5301X
[ 1454.942893] Backtrace: 
[ 1454.945371] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1454.952956]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1454.958672] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1454.965912] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1454.974018]  r5:00000009 r4:00000000
[ 1454.977616] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1454.986412]  r8:c73300a4 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1454.993201] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1455.003676] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1455.016312]  r8:c73300a4 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330394
[ 1455.023082] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1455.035277]  r7:00000000 r6:c72e7c80 r5:c73300a4 r4:00000004
[ 1455.041020] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1455.051736]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1455.059622]  r4:bf1ad460
[ 1455.062194] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1455.071173]  r8:c7a3d6c0 r7:c59cb214 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1455.077932] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1455.085777]  r10:c7a3d6c0 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c7a3d6c0
[ 1455.093663]  r4:c59cb200
[ 1455.096210] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1455.103707]  r7:c6484800 r6:c7a3d6c0 r5:c7a3d6c0 r4:c04a42a0
[ 1455.109413] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1455.117086]  r5:00000048 r4:c7962800
[ 1455.120686] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1455.128967]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1455.136773] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1455.144617]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1455.152502]  r4:c6b3ff4c
[ 1455.155048] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1455.162986] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1455.170833]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1455.178718]  r4:c754e780
[ 1455.181264] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1455.188850]  r6:000030b0 r5:00000000 r4:00000000
[ 1455.193504] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1455.201292] ---[ end trace 71b7d8e23b95aa1d ]---
[ 1455.205925] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1455.217002] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1455.224430] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1455.237496] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1455.247702] brcmfmac: CONSOLE: 028184.309 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.255381] brcmfmac: CONSOLE: 028184.313 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.262736] brcmfmac: CONSOLE: 028184.321 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.270171] brcmfmac: CONSOLE: 028184.326 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.271097] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1455.287416] brcmfmac: CONSOLE: 028184.329 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.294712] brcmfmac: CONSOLE: 028184.331 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.302623] brcmfmac: CONSOLE: 028184.334 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.303878] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1455.319897] brcmfmac: CONSOLE: 028184.337 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.327176] brcmfmac: CONSOLE: 028184.339 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.334467] brcmfmac: CONSOLE: 028184.343 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.341750] brcmfmac: CONSOLE: 028184.347 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.349027] brcmfmac: CONSOLE: 028184.349 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.356317] brcmfmac: CONSOLE: 028184.352 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.363597] brcmfmac: CONSOLE: 028184.355 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.370886] brcmfmac: CONSOLE: 028184.358 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.378160] brcmfmac: CONSOLE: 028184.361 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.385445] brcmfmac: CONSOLE: 028184.363 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.394420] brcmfmac: CONSOLE: 028184.367 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.401738] brcmfmac: CONSOLE: 028184.374 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.409015] brcmfmac: CONSOLE: 028184.376 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.416308] brcmfmac: CONSOLE: 028184.379 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.423593] brcmfmac: CONSOLE: 028184.381 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.430877] brcmfmac: CONSOLE: 028184.384 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.438156] brcmfmac: CONSOLE: 028184.388 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.445440] brcmfmac: CONSOLE: 028184.389 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.793875] brcmfmac: CONSOLE: 028184.852 wl0.3: wlc_send_bar: seq 0x126 tid 0
[ 1455.821381] brcmfmac: CONSOLE: 028184.883 wl0.3: wlc_send_bar: seq 0x129 tid 0
[ 1455.830336] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1455.833146] brcmfmac: CONSOLE: 028184.895 wl0.3: wlc_send_bar: seq 0x12a tid 0
[ 1455.841646] brcmfmac: CONSOLE: 028184.902 wl0.3: wlc_send_bar: seq 0x12a tid 0
[ 1455.905387] brcmfmac: CONSOLE: 028184.967 wl0.3: wlc_send_bar: seq 0x132 tid 0
[ 1455.912772] brcmfmac: CONSOLE: 028184.974 wl0.3: wlc_send_bar: seq 0x133 tid 0
[ 1455.922837] brcmfmac: CONSOLE: 028184.984 wl0.3: wlc_send_bar: seq 0x135 tid 0
[ 1457.068613] brcmfmac: CONSOLE: 028186.130 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.077306] brcmfmac: CONSOLE: 028186.138 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.084678] brcmfmac: CONSOLE: 028186.141 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.091983] brcmfmac: CONSOLE: 028186.144 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.099642] brcmfmac: CONSOLE: 028186.147 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.106925] brcmfmac: CONSOLE: 028186.150 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.114224] brcmfmac: CONSOLE: 028186.155 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.121508] brcmfmac: CONSOLE: 028186.159 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.129477] brcmfmac: CONSOLE: 028186.162 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.136860] brcmfmac: CONSOLE: 028186.167 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.144164] brcmfmac: CONSOLE: 028186.172 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.151529] brcmfmac: CONSOLE: 028186.175 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.158807] brcmfmac: CONSOLE: 028186.177 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.166098] brcmfmac: CONSOLE: 028186.181 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.173390] brcmfmac: CONSOLE: 028186.185 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.180676] brcmfmac: CONSOLE: 028186.188 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.187957] brcmfmac: CONSOLE: 028186.190 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.196395] brcmfmac: CONSOLE: 028186.194 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.203736] brcmfmac: CONSOLE: 028186.199 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.211024] brcmfmac: CONSOLE: 028186.203 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.218298] brcmfmac: CONSOLE: 028186.206 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.225584] brcmfmac: CONSOLE: 028186.210 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.232877] brcmfmac: CONSOLE: 028186.212 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.240167] brcmfmac: CONSOLE: 028186.214 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.247439] brcmfmac: CONSOLE: 028186.217 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.801179] brcmfmac: CONSOLE: 028186.858 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.812998] brcmfmac: CONSOLE: 028186.874 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.870210] brcmfmac: CONSOLE: 028186.890 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.877495] brcmfmac: CONSOLE: 028186.897 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.884789] brcmfmac: CONSOLE: 028186.909 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.892073] brcmfmac: CONSOLE: 028186.917 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 1457.899359] brcmfmac: CONSOLE: 028186.922 wl0.3: wlc_send_bar: seq 0x136 tid 0
[ 11]  0.0-942.0 sec   135 MBytes  1.20 Mbits/sec
[ 1459.618959] brcmfmac: CONSOLE: 028188.680 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.626515] brcmfmac: CONSOLE: 028188.684 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.633822] brcmfmac: CONSOLE: 028188.687 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.641212] brcmfmac: CONSOLE: 028188.690 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.648490] brcmfmac: CONSOLE: 028188.693 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.655790] brcmfmac: CONSOLE: 028188.696 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.663078] brcmfmac: CONSOLE: 028188.698 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.670359] brcmfmac: CONSOLE: 028188.699 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.677638] brcmfmac: CONSOLE: 028188.701 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.684923] brcmfmac: CONSOLE: 028188.702 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.692916] brcmfmac: CONSOLE: 028188.705 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.700235] brcmfmac: CONSOLE: 028188.708 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.707512] brcmfmac: CONSOLE: 028188.714 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.714799] brcmfmac: CONSOLE: 028188.716 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.722078] brcmfmac: CONSOLE: 028188.718 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.729358] brcmfmac: CONSOLE: 028188.722 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.736635] brcmfmac: CONSOLE: 028188.725 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.743925] brcmfmac: CONSOLE: 028188.727 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.751212] brcmfmac: CONSOLE: 028188.730 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.758491] brcmfmac: CONSOLE: 028188.731 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.765772] brcmfmac: CONSOLE: 028188.733 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.773050] brcmfmac: CONSOLE: 028188.737 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.780334] brcmfmac: CONSOLE: 028188.739 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.787604] brcmfmac: CONSOLE: 028188.741 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.794887] brcmfmac: CONSOLE: 028188.743 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.804427] brcmfmac: CONSOLE: 028188.863 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.812061] brcmfmac: CONSOLE: 028188.869 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.819716] brcmfmac: CONSOLE: 028188.875 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.827002] brcmfmac: CONSOLE: 028188.877 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.834297] brcmfmac: CONSOLE: 028188.880 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.841892] brcmfmac: CONSOLE: 028188.883 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.849180] brcmfmac: CONSOLE: 028188.888 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.856479] brcmfmac: CONSOLE: 028188.894 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.863766] brcmfmac: CONSOLE: 028188.895 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.871052] brcmfmac: CONSOLE: 028188.897 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.878328] brcmfmac: CONSOLE: 028188.899 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.885611] brcmfmac: CONSOLE: 028188.901 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.892898] brcmfmac: CONSOLE: 028188.902 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.900875] brcmfmac: CONSOLE: 028188.904 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.908160] brcmfmac: CONSOLE: 028188.907 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.915463] brcmfmac: CONSOLE: 028188.908 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.922754] brcmfmac: CONSOLE: 028188.910 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.930035] brcmfmac: CONSOLE: 028188.912 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.937315] brcmfmac: CONSOLE: 028188.914 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.944599] brcmfmac: CONSOLE: 028188.918 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.951881] brcmfmac: CONSOLE: 028188.921 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.959153] brcmfmac: CONSOLE: 028188.923 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.966436] brcmfmac: CONSOLE: 028188.925 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1459.973721] brcmfmac: CONSOLE: 028188.927 wl0.3: wlc_send_bar: seq 0x188 tid 0
[ 1460.806519] brcmfmac: CONSOLE: 028189.865 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1462.826374] brcmfmac: CONSOLE: 028191.887 wl0.3: wlc_send_bar: seq 0x18e tid 0
[ 1463.048190] brcmfmac: CONSOLE: 028192.109 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.055563] brcmfmac: CONSOLE: 028192.113 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.062684] brcmfmac: CONSOLE: 028192.116 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.069870] brcmfmac: CONSOLE: 028192.119 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.076977] brcmfmac: CONSOLE: 028192.122 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.084092] brcmfmac: CONSOLE: 028192.125 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.091196] brcmfmac: CONSOLE: 028192.128 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.098382] brcmfmac: CONSOLE: 028192.131 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.105495] brcmfmac: CONSOLE: 028192.134 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.112601] brcmfmac: CONSOLE: 028192.136 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.119708] brcmfmac: CONSOLE: 028192.139 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.126805] brcmfmac: CONSOLE: 028192.142 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.133915] brcmfmac: CONSOLE: 028192.145 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.141016] brcmfmac: CONSOLE: 028192.149 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.148112] brcmfmac: CONSOLE: 028192.152 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.155213] brcmfmac: CONSOLE: 028192.155 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.162316] brcmfmac: CONSOLE: 028192.158 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.170349] brcmfmac: CONSOLE: 028192.161 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.177457] brcmfmac: CONSOLE: 028192.164 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.184592] brcmfmac: CONSOLE: 028192.167 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.191703] brcmfmac: CONSOLE: 028192.170 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.198807] brcmfmac: CONSOLE: 028192.172 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.205916] brcmfmac: CONSOLE: 028192.175 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.213025] brcmfmac: CONSOLE: 028192.177 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.220127] brcmfmac: CONSOLE: 028192.180 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.817324] brcmfmac: CONSOLE: 028192.875 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.824704] brcmfmac: CONSOLE: 028192.880 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.831831] brcmfmac: CONSOLE: 028192.883 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.839029] brcmfmac: CONSOLE: 028192.886 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.846158] brcmfmac: CONSOLE: 028192.889 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.853270] brcmfmac: CONSOLE: 028192.892 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.860376] brcmfmac: CONSOLE: 028192.895 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.867473] brcmfmac: CONSOLE: 028192.898 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.875115] brcmfmac: CONSOLE: 028192.901 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.882262] brcmfmac: CONSOLE: 028192.904 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.889373] brcmfmac: CONSOLE: 028192.906 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1463.896474] brcmfmac: CONSOLE: 028192.911 wl0.3: wlc_send_bar: seq 0x3 tid 6
[ 1464.681930] brcmfmac: CONSOLE: 028193.743 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.689550] brcmfmac: CONSOLE: 028193.746 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.696947] brcmfmac: CONSOLE: 028193.750 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.704248] brcmfmac: CONSOLE: 028193.754 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.711899] brcmfmac: CONSOLE: 028193.758 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.719179] brcmfmac: CONSOLE: 028193.762 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.726477] brcmfmac: CONSOLE: 028193.764 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.733868] brcmfmac: CONSOLE: 028193.769 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.741162] brcmfmac: CONSOLE: 028193.772 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.748931] brcmfmac: CONSOLE: 028193.774 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.756255] brcmfmac: CONSOLE: 028193.778 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.763547] brcmfmac: CONSOLE: 028193.781 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.770832] brcmfmac: CONSOLE: 028193.785 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.778112] brcmfmac: CONSOLE: 028193.788 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.785397] brcmfmac: CONSOLE: 028193.791 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.792682] brcmfmac: CONSOLE: 028193.793 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.799964] brcmfmac: CONSOLE: 028193.796 wl0.3: wlc_send_bar: seq 0x18f tid 0
[ 1464.808209] brcmfmac: CONSOLE: 028193.816 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.815557] brcmfmac: CONSOLE: 028193.818 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.822848] brcmfmac: CONSOLE: 028193.821 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.830135] brcmfmac: CONSOLE: 028193.824 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.837412] brcmfmac: CONSOLE: 028193.826 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.844698] brcmfmac: CONSOLE: 028193.830 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.851983] brcmfmac: CONSOLE: 028193.832 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.859269] brcmfmac: CONSOLE: 028193.834 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.868425] brcmfmac: CONSOLE: 028193.877 wl0.3: wlc_send_bar: seq 0x190 tid 0
[ 1464.895478] brcmfmac: CONSOLE: 028193.956 wl0.3: wlc_send_bar: seq 0x194 tid 0
[ 1464.903222] brcmfmac: CONSOLE: 028193.960 wl0.3: wlc_send_bar: seq 0x194 tid 0
[ 1464.926485] brcmfmac: CONSOLE: 028193.986 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.933889] brcmfmac: CONSOLE: 028193.994 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.941311] brcmfmac: CONSOLE: 028193.997 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.948590] brcmfmac: CONSOLE: 028194.001 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.956236] brcmfmac: CONSOLE: 028194.005 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.963541] brcmfmac: CONSOLE: 028194.010 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.970827] brcmfmac: CONSOLE: 028194.014 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.978106] brcmfmac: CONSOLE: 028194.016 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.985783] brcmfmac: CONSOLE: 028194.018 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1464.993097] brcmfmac: CONSOLE: 028194.021 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.000387] brcmfmac: CONSOLE: 028194.028 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.007663] brcmfmac: CONSOLE: 028194.030 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.014953] brcmfmac: CONSOLE: 028194.034 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.022231] brcmfmac: CONSOLE: 028194.037 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.029517] brcmfmac: CONSOLE: 028194.039 wl0.3: wlc_send_bar: seq 0x195 tid 0
[ 1465.251651] brcmfmac: CONSOLE: 028194.312 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.259287] brcmfmac: CONSOLE: 028194.316 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.266695] brcmfmac: CONSOLE: 028194.321 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.274002] brcmfmac: CONSOLE: 028194.324 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.281290] brcmfmac: CONSOLE: 028194.327 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.288974] brcmfmac: CONSOLE: 028194.331 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.296289] brcmfmac: CONSOLE: 028194.333 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.303575] brcmfmac: CONSOLE: 028194.339 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.310855] brcmfmac: CONSOLE: 028194.341 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.318136] brcmfmac: CONSOLE: 028194.345 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.325420] brcmfmac: CONSOLE: 028194.348 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.333394] brcmfmac: CONSOLE: 028194.351 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.340711] brcmfmac: CONSOLE: 028194.353 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.347991] brcmfmac: CONSOLE: 028194.357 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.355280] brcmfmac: CONSOLE: 028194.359 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.362568] brcmfmac: CONSOLE: 028194.361 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.369853] brcmfmac: CONSOLE: 028194.364 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.377132] brcmfmac: CONSOLE: 028194.367 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.384423] brcmfmac: CONSOLE: 028194.369 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.391709] brcmfmac: CONSOLE: 028194.372 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.398986] brcmfmac: CONSOLE: 028194.373 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.406272] brcmfmac: CONSOLE: 028194.375 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.413554] brcmfmac: CONSOLE: 028194.380 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.420831] brcmfmac: CONSOLE: 028194.381 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.428109] brcmfmac: CONSOLE: 028194.384 wl0.3: wlc_send_bar: seq 0x199 tid 0
[ 1465.481024] brcmfmac: CONSOLE: 028194.541 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.488608] brcmfmac: CONSOLE: 028194.545 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.496029] brcmfmac: CONSOLE: 028194.550 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.503332] brcmfmac: CONSOLE: 028194.554 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.510900] brcmfmac: CONSOLE: 028194.558 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.518181] brcmfmac: CONSOLE: 028194.561 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.525480] brcmfmac: CONSOLE: 028194.564 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.532768] brcmfmac: CONSOLE: 028194.566 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.540050] brcmfmac: CONSOLE: 028194.569 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.547755] brcmfmac: CONSOLE: 028194.573 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.555074] brcmfmac: CONSOLE: 028194.575 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.562401] brcmfmac: CONSOLE: 028194.580 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.569692] brcmfmac: CONSOLE: 028194.583 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.577060] brcmfmac: CONSOLE: 028194.585 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.584360] brcmfmac: CONSOLE: 028194.587 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.591656] brcmfmac: CONSOLE: 028194.588 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.598934] brcmfmac: CONSOLE: 028194.590 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.606228] brcmfmac: CONSOLE: 028194.593 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1465.613513] brcmfmac: CONSOLE: 028194.596 wl0.3: wlc_send_bar: seq 0x19a tid 0
[ 1466.222425] brcmfmac: CONSOLE: 028195.283 wl0.3: wlc_send_bar: seq 0x19d tid 0
[ 1466.229837] brcmfmac: CONSOLE: 028195.288 wl0.3: wlc_send_bar: seq 0x19d tid 0
[ 1466.237535] brcmfmac: CONSOLE: 028195.291 wl0.3: wlc_send_bar: seq 0x19d tid 0
[ 1466.244848] brcmfmac: CONSOLE: 028195.296 wl0.3: wlc_send_bar: seq 0x19d tid 0
[ 1466.252499] brcmfmac: CONSOLE: 028195.298 wl0.3: wlc_send_bar: seq 0x19d tid 0
[ 1466.268564] brcmfmac: CONSOLE: 028195.329 wl0.3: wlc_send_bar: seq 0x19f tid 0
[ 1466.276240] brcmfmac: CONSOLE: 028195.333 wl0.3: wlc_send_bar: seq 0x19f tid 0
[ 1466.283793] brcmfmac: CONSOLE: 028195.337 wl0.3: wlc_send_bar: seq 0x19f tid 0
[ 1476.460872] brcmfmac: CONSOLE: 028205.520 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.468256] brcmfmac: CONSOLE: 028205.522 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.475564] brcmfmac: CONSOLE: 028205.525 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.483087] brcmfmac: CONSOLE: 028205.528 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.490384] brcmfmac: CONSOLE: 028205.530 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.497663] brcmfmac: CONSOLE: 028205.532 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.504952] brcmfmac: CONSOLE: 028205.535 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.512232] brcmfmac: CONSOLE: 028205.538 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.519516] brcmfmac: CONSOLE: 028205.542 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.527716] brcmfmac: CONSOLE: 028205.545 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.535028] brcmfmac: CONSOLE: 028205.547 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.542315] brcmfmac: CONSOLE: 028205.550 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.549598] brcmfmac: CONSOLE: 028205.552 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.556877] brcmfmac: CONSOLE: 028205.554 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1476.564160] brcmfmac: CONSOLE: 028205.556 wl0.3: wlc_send_bar: seq 0x234 tid 0
[ 1482.361522] brcmfmac: CONSOLE: 028211.419 wl0.2: wlc_send_bar: seq 0x800 tid 0
[ 1483.879249] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1483.986701] brcmfmac: CONSOLE: 028213.044 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1483.994149] brcmfmac: CONSOLE: 028213.047 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.001452] brcmfmac: CONSOLE: 028213.051 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.008831] brcmfmac: CONSOLE: 028213.054 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.016132] brcmfmac: CONSOLE: 028213.058 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.023456] brcmfmac: CONSOLE: 028213.060 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.030740] brcmfmac: CONSOLE: 028213.062 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.038016] brcmfmac: CONSOLE: 028213.063 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.045305] brcmfmac: CONSOLE: 028213.065 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.053257] brcmfmac: CONSOLE: 028213.067 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.053448] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1484.070518] brcmfmac: CONSOLE: 028213.069 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.077794] brcmfmac: CONSOLE: 028213.070 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.085083] brcmfmac: CONSOLE: 028213.072 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.092364] brcmfmac: CONSOLE: 028213.073 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.099648] brcmfmac: CONSOLE: 028213.076 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.106926] brcmfmac: CONSOLE: 028213.082 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.114213] brcmfmac: CONSOLE: 028213.085 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.121494] brcmfmac: CONSOLE: 028213.088 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.128774] brcmfmac: CONSOLE: 028213.091 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.136056] brcmfmac: CONSOLE: 028213.092 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.143342] brcmfmac: CONSOLE: 028213.094 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.150638] brcmfmac: CONSOLE: 028213.096 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.157914] brcmfmac: CONSOLE: 028213.098 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.165198] brcmfmac: CONSOLE: 028213.102 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.172483] brcmfmac: CONSOLE: 028213.106 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.867183] brcmfmac: CONSOLE: 028213.921 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.874786] brcmfmac: CONSOLE: 028213.926 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.882090] brcmfmac: CONSOLE: 028213.929 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.889533] brcmfmac: CONSOLE: 028213.932 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.896815] brcmfmac: CONSOLE: 028213.937 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.904108] brcmfmac: CONSOLE: 028213.941 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.911394] brcmfmac: CONSOLE: 028213.943 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.918670] brcmfmac: CONSOLE: 028213.945 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.926974] brcmfmac: CONSOLE: 028213.947 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1484.934354] brcmfmac: CONSOLE: 028213.950 wl0.3: wlc_send_bar: seq 0x235 tid 0
[ 1485.008731] ------------[ cut here ]------------
[ 1485.013499] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1485.029774] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1485.102143] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1485.109377] Hardware name: BCM5301X
[ 1485.112868] Backtrace: 
[ 1485.115346] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1485.122931]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1485.128647] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1485.135887] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1485.143993]  r5:00000009 r4:00000000
[ 1485.147591] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1485.156395]  r8:c7330148 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1485.163186] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1485.173658] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1485.186286]  r8:c7330148 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330438
[ 1485.193055] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1485.205251]  r7:00000000 r6:c72e7c80 r5:c7330148 r4:00000004
[ 1485.210995] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1485.221711]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1485.229596]  r4:bf1ad460
[ 1485.232168] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1485.241146]  r8:c6473540 r7:c6236e14 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1485.247907] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1485.255752]  r10:c6473540 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c6473540
[ 1485.263637]  r4:c6236e00
[ 1485.266185] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1485.273682]  r7:c6484800 r6:c6473540 r5:c6473540 r4:c04a42a0
[ 1485.279389] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1485.287060]  r5:00000048 r4:c7962800
[ 1485.290661] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1485.298941]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1485.306748] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1485.314591]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1485.322477]  r4:c6b3ff4c
[ 1485.325022] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1485.332962] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1485.340807]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1485.348694]  r4:c754e780
[ 1485.351240] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1485.358824]  r6:000030b0 r5:00000000 r4:00000000
[ 1485.363479] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1485.371265] ---[ end trace 71b7d8e23b95aa1e ]---
[ 1485.375902] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1485.386980] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1485.394400] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1485.406292] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1485.421970] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1485.427158] brcmfmac: CONSOLE: 028214.484 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.433252] brcmfmac: CONSOLE: 028214.487 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.433294] brcmfmac: CONSOLE: 028214.489 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.433337] brcmfmac: CONSOLE: 028214.490 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.437518] brcmfmac: CONSOLE: 028214.494 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.439909] brcmfmac: CONSOLE: 028214.497 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.443100] brcmfmac: CONSOLE: 028214.500 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.447026] brcmfmac: CONSOLE: 028214.503 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.449815] brcmfmac: CONSOLE: 028214.507 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.452589] brcmfmac: CONSOLE: 028214.509 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.456595] brcmfmac: CONSOLE: 028214.513 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.458267] brcmfmac: CONSOLE: 028214.515 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.460859] brcmfmac: CONSOLE: 028214.517 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.464360] brcmfmac: CONSOLE: 028214.520 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.464402] brcmfmac: CONSOLE: 028214.521 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.467907] brcmfmac: CONSOLE: 028214.524 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.469389] brcmfmac: CONSOLE: 028214.526 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.472704] brcmfmac: CONSOLE: 028214.529 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.473830] brcmfmac: CONSOLE: 028214.531 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.476438] brcmfmac: CONSOLE: 028214.533 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.480445] brcmfmac: CONSOLE: 028214.537 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.482618] brcmfmac: CONSOLE: 028214.540 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.487319] brcmfmac: CONSOLE: 028214.542 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.487361] brcmfmac: CONSOLE: 028214.544 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.489251] brcmfmac: CONSOLE: 028214.546 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.616896] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1485.869371] brcmfmac: CONSOLE: 028214.923 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.876700] brcmfmac: CONSOLE: 028214.929 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.884005] brcmfmac: CONSOLE: 028214.931 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.891301] brcmfmac: CONSOLE: 028214.934 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.898972] brcmfmac: CONSOLE: 028214.936 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.906287] brcmfmac: CONSOLE: 028214.938 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.913572] brcmfmac: CONSOLE: 028214.941 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.920853] brcmfmac: CONSOLE: 028214.944 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.928124] brcmfmac: CONSOLE: 028214.945 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.935411] brcmfmac: CONSOLE: 028214.948 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.942693] brcmfmac: CONSOLE: 028214.951 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.949975] brcmfmac: CONSOLE: 028214.953 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.957248] brcmfmac: CONSOLE: 028214.956 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.965260] brcmfmac: CONSOLE: 028214.959 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.972569] brcmfmac: CONSOLE: 028214.962 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.979856] brcmfmac: CONSOLE: 028214.966 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.987130] brcmfmac: CONSOLE: 028214.969 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1485.994419] brcmfmac: CONSOLE: 028214.971 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1486.001697] brcmfmac: CONSOLE: 028214.974 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1486.008976] brcmfmac: CONSOLE: 028214.977 wl0.3: wlc_send_bar: seq 0x236 tid 0
[ 1486.016264] brcmfmac: CONSOLE: 028214.991 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.023545] brcmfmac: CONSOLE: 028214.993 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.030828] brcmfmac: CONSOLE: 028214.997 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.038099] brcmfmac: CONSOLE: 028214.999 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.045382] brcmfmac: CONSOLE: 028215.003 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.052671] brcmfmac: CONSOLE: 028215.005 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.059951] brcmfmac: CONSOLE: 028215.007 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.067223] brcmfmac: CONSOLE: 028215.009 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.074505] brcmfmac: CONSOLE: 028215.010 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.081781] brcmfmac: CONSOLE: 028215.012 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.089052] brcmfmac: CONSOLE: 028215.015 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.096334] brcmfmac: CONSOLE: 028215.016 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.103612] brcmfmac: CONSOLE: 028215.018 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.110896] brcmfmac: CONSOLE: 028215.020 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.118166] brcmfmac: CONSOLE: 028215.022 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.127583] brcmfmac: CONSOLE: 028215.025 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.134929] brcmfmac: CONSOLE: 028215.027 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.142218] brcmfmac: CONSOLE: 028215.029 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.149505] brcmfmac: CONSOLE: 028215.031 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.156779] brcmfmac: CONSOLE: 028215.033 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.164061] brcmfmac: CONSOLE: 028215.035 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.171345] brcmfmac: CONSOLE: 028215.036 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.178618] brcmfmac: CONSOLE: 028215.038 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.185899] brcmfmac: CONSOLE: 028215.040 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.193175] brcmfmac: CONSOLE: 028215.041 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.870751] brcmfmac: CONSOLE: 028215.925 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.878311] brcmfmac: CONSOLE: 028215.930 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.885620] brcmfmac: CONSOLE: 028215.932 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.892915] brcmfmac: CONSOLE: 028215.934 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.900528] brcmfmac: CONSOLE: 028215.937 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.907814] brcmfmac: CONSOLE: 028215.943 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.915122] brcmfmac: CONSOLE: 028215.946 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.922412] brcmfmac: CONSOLE: 028215.949 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.929693] brcmfmac: CONSOLE: 028215.952 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.936970] brcmfmac: CONSOLE: 028215.955 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.944264] brcmfmac: CONSOLE: 028215.957 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.952302] brcmfmac: CONSOLE: 028215.959 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.959623] brcmfmac: CONSOLE: 028215.963 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.966903] brcmfmac: CONSOLE: 028215.966 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.974193] brcmfmac: CONSOLE: 028215.967 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.981481] brcmfmac: CONSOLE: 028215.970 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.988759] brcmfmac: CONSOLE: 028215.973 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1486.996044] brcmfmac: CONSOLE: 028215.976 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.003338] brcmfmac: CONSOLE: 028215.979 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.010629] brcmfmac: CONSOLE: 028215.982 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.017910] brcmfmac: CONSOLE: 028215.985 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.025194] brcmfmac: CONSOLE: 028215.988 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.032480] brcmfmac: CONSOLE: 028215.993 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.039762] brcmfmac: CONSOLE: 028215.995 wl0.3: wlc_send_bar: seq 0x237 tid 0
[ 1487.872903] brcmfmac: CONSOLE: 028216.927 wl0: wlc_ampdu_tx_send_delba: tid 0 initiator 1 reason 39
[ 1488.958911] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1488.971118] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1488.974348] brcmfmac: CONSOLE: 028218.031 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[ 1513.909215] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1514.523174] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1515.479243] ------------[ cut here ]------------
[ 1515.483927] WARNING: CPU: 0 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1515.500065] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1515.572421] CPU: 0 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1515.579657] Hardware name: BCM5301X
[ 1515.583148] Backtrace: 
[ 1515.585621] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1515.593201]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1515.598918] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1515.606158] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1515.614264]  r5:00000009 r4:00000000
[ 1515.617862] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1515.626667]  r8:c73300a4 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1515.633446] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1515.643921] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1515.656548]  r8:c73300a4 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330394
[ 1515.663317] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1515.675514]  r7:00000000 r6:c72e7c80 r5:c73300a4 r4:00000004
[ 1515.681254] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1515.691973]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1515.699859]  r4:bf1ad460
[ 1515.702429] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1515.711401]  r8:c7310c00 r7:c64bb414 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1515.718160] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1515.726006]  r10:c7310c00 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c7310c00
[ 1515.733891]  r4:c64bb400
[ 1515.736439] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1515.743936]  r7:c6484800 r6:c7310c00 r5:c7310c00 r4:c04a42a0
[ 1515.749643] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1515.757314]  r5:00000048 r4:c7962800
[ 1515.760914] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1515.769195]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1515.777001] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1515.784845]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1515.792731]  r4:c6b3ff4c
[ 1515.795275] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1515.803207] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1515.811053]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1515.818938]  r4:c754e780
[ 1515.821485] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1515.829070]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1515.833724] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1515.841501] ---[ end trace 71b7d8e23b95aa1f ]---
[ 1515.846134] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1515.857213] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1515.864639] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1515.877344] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1515.889837] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1515.901287] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1515.913375] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1543.939246] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1544.763370] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1545.728716] ------------[ cut here ]------------
[ 1545.733447] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1545.749739] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1545.822099] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1545.829334] Hardware name: BCM5301X
[ 1545.832825] Backtrace: 
[ 1545.835301] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1545.842887]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1545.848603] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1545.855844] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1545.863950]  r5:00000009 r4:00000000
[ 1545.867548] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1545.876344]  r8:c7330148 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1545.883131] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1545.893614] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1545.906242]  r8:c7330148 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330438
[ 1545.913014] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1545.925208]  r7:00000000 r6:c72e7c80 r5:c7330148 r4:00000004
[ 1545.930953] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1545.941668]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1545.949553]  r4:bf1ad460
[ 1545.952125] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1545.961104]  r8:c691f180 r7:c6234c14 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1545.967864] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1545.975709]  r10:c691f180 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c691f180
[ 1545.983595]  r4:c6234c00
[ 1545.986141] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1545.993640]  r7:c6484800 r6:c691f180 r5:c691f180 r4:c04a42a0
[ 1545.999345] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1546.007018]  r5:00000048 r4:c7962800
[ 1546.010617] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1546.018898]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1546.026705] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1546.034548]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1546.042434]  r4:c6b3ff4c
[ 1546.044979] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1546.052918] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1546.060764]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1546.068651]  r4:c754e780
[ 1546.071196] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1546.078782]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1546.083436] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1546.091221] ---[ end trace 71b7d8e23b95aa20 ]---
[ 1546.095856] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1546.106932] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1546.114347] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1546.125993] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1546.138797] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1546.150658] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1546.162127] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1573.959225] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1574.747511] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1575.708743] ------------[ cut here ]------------
[ 1575.713494] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1575.729805] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1575.802171] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1575.809405] Hardware name: BCM5301X
[ 1575.812896] Backtrace: 
[ 1575.815372] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1575.822958]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1575.828676] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1575.835915] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1575.844021]  r5:00000009 r4:00000000
[ 1575.847619] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1575.856424]  r8:c73300a4 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1575.863212] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1575.873687] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1575.886322]  r8:c73300a4 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330394
[ 1575.893093] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1575.905288]  r7:00000000 r6:c72e7c80 r5:c73300a4 r4:00000004
[ 1575.911031] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1575.921748]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1575.929633]  r4:bf1ad460
[ 1575.932205] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1575.941183]  r8:c691fa80 r7:c6234414 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1575.947944] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1575.955789]  r10:c691fa80 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c691fa80
[ 1575.963674]  r4:c6234400
[ 1575.966222] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1575.973719]  r7:c6484800 r6:c691fa80 r5:c691fa80 r4:c04a42a0
[ 1575.979426] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1575.987097]  r5:00000048 r4:c7962800
[ 1575.990696] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1575.998977]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1576.006784] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1576.014627]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1576.022513]  r4:c6b3ff4c
[ 1576.025059] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1576.032998] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1576.040844]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1576.048729]  r4:c754e780
[ 1576.051276] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1576.058861]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1576.063515] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1576.071304] ---[ end trace 71b7d8e23b95aa21 ]---
[ 1576.075937] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1576.087014] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1576.094436] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1576.159235] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1576.170505] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1576.182438] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1576.194373] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1603.989266] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1604.417697] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1605.378715] ------------[ cut here ]------------
[ 1605.383480] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1605.399777] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1605.472126] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1605.479361] Hardware name: BCM5301X
[ 1605.482852] Backtrace: 
[ 1605.485328] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1605.492913]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1605.498631] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1605.505871] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1605.513977]  r5:00000009 r4:00000000
[ 1605.517574] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1605.526371]  r8:c7330148 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1605.533157] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1605.543634] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1605.556260]  r8:c7330148 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330438
[ 1605.563030] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1605.575226]  r7:00000000 r6:c72e7c80 r5:c7330148 r4:00000004
[ 1605.580969] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1605.591686]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1605.599571]  r4:bf1ad460
[ 1605.602143] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1605.611122]  r8:c6afa180 r7:c69d5814 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1605.617882] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1605.625727]  r10:c6afa180 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c6afa180
[ 1605.633613]  r4:c69d5800
[ 1605.636160] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1605.643657]  r7:c6484800 r6:c6afa180 r5:c6afa180 r4:c04a42a0
[ 1605.649364] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1605.657035]  r5:00000048 r4:c7962800
[ 1605.660635] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1605.668916]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1605.676722] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1605.684566]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1605.692452]  r4:c6b3ff4c
[ 1605.694997] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1605.702927] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1605.710773]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1605.718659]  r4:c754e780
[ 1605.721207] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1605.728791]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1605.733446] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1605.741233] ---[ end trace 71b7d8e23b95aa22 ]---
[ 1605.745866] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1605.756941] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1605.764359] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1606.189223] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1606.200191] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1606.211905] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1606.223982] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1634.009180] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1634.732603] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1635.698687] ------------[ cut here ]------------
[ 1635.703450] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1635.719740] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1635.792123] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1635.799358] Hardware name: BCM5301X
[ 1635.802849] Backtrace: 
[ 1635.805325] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1635.812911]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1635.818627] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1635.825866] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1635.833973]  r5:00000009 r4:00000000
[ 1635.837571] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1635.846367]  r8:c73300a4 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1635.853154] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1635.863629] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1635.876258]  r8:c73300a4 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330394
[ 1635.883028] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1635.895223]  r7:00000000 r6:c72e7c80 r5:c73300a4 r4:00000004
[ 1635.900965] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1635.911683]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1635.919569]  r4:bf1ad460
[ 1635.922140] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1635.931118]  r8:c6af36c0 r7:c69d4a14 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1635.937879] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1635.945723]  r10:c6af36c0 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c6af36c0
[ 1635.953610]  r4:c69d4a00
[ 1635.956156] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1635.963653]  r7:c6484800 r6:c6af36c0 r5:c6af36c0 r4:c04a42a0
[ 1635.969360] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1635.977032]  r5:00000048 r4:c7962800
[ 1635.980631] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1635.988913]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1635.996718] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1636.004563]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1636.012448]  r4:c6b3ff4c
[ 1636.014993] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1636.022924] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1636.030771]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1636.038656]  r4:c754e780
[ 1636.041203] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1636.048787]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1636.053443] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1636.061222] ---[ end trace 71b7d8e23b95aa23 ]---
[ 1636.065853] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[ 1636.076936] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[ 1636.084354] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c70ddc00 skb->dev:  (null) skb->dev->name:---
[ 1636.219186] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c70fd480 brcmf_ifname(ifp):wlan0
[ 1636.230663] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c6565480 brcmf_ifname(ifp):wlan1-2
[ 1636.242384] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c64aac80 brcmf_ifname(ifp):wlan0-1
[ 1636.254391] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c646f480 brcmf_ifname(ifp):wlan0-2
[ 1664.029287] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c73b1c80 brcmf_ifname(ifp):wlan1
[ 1664.424048] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c72e7c80 brcmf_ifname(ifp):wlan1-1
[ 1665.388689] ------------[ cut here ]------------
[ 1665.393450] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1247 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
[ 1665.409727] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[ 1665.482098] CPU: 1 PID: 1140 Comm: hostapd Tainted: G        W       4.4.19 #0
[ 1665.489333] Hardware name: BCM5301X
[ 1665.492824] Backtrace: 
[ 1665.495300] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[ 1665.502886]  r7:000004df r6:bf1d107b r5:60000013 r4:00000000
[ 1665.508602] [<c0017270>] (show_stack) from [<c017c210>] (dump_stack+0x84/0xa4)
[ 1665.515842] [<c017c18c>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[ 1665.523949]  r5:00000009 r4:00000000
[ 1665.527546] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[ 1665.536343]  r8:c7330148 r7:00000001 r6:c6b3fb3c r5:00000000 r4:c72e7c80
[ 1665.543128] [<c002153c>] (warn_slowpath_null) from [<bf1be634>] (brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac])
[ 1665.553604] [<bf1be578>] (brcmf_netdev_wait_pend8021x [brcmfmac]) from [<bf1ab200>] (brcmf_cfg80211_sched_scan_start+0x460/0x6c0 [brcmfmac])
[ 1665.566233]  r8:c7330148 r7:bf1c87d7 r6:c72e7c80 r5:c04903c8 r4:c7330438
[ 1665.573003] [<bf1ab13c>] (brcmf_cfg80211_sched_scan_start [brcmfmac]) from [<bf1ad740>] (brcmf_cfg80211_add_key+0x2e0/0x3dc [brcmfmac])
[ 1665.585199]  r7:00000000 r6:c72e7c80 r5:c7330148 r4:00000004
[ 1665.590940] [<bf1ad460>] (brcmf_cfg80211_add_key [brcmfmac]) from [<bf160b48>] (nl80211_new_key+0xfc/0x128 [cfg80211])
[ 1665.601658]  r10:00000014 r9:c7961800 r8:c6b3fca0 r7:c71d6000 r6:c72e7800 r5:00000000
[ 1665.609544]  r4:bf1ad460
[ 1665.612113] [<bf160a4c>] (nl80211_new_key [cfg80211]) from [<c0286f40>] (genl_rcv_msg+0x260/0x2e4)
[ 1665.621084]  r8:c73ecb40 r7:c6477c14 r6:bf170540 r5:bf1787d0 r4:00000000
[ 1665.627845] [<c0286ce0>] (genl_rcv_msg) from [<c0286260>] (netlink_rcv_skb+0x60/0xbc)
[ 1665.635690]  r10:c73ecb40 r9:00000000 r8:c6b3fd84 r7:c6484800 r6:c0286ce0 r5:c73ecb40
[ 1665.643576]  r4:c6477c00
[ 1665.646123] [<c0286200>] (netlink_rcv_skb) from [<c0286ccc>] (genl_rcv+0x28/0x3c)
[ 1665.653621]  r7:c6484800 r6:c73ecb40 r5:c73ecb40 r4:c04a42a0
[ 1665.659326] [<c0286ca4>] (genl_rcv) from [<c0285c48>] (netlink_unicast+0x138/0x1f4)
[ 1665.666998]  r5:00000048 r4:c7962800
[ 1665.670598] [<c0285b10>] (netlink_unicast) from [<c02860c8>] (netlink_sendmsg+0x300/0x320)
[ 1665.678879]  r9:00000008 r8:00000000 r7:00000048 r6:c6b3ff4c r5:c6484800 r4:00000000
[ 1665.686686] [<c0285dc8>] (netlink_sendmsg) from [<c0248de4>] (sock_sendmsg+0x1c/0x2c)
[ 1665.694528]  r10:00000000 r9:00000000 r8:00000000 r7:c754e780 r6:c6b3fe64 r5:00000000
[ 1665.702415]  r4:c6b3ff4c
[ 1665.704960] [<c0248dc8>] (sock_sendmsg) from [<c0249398>] (___sys_sendmsg+0x198/0x228)
[ 1665.712890] [<c0249200>] (___sys_sendmsg) from [<c024a1ec>] (__sys_sendmsg+0x44/0x68)
[ 1665.720736]  r10:00000000 r9:c6b3e000 r8:c00098c4 r7:00000128 r6:00000000 r5:beacd930
[ 1665.728623]  r4:c754e780
[ 1665.731169] [<c024a1a8>] (__sys_sendmsg) from [<c024a220>] (SyS_sendmsg+0x10/0x14)
[ 1665.738755]  r6:b6f7b1c8 r5:00000000 r4:00000000
[ 1665.743408] [<c024a210>] (SyS_sendmsg) from [<c0009700>] (ret_fast_syscall+0x0/0x3c)
[ 1665.751187] ---[ end trace 71b7d8e23b95aa24 ]---
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 94 +++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    | 17 +++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |  2 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         | 30 ++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 21 +++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 +
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |  2 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |  2 +-
 9 files changed, 167 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 201a980..c7ccea5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -464,11 +464,12 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
+__send_key_to_dongle(const char *c0, struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
+	pr_info("[%s -> %s] ifp:%p brcmf_ifname(ifp):%s\n", c0, __func__, ifp, brcmf_ifname(ifp));
 	convert_key_from_CPU(key, &key_le);
 
 	brcmf_netdev_wait_pend8021x(ifp);
@@ -480,6 +481,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 		brcmf_err("wsec_key error (%d)\n", err);
 	return err;
 }
+#define send_key_to_dongle(ifp, key)	__send_key_to_dongle(__func__, ifp, key)
 
 static s32
 brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f02..67f2623 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,6 +38,46 @@
 #include "pcie.h"
 #include "common.h"
 
+#include <linux/sched.h>
+
+static size_t print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	rem_nsec = do_div(ts, 1000000000);
+
+	if (!buf)
+		return snprintf(NULL, 0, "[%5lu.000000]", (unsigned long)ts);
+
+	return sprintf(buf, "[%5lu.%06lu]",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+/* Free the driver packet. Free the tag if present */
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	if (ifp) {
+		struct pend_skb *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == skb) {
+				pr_info("[%s -> %s] [ifp:%p] ***BUG*** skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+				break;
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	} else if (strcmp(c0, "brcmf_msgbuf_query_dcmd")) {
+		pr_info("[%s -> %s] [ifp:%p] Freeing skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, skb, skb->dev, skb->dev ? skb->dev->name : "---");
+	}
+
+	WARN_ON(skb->next);
+	dev_kfree_skb_any(skb);
+}
+
 #define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
 
 #define BRCMF_BSSIDX_INVALID			-1
@@ -247,8 +287,18 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
+		struct pend_skb *e;
+
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		e->skb = skb;
+		e->start_time = local_clock();
+
 		atomic_inc(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_add_tail(&e->list, &ifp->pend_8021x_skbs);
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
@@ -333,7 +383,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+		__brcmu_pkt_buf_free_skb(__func__, *ifp, skb);
 		return -ENODATA;
 	}
 
@@ -378,7 +428,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
 	struct ethhdr *eh;
 	u16 type;
@@ -387,7 +437,30 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
+		struct pend_skb *e, *tmp;
+
 		atomic_dec(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry_safe(e, tmp, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == txp) {
+				if (e->timedout) {
+					char start[32], commit[32];
+
+					print_time(e->start_time, start);
+					print_time(e->commit_time, commit);
+
+					pr_info("[%s -> %s] Finally finalizing skb:%p skb->dev:%p skb->dev->name:%s (start_time:%s; commit_time:%s)\n",
+						c0, __func__,
+						e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---",
+						start, commit);
+				}
+
+				list_del(&e->list);
+				kfree(e);
+				break;
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -476,6 +549,8 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 
 	atomic_set(&ifp->pend_8021x_cnt, 0);
+	INIT_LIST_HEAD(&ifp->pend_8021x_skbs);
+	mutex_init(&ifp->pend_8021x_mutex);
 
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
@@ -1170,6 +1245,19 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	WARN_ON(!err);
+	if (!err)
+		pr_info("[%s] ifp:%p brcmf_ifname(ifp):%s brcmf_get_pend_8021x_cnt(ifp):%d\n", __func__, ifp, brcmf_ifname(ifp), brcmf_get_pend_8021x_cnt(ifp));
+	if (!list_empty(&ifp->pend_8021x_skbs)) {
+		struct pend_skb *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		pr_info("[%s] List of pending 802.1x skbs:\n", __func__);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			e->timedout = true;
+			pr_info("[%s] skb:%p skb->dev:%p skb->dev->name:%s\n", __func__, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8fa34ca..0f66e8f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -50,6 +50,9 @@
 
 #define NDOL_MAX_ENTRIES	8
 
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb);
+#define brcmu_pkt_buf_free_skb(skb)	__brcmu_pkt_buf_free_skb(__func__, ifp, skb)
+
 /**
  * struct brcmf_ampdu_rx_reorder - AMPDU receive reorder info
  *
@@ -169,6 +172,14 @@ enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
+struct pend_skb {
+	struct sk_buff *skb;
+	u64 start_time;
+	u64 commit_time;
+	bool timedout;
+	struct list_head list;
+};
+
 /**
  * struct brcmf_if - interface control information.
  *
@@ -203,6 +214,9 @@ struct brcmf_if {
 	u8 netif_stop;
 	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
+	struct list_head pend_8021x_skbs;
+	struct mutex pend_8021x_mutex;
+	bool pend_8021x_ready;
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
@@ -219,7 +233,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+#define brcmf_txfinalize(ifp, txp, success)	__brcmf_txfinalize(__func__, ifp, txp, success)
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 7e269f9..87c8de0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -249,6 +249,8 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 
 	skb = skb_dequeue(&ring->skblist);
 	while (skb) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmu_pkt_buf_free_skb(skb);
 		skb = skb_dequeue(&ring->skblist);
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 9f9024a..7a17afd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -38,6 +38,8 @@
 #include "proto.h"
 #include "common.h"
 
+#include <linux/sched.h>
+
 /**
  * DOC: Firmware Signalling
  *
@@ -590,6 +592,8 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 	for (prec = 0; prec < q->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
 			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		}
@@ -697,6 +701,8 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 		    s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
 			skb = h->items[i].pkt;
 			if (fn == NULL || fn(skb, &ifidx)) {
+				struct brcmf_if *ifp = NULL;
+
 				/* suppress packets freed from psq */
 				if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE)
 					brcmu_pkt_buf_free_skb(skb);
@@ -845,6 +851,8 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	for (prec = 0; prec < txq->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 			hi = &fws->hanger.items[hslot];
 			WARN_ON(skb != hi->pkt);
@@ -971,8 +979,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		brcmf_fws_unlock(fws);
 		err = brcmf_proto_txdata(fws->drvr, ifidx, data_offset, skb);
 		brcmf_fws_lock(fws);
-		if (err)
+		if (err) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
+		}
 		return true;
 	}
 	return false;
@@ -2056,6 +2067,22 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
+	{
+		struct brcmf_if *ifp = brcmf_get_ifp(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX));
+
+		if (ifp) {
+			struct pend_skb *e;
+
+			mutex_lock(&ifp->pend_8021x_mutex);
+			list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+				if (e->skb == skb) {
+					e->commit_time = local_clock();
+					break;
+				}
+			}
+			mutex_unlock(&ifp->pend_8021x_mutex);
+		}
+	}
 
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
@@ -2454,6 +2481,7 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
+	struct brcmf_if *ifp = NULL;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 2b9a2bc..6ff91c2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -34,6 +34,8 @@
 #include "bus.h"
 #include "tracepoint.h"
 
+#include <linux/sched.h>
+
 
 #define MSGBUF_IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
@@ -392,6 +394,8 @@ brcmf_msgbuf_release_array(struct device *dev,
 	count = 0;
 	do {
 		if (array[count].allocated.counter) {
+			struct brcmf_if *ifp = NULL;
+
 			pktid = &array[count];
 			dma_unmap_single(dev, pktid->physaddr,
 					 pktid->skb->len - pktid->data_offset,
@@ -483,6 +487,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
+	struct brcmf_if *ifp = NULL;
 	int timeout;
 	int err;
 
@@ -747,6 +752,22 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 			brcmf_commonring_write_complete(commonring);
 			count = 0;
 		}
+		{
+			struct brcmf_if *ifp = brcmf_get_ifp(msgbuf->drvr, tx_msghdr->msg.ifidx);
+
+			if (ifp) {
+				struct pend_skb *e;
+
+				mutex_lock(&ifp->pend_8021x_mutex);
+				list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+					if (e->skb == skb) {
+						e->commit_time = local_clock();
+						break;
+					}
+				}
+				mutex_unlock(&ifp->pend_8021x_mutex);
+			}
+		}
 	}
 	if (count)
 		brcmf_commonring_write_complete(commonring);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 2f978a3..edbe353 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -498,6 +498,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 {
 	struct brcmf_usbreq  *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
+	struct brcmf_if *ifp = NULL;
 	struct sk_buff *skb;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
@@ -548,6 +549,8 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
index 0543607..bf525b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
@@ -49,7 +49,7 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 	WARN_ON(skb->next);
 	dev_kfree_skb_any(skb);
 }
-EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
+//EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
 /*
  * osl multiple-precedence packet queue
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
index 4196952..7bd705d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
@@ -126,7 +126,7 @@ struct sk_buff *brcmu_pktq_pdeq_match(struct pktq *pq, int prec,
 
 /* packet primitives */
 struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
-void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
+//void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
 /* callback function fn(pkt, arg) returns true if pkt belongs to if */
-- 
2.9.3
