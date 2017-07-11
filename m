Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33177 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752533AbdGKMfM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 08:35:12 -0400
Received: by mail-qk0-f178.google.com with SMTP id v143so102107603qkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jul 2017 05:35:12 -0700 (PDT)
Subject: Re: [BUG] brcmfmac: BRCM4354 cannot connect since commit 270a6c1f65
To: "S. Gilles" <sgilles@math.umd.edu>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20170711122125.5epcjhcyneiwxyse@number18.npnth.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d5775426-f1bd-c2ce-89a8-e11472815787@broadcom.com> (sfid-20170711_143516_700136_DCAA4E77)
Date: Tue, 11 Jul 2017 14:35:07 +0200
MIME-Version: 1.0
In-Reply-To: <20170711122125.5epcjhcyneiwxyse@number18.npnth.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-07-17 14:21, S. Gilles wrote:
> Hi,
> 
> I have an Asus C201, which comes with a BRCM4354 (SDIO). On boot,
> dmesg shows
> 
>     brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Apr  8 2015 13:03:52 version 7.35.79.79 (r547158) FWID 01-7f29997a
> 
> Since 270a6c1f65fe68a28a5d39cd405592c550b496c7 (brcmfmac: rework
> headroom check in .start_xmit()), the machine cannot connect to any
> wireless network. I can fully reproduce this, and have bisected it;
> I'm mailing this from the commit before: a833f3d4de. I only have
> access to WPA2 networks, in case it matters. The relevent part of
> dmesg from a bad boot is
> 
>     [    ...    ] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>     [  +0.000767] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [  +0.905426] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:02] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [  +0.983406] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:03] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:05] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [  +0.981930] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:07] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:09] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [  +0.698295] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     ... (etc.)
>     [  +0.918891] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     [Jul11 11:18] dwmmc_rockchip ff0d0000.dwmmc: Successfully tuned phase to 204
>     [ +12.545604] brcmfmac: brcmf_proto_bcdc_hdrpull: wlan0: non-BCDC packet received, flags 0x0
>     ... (etc.)
> 
> meanwhile, wpa_cli is full of output like
> 
>     ...
>     <3>CTRL-EVENT-NETWORK-NOT-FOUND
>     <3>CTRL-EVENT-SCAN-STARTED
>     <3>CTRL-EVENT-SCAN-RESULTS
>     <3>CTRL-EVENT-SSID-REENABLED id=1 ssid="{known SSID}"
>     <3>Trying to associate with SSID '{known SSID}'
>     <3>Associated with {MAC}
>     <3>CTRL-EVENT-SUBNET-STATUS-UPDATE status=0
>     <3>Authentication with {MAC} timed out.
>     <3>CTRL-EVENT-DISCONNECTED bssid={MAC} reason=3 locally_generated=1
>     <3>WPA: 4-Way Handshake failed - pre-shared key may be incorrect
>     <3>CTRL-EVENT-SID-TEMP-DISABLED id=1 ssid="{known SSID}" auth_failures=26 duration=120 reason=WRONG_KEY
>     <3>CTRL-EVENT-REGDOM-CHANGE init=CORE type=WORLD
>     <3>CTRL-EVENT-SCAN-STARTED
>     <3>CTRL-EVENT-SCAN-RESULTS
>     <4>Failed to initiate sched scan
>     <3>CTRL-EVENT-NETWORK-NOT-FOUND
>     ... 
> 
> The `non-BCDC packet received' messages in dmesg occur just before
> the `timed out' messages in wpa_cli.
> 
> Please let me know if more information is needed of if there are
> patches I should test.

Looking at the diff of the bad commit, I came up with the patch below.
Can you try it and let me know the result?

Regards,
Arend
---
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index fbcbb43..c3ecec6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2053,12 +2053,13 @@ static int brcmf_sdio_txpkt_hdalign(struct
brcmf_sdio *bus, struct sk_buff *pkt)
                                atomic_inc(&stats->pktcow_failed);
                                return -ENOMEM;
                        }
+                       head_pad = 0;
                }
                skb_push(pkt, head_pad);
                dat_buf = (u8 *)(pkt->data);
        }
        memset(dat_buf, 0, head_pad + bus->tx_hdrlen);
-       return 0;
+       return head_pad;
 }

 /**
