Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34652 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753620AbdBRTZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Feb 2017 14:25:43 -0500
Received: by mail-wm0-f49.google.com with SMTP id 196so15347587wmm.1
        for <linux-wireless@vger.kernel.org>; Sat, 18 Feb 2017 11:25:42 -0800 (PST)
Subject: Re: brcmfmac: BCM4343A0 P2P mode problem
To: Stefan Holzmann <stefan.holzmann@gmx.net>
References: <trinity-8050cb18-f2b8-4b78-a32c-96b49de20725-1487367187777@3capp-gmx-bs71>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Message-ID: <b0f8b5ce-3728-cd85-6dc4-fd49e6b140aa@broadcom.com> (sfid-20170218_202546_903098_6CF9023D)
Date: Sat, 18 Feb 2017 20:25:39 +0100
MIME-Version: 1.0
In-Reply-To: <trinity-8050cb18-f2b8-4b78-a32c-96b49de20725-1487367187777@3capp-gmx-bs71>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 17-2-2017 22:33, Stefan Holzmann wrote:
> Hello,
> 
> I have problems to get WiFi P2P on a Nanopi NEO Air board up and running. The board uses a AP6212 WiFi module with the BCM4343A0 SDIO chipset (ID: 0xa9a6).

Hi Stefan

FYI, SDIO ID: A9A6 is BCM43430.

> Connecting to an AP as normal WiFi client is working without problems.
> 
> I can also discover other WiFi P2P nodes using wpa_cli p2p_peers, but when I try to connect using wpa_cli p2p_connect the connection attempt fails with the following log.
> 
> Are there any known problems with this kernel/wpa_supplicant combination for this chipset? Why the interface type can't be changed to P2P_CLIENT? I also tried to use the "p2pon" driver option but when I try to start wpa_supplicant on the P2P interface I get an kernel crash.

You may need to start wpa_supplicant with '-puse_p2p_group_interface=1'.

The use of p2pon parameter is not recommended on recent kernel and 2.x
wpa_supplicant. It requires specific wpa_supplicant command line.

Regards,
Arend

> Kernel Log:
> 
> [  222.972232] brcmfmac: brcmf_cfg80211_escan_handler: scan not ready, bsscfgidx=1
> [  222.979577] brcmfmac: brcmf_fweh_event_worker: event handler failed (69) 
> 
> [  237.677557] brcmfmac: brcmf_cfg80211_change_iface Enter, bsscfgidx=0, type=8
> [  237.677569] brcmfmac: brcmf_cfg80211_change_iface Exit
> [  237.677641] brcmfmac: brcmf_netdev_open Enter, bsscfgidx=0
> [  237.677648] brcmfmac: brcmf_sdio_bus_txctl Enter
> [  237.677664] brcmfmac: brcmf_sdio_dpc Enter
> [  237.677674] brcmfmac: brcmf_sdio_tx_ctrlframe Enter
> [  237.677716] brcmfmac: brcmf_sdio_bus_rxctl Enter
> [  237.678232] brcmfmac: brcmf_sdio_isr Enter
> [  237.678244] brcmfmac: brcmf_sdio_dpc Enter
> [  237.678288] brcmfmac: brcmf_sdio_readframes Enter
> [  237.678315] brcmfmac: brcmf_sdio_read_control Enter
> [  237.678359] brcmfmac: brcmf_sdio_bus_rxctl resumed on rxctl frame, got 27 expected 27
> [  237.678365] brcmfmac: brcmf_fil_cmd_data Failed: BCME_UNSUPPORTED (-23)
> [  237.678370] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=toe_ol, len=4
> [  237.678372] brcmutil: data
> [  237.678380] 00000000: 84 85 13 c0
>  
> 
> wpa_supplicant Log:
> nl80211: Set mode ifindex 2 iftype 8 (P2P_CLIENT)
> nl80211: Failed to set interface 2 to mode 8: -22 (Invalid argument)
> nl80211: Try mode change after setting interface down
> nl80211: Set mode ifindex 2 iftype 8 (P2P_CLIENT)
> nl80211: Failed to set interface 2 to mode 8: -22 (Invalid argument)
> nl80211: Interface mode change to 8 from 2 failed
>  
> 
> Kernel: 4.10.0-rc5
> wpa_supplicant: v2.6
> WiFI Firmware version = wl0: Jun  6 2014 14:50:39 version 7.10.226.49 (r) FWID 01-8962686a
>  
> 
> Best Regards,
> Stefan Holzmann
> 
