Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdH3KY0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 06:24:26 -0400
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526105747.16874-1-hdegoede@redhat.com>
 <20170526105747.16874-2-hdegoede@redhat.com> <59846A11.80400@broadcom.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <d59fb4f8-4ba3-bd75-8de4-9b6b04e4dbe0@redhat.com> (sfid-20170830_122515_896395_257DE0E5)
Date: Wed, 30 Aug 2017 12:24:24 +0200
MIME-Version: 1.0
In-Reply-To: <59846A11.80400@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Sorry I was a bit slow to respond to this.

On 04-08-17 14:35, Arend van Spriel wrote:
> On 5/26/2017 12:57 PM, Hans de Goede wrote:
>> The firmware responding with -EBUSY when trying to add an extra virtual-if
>> is a normal thing, do not print an error for this.
> 
> Hi Hans,
> 
> First of all, sorry! This one is long overdue (thanks for the reminder, Kalle). Not sure what the claim is here. I have to check the firmware to see what could make this fail. Thing is that wpa_supplicant will try to create the interface upon startup and it is really required for P2P operations. Now people not using that will probably not care about the failure, but I would like to find out why it is failing. wpa_supplicant will not do a retry upon -EBUSY.
> 
> With which firmware (target string and version) are you seeing this so I know where to dive in.

[root@localhost ~]# dmesg | grep brcm
[   11.252078] brcmutil: loading out-of-tree module taints kernel.
[   11.252159] brcmutil: module verification failed: signature and/or required key missing - tainting kernel
[   11.484195] brcmfmac: brcmf_sdio_probe: Loading firmware brcm/brcmfmac43430a0-sdio.bin for chip 0000a9a6 rev 00000000
[   11.484290] usbcore: registered new interface driver brcmfmac
[   11.616053] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  6 2014 14:50:39 version 7.10.226.49 (r) FWID 01-8962686a
[   14.782464] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
[   14.782488] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-16
[   34.300531] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
[   34.300549] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-16

[root@localhost ~]# strings /lib/firmware/brcm/brcmfmac43430a0-sdio.bin | tail -n 1
43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-lpc-wl11u-rcc-fmc-wepso-ccx-okc-fbt-noccxaka-txpwr-ampduhostreorder-clm_43xx_lg Version: 7.10.226.49 CRC: bf92cb0b Date: Fri 2014-06-06 14:55:15 KST FWID 01-8962686a

Regards,

Hans
