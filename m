Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33352 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754563AbeFYIlT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Jun 2018 04:41:19 -0400
Received: by mail-lf0-f49.google.com with SMTP id b7-v6so2902419lfa.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2018 01:41:18 -0700 (PDT)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
Message-ID: <712f36fa-d6b0-4bad-97fc-5aedc492c911@gmail.com> (sfid-20180625_104215_152657_F5735FDA)
Date: Mon, 25 Jun 2018 10:39:08 +0200
MIME-Version: 1.0
In-Reply-To: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15.05.2018 14:29, Rafał Miłecki wrote:
> I was hoping that maybe looking at fw-reported capabilities will give me
> any hint regarding that but I'm afraid I'm out of luck. Below is a list
> of firmwares I tested and summary of each of them.
> 
> Note: as every firmware reports following capabilities:
> 802.11d 802.11h ampdu ampdu_rx ampdu_tx amsdurx amsdutx anqpo ap bcm_dcs
> bsstrans cac cqa dfrts dwds led mfp p2po probresp_mac_filter pspretend
> psr psta radio_pwrsave rm rxchain_pwrsave sta stbc-rx-1ss stbc-tx
> traffic-mgmt traffic-mgmt-dwm vht-prop-rates wds wet wet_tunnel wme wnm
> I omitted them below.

I'm sending an updated (with "cap" and "sta_monitor" info) summary of
firmwares I tested.

*****

1) brcmfmac43602-pcie.ap.bin from linux-firmware.git
43602a1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop Version: 7.35.177.56 CRC: 548eccd4 Date: Fri 2015-09-18 03:31:06 PDT Ucode Ver: 986.122 FWID: 01-6cb8e269
Firmware version = wl0: Sep 18 2015 03:30:01 version 7.35.177.56 (r587209) FWID 01-6cb8e269

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

2) brcmfmac4366b-pcie.bin from linux-firmware.git
4366b1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs Version: 10.10.69.237 CRC: 4bc48c7b Date: Fri 2016-01-08 12:55:25 PST Ucode Ver: 1073.531 FWID: 01-c47a91a4
Firmware version = wl0: Jan  8 2016 12:54:07 version 10.10.69.3309 (r610991) FWID 01-c47a91a4

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

3) 4366b1 development branch (from Arend)
4366b1-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs Version: 10.10 (TOB) (r663589) CRC: 50d4be62 Date: Thu 2016-10-06 10:46:42 BST Ucode Ver: 1128.155 FWID: 01-6c5a1687
Firmware version = wl0: Oct  6 2016 10:17:32 version 10.10 (TOB) (r663589) FWID 01-6c5a1687

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

4) brcmfmac4366c-pcie.bin.k3
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfgtest-seqcmds-phydbg-phydump-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-11nprop-dbgam-dbgams-ringer-dmaindex16-bgdfs-hostpmac Version: 10.10.69.74 CRC: a6268b76 Date: Mon 2016-09-12 16:39:23 CST FWID 01-5c0166fa
Firmware version = wl0: Aug 19 2016 15:22:35 version 10.10.69.74 (r629731 WLTEST) FWID 01-5c0166fa

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

5) brcmfmac4366c-pcie.bin.ea9500
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac Version: 10.10.69.69 CRC: 34d30c8c Date: Tue 2016-08-23 17:31:24 PDT FWID 01-8438621f
Firmware version = wl0: Aug 23 2016 17:19:51 version 10.10.69.69 (r625687) FWID 01-8438621f

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

6) brcmfmac4366c-pcie.bin.ac88u
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac-txpwr Version: 10.10.69.252 CRC: 9fa88ab1 Date: Mon 2016-09-12 13:28:49 CST Ucode Ver: 1073.579 FWID: 01-fed440e1
Firmware version = wl0: Sep 12 2016 13:26:44 version 10.10.69.6908 (r658761) FWID 01-fed440e1

Monitor frames: yes
Monitor frame flags: 0x0001
Radiotap: no

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -23 (BCME_UNSUPPORTED)

*****

7) brcmfmac4366c-pcie.bin.asus-dhd24
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-hostpmac-txpwr-stamon Version: 10.10.69.69017 (r730013) CRC: cf0b5621 Date: Tue 2017-11-07 12:34:00 CST Ucode Ver: 1073.579 FWID: 01-e258597c
Firmware version = wl0: Nov  7 2017 12:23:08 version 10.10.69.69017 (r730013) FWID 01-e258597c

Monitor frames: yes
Monitor frame flags: 0x0002
Radiotap: yes

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -1 (BCME_ERROR)

*****

8) 4366c0 fw from FW_EA9500v2_EA9500S_2.1.1.183171_prod.img
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: c3ff28b5 Date: Wed 2017-08-02 18:58:48 PDT FWID 01-91326ac8
Firmware version = wl0: Aug  2 2017 18:45:13 version 10.10.122.20 (r683106) FWID 01-91326ac8

Monitor frames: yes
Monitor frame flags: 0x0002
Radiotap: yes

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -1 (BCME_ERROR)

*****

9) 4366c0 fw from GT-AC5300_3.0.0.4_382_15984-gf481f58_cferom_ubi_0824.w
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: af9bda7b Date: Thu 2017-08-17 08:21:56 CST FWID 01-bbb1a4c
Firmware version = wl0: Aug 17 2017 08:13:19 version 10.10.122.20 (r683106) FWID 01-bbb1a4c

Monitor frames: yes
Monitor frame flags: 0x0002
Radiotap: yes

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -1 (BCME_ERROR)

*****

10) 4366c0 fw from ArcherC5400X(US)_171023.bin
4366c0-roml/pcie-ag-splitrx-fdap-mbss-mfp-wnm-osen-wl11k-wl11u-txbf-pktctx-amsdutx-ampduretry-chkd2hdma-proptxstatus-11nprop-obss-dbwsw-ringer-dmaindex16-bgdfs-stamon-hostpmac-murx-splitassoc-hostmemucode-dyn160-dhdhdr Version: 10.10.122.20 CRC: fe843f10 Date: Mon 2017-10-23 17:10:00 CST FWID 01-9f0e64f9
Firmware version = wl0: Sep 14 2017 14:10:23 version 10.10.122.20 (r683106) FWID 01-9f0e64f9

Monitor frames: yes
Monitor frame flags: 0x0002
Radiotap: yes

Flag "monitor" in the "cap" iovar: no
FW "sta_monitor" error (DOWN): -4 (BCME_NOTUP)
FW "sta_monitor" error (UP): -1 (BCME_ERROR)
