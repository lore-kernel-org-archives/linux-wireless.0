Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDF6C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 20:14:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462322081C
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 20:14:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 462322081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbeK2HQx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 02:16:53 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58719 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeK2HQx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 02:16:53 -0500
Received: from oxbaltgw03.schlund.de ([172.19.246.9]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M4Je5-1gSNCX2elF-000MGM; Wed, 28 Nov 2018 21:13:56 +0100
Date:   Wed, 28 Nov 2018 21:13:56 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Message-ID: <638991280.323977.1543436036313@email.ionos.de>
In-Reply-To: <1820979779.200101.1543256045155@email.ionos.de>
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
 <355192050.233466.1543151650720@email.ionos.de>
 <978d5d47-004e-21a9-0c53-2eb1571a5138@broadcom.com>
 <1820979779.200101.1543256045155@email.ionos.de>
Subject: Re: brcmfmac: regression using AP mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev46
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:Xb3XIS43iQR8Woux02PbYX3raxJY3Y5/l6htPaEKo4WQMfNyyGt
 BE4mn1J6vbBAMOVjH63TU/yBs46PeQXlOCfiq4jnmNIajz7wQwFQBsaD7RIPEJo9FpDg/uV
 DI32Sz15paHwQL8OXz+qzM+sGaHZSEgrQaThu6rHeqtj32CuPAcS/e6WKiYKJC0MshlzCBB
 8VidaDHSZgXPGFV7ibCxQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yBYzP+lFOU8=:1uqNHDujuzNZviRrjYxJWH
 tXlBhbLuvG43ZdLkARMj7F1v7yyYZKHFUZfKeL7ojrK5KPtQuNp4SYJJjCtfvk/xhSH9dWk2u
 v4imrCjvg0vwUIA3/Tw3tSoJ1MA8/pL/fWaAu+sYA32+ZMhyKSLMbOiXqP4xXTHmq0rAP2Czs
 Mthx2f3bQF3X7toqz08/1rBZ12cp3+8WdoB+u2to0I1gr1/IeRFmdsjnFgxcg1JyHZTP0+VfN
 A67kMGR+0caIQaxD9f32AfSdpv6+sAlEq6/PMz5Z5l23VwgEtV0vac/joEDhqQT0AI7+SbytC
 GfUzOd/SRQnNZkQ+nSbPS14YuDo40MVab+QcBPCNRve1jwbplgKP6vpT7wplqR6Hg1nXl2ByF
 oLYtDhDT8UAgT0/ASZ5jDjO/ct0/zya87saWtu3PlyIhGEopnTj9fTxykTMK9rni0nKSsurse
 ZfS06zBgk7PvN9pz2nu8i46xd9c4AnXQFPolgaFRnlAP+7/fLmqfGouScSFV4gZNQ+u5g9zaH
 En95QsUi03kLQ69x/IOE3una885dLYq9a3E/OrsEJNk9bHDi2ZkNK0G9OL1cPixbdACvKrxNm
 NrVVlza13xCBL53qTlIVgfTUMSr73QloSSyDkMOpzPa0Smd9BsxFSYTjG9BsSDRH+/8c3FjtD
 WcWr4qqvC/D7P9gt7fceSdfOsFLZ0pumKllf5aoQCXxyJ/57JrQbPvHchr5osDVd/NpT2KxfK
 pzFvrpuJQRYvwLM/t2aO/zJYtg60/LEiWqr7Tm1D5m+iqta03pbcHwg96L0=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Stefan Wahren <stefan.wahren@i2se.com> hat am 26. November 2018 um 19:14 geschrieben:
> 
> 
> Hi Arend,
> 
> > Arend van Spriel <arend.vanspriel@broadcom.com> hat am 26. November 2018 um 11:11 geschrieben:
> > 
> > So no AP listed here. I suspect Rafał was focusing on "device_ap_sme=1 
> > use_monitor=1" scenario. You can try adding AP entry with similar rx 
> > bits as P2P_GO above.
> 
> thanks this make all driver errors like "setting AP mode failed -52" disappear, but now hostapd 2.6 seems to stuck in a loop during establishing the link:
> 

i increased the debug level of brcmfmac to 0x5 and i'm getting this while booting:

[    5.288806] brcmfmac: F1 signature read @0x18000000=0x15264345
[    5.289167] brcmfmac: brcmf_chip_recognition found AXI chip: BCM4345/6
[    5.293319] brcmfmac: brcmf_chip_cores_check  [1 ] core 0x800:51 base 0x18000000 wrap 0x18100000
[    5.293333] brcmfmac: brcmf_chip_cores_check  [2 ] core 0x812:54 base 0x18001000 wrap 0x18101000
[    5.293344] brcmfmac: brcmf_chip_cores_check  [3 ] core 0x83e:9  base 0x18002000 wrap 0x18102000
[    5.293353] brcmfmac: brcmf_chip_cores_check  [4 ] core 0x83c:14 base 0x18003000 wrap 0x18103000
[    5.293362] brcmfmac: brcmf_chip_cores_check  [5 ] core 0x829:21 base 0x18004000 wrap 0x18104000
[    5.293371] brcmfmac: brcmf_chip_cores_check  [6 ] core 0x135:0  base 0x00000000 wrap 0x18107000
[    5.293379] brcmfmac: brcmf_chip_cores_check  [7 ] core 0x240:0  base 0x00000000 wrap 0x00000000
[    5.295574] brcmfmac: brcmf_chip_get_raminfo RAM: base=0x198000 size=819200 (0xc8000) sr=0 (0x0)
[    5.295686] brcmfmac: brcmf_chip_setup ccrev=51, pmurev=27, pmucaps=0x39d05f1b
[    5.295698] brcmfmac: brcmf_get_module_param Enter, bus=0, chip=17221, rev=6
[    5.295765] brcmfmac: brcmf_sdio_drivestrengthinit No SDIO driver strength init needed for chip BCM4345/6 rev 6 pmurev 27
[    5.296204] brcmfmac: brcmf_sdio_probe completed!!
[    5.296219] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[    5.413840] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0x00198000; size=600487
[    5.442090] random: crng init done
[    5.442105] random: 7 urandom warning(s) missed due to ratelimiting
[    5.539438] brcmfmac: brcmf_sdio_verifymemory Compare RAM dl & ul at 0x0025f940; size=1728
[    5.636378] brcmfmac: brcmf_sdio_firmware_callback enable F2: err=0
[    5.636577] brcmfmac: brcmf_bus_change_state ignoring transition, bus not attached yet
[    5.636819] brcmfmac: brcmf_add_if allocate netdev interface
[    5.637199] brcmfmac: brcmf_sdio_readshared sdpcm_shared address 0x001FF350
[    5.638014] brcmfmac: brcmf_sdio_readshared sdpcm_shared address 0x001FF350
[    5.641788] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[    5.665557] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: Feb 27 2018 03:15:32 version 7.45.154 (r684107 CY) FWID 01-4fbe0b04
[    5.666203] brcmfmac: brcmf_c_preinit_dcmds CLM version = API: 12.2 Data: 9.10.105 Compiler: 1.29.4 ClmImport: 1.36.3 Creation: 2018-03-09 18:56:28 
[    5.673860] brcmfmac: brcmf_feat_firmware_capabilities [ ap sta wme 802.11d 802.11h rm cqa cac dualband ampdu ampdu_tx ampdu_rx amsdurx tdls radio_pwrsave btamp p2p proptxstatus mchan p2po anqpo vht-prop-rates dfrts txpwrcache stbc-tx stbc-rx-1ss epno pfnx wnm bsstrans mfp ]
[    5.673890] brcmfmac: brcmf_feat_firmware_capabilities enabling feature: MCHAN
[    5.673899] brcmfmac: brcmf_feat_firmware_capabilities enabling feature: P2P
[    5.674522] brcmfmac: brcmf_feat_iovar_int_get enabling feature: PNO
[    5.675854] brcmfmac: brcmf_feat_iovar_int_get enabling feature: TDLS
[    5.676955] brcmfmac: brcmf_feat_iovar_int_get enabling feature: MFP
[    5.678014] brcmfmac: brcmf_feat_iovar_int_get enabling feature: FWSUP
[    5.678066] brcmfmac: brcmf_fws_attach FWS queueing will be avoided
[    5.678920] brcmfmac: brcmf_cfg80211_attach Registering custom regulatory
[    5.681508] brcmfmac: brcmf_setup_wiphybands nmode=1, vhtmode=1, bw_cap=(1, 7)
[    5.684720] brcmfmac: brcmf_setup_wiphybands nchain=1
[    5.721118] brcmfmac: check_vif_up device is not ready : status (0)
[    5.721190] brcmfmac: brcmf_net_attach wlan0: Broadcom Dongle Host Driver
[    5.844422] Bluetooth: hci0: BCM4345C0 (003.001.025) build 0252
[   10.845747] brcmfmac: check_vif_up device is not ready : status (0)
[   11.612740] brcmfmac: check_vif_up device is not ready : status (0)
[   11.613251] brcmfmac: check_vif_up device is not ready : status (0)
[   11.614724] brcmfmac: check_vif_up device is not ready : status (0)
[   11.616385] brcmfmac: check_vif_up device is not ready : status (0)
[   11.637118] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
[   11.638643] brcmfmac: brcmf_config_dongle power save set to enabled
[   11.639137] brcmfmac: brcmf_dongle_roam Internal Roaming = On
[   11.640504] brcmfmac: brcmf_cfg80211_change_iface IF Type = Infra
[   11.642531] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   11.642545] brcmfmac: brcmf_cfg80211_set_power_mgmt power save enabled
[   11.767278] brcmfmac: brcmf_p2p_add_vif adding vif "p2p-dev-wlan0" (type=10)
[   11.789469] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
[   11.791667] brcmfmac: brcmf_add_if allocate non-netdev interface
[   11.792237] brcmfmac: check_vif_up device is not ready : status (0)
[   11.792260] brcmfmac: check_vif_up device is not ready : status (0)
[   11.912572] brcmfmac: check_vif_up device is not ready : status (0)
[   11.913704] brcmfmac: check_vif_up device is not ready : status (0)
[   11.913881] brcmfmac: check_vif_up device is not ready : status (0)
[   11.914027] brcmfmac: check_vif_up device is not ready : status (0)
[   11.915150] brcmfmac: check_vif_up device is not ready : status (0)
[   11.915230] brcmfmac: check_vif_up device is not ready : status (0)
[   14.706985] brcmfmac: brcmf_cfg80211_connect ie (29d9d630), ie_len (28)
[   17.638253] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   19.655039] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   21.780277] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   24.744917] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   24.995983] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   25.246750] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   25.446303] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   26.569338] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[   28.692076] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)

and this after starting hostapd 2.6:

[  207.921068] brcmfmac: brcmf_btcoex_set_mode DHCP session ends
[  207.921352] brcmfmac: brcmf_cfg80211_change_iface IF Type = AP
[  209.114209] brcmfmac: brcmf_set_mpc MPC : 0
[  209.143594] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
[  211.049412] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  213.051521] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  218.084704] brcmfmac: brcmf_escan_timeout: timer expired
[  218.531282] brcmfmac: brcmf_add_if netdev:wlan0 ignore IF event
[  218.531776] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[  218.532228] brcmfmac: brcmf_set_mpc MPC : 1
[  218.533962] brcmfmac: brcmf_cfg80211_change_iface IF Type = Infra
[  218.537955] brcmfmac: brcmf_cfg80211_connect ie (537583ca), ie_len (28)
[  223.410796] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  225.526035] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  227.705830] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  227.956466] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  228.207019] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  228.407567] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  229.521312] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
[  231.621031] brcmfmac: brcmf_netdev_start_xmit wlan0: insufficient headroom (0)
