Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751357AbdH3KaV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 06:30:21 -0400
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526105747.16874-1-hdegoede@redhat.com>
 <20170526105747.16874-2-hdegoede@redhat.com> <59846A11.80400@broadcom.com>
 <d59fb4f8-4ba3-bd75-8de4-9b6b04e4dbe0@redhat.com>
Message-ID: <90b34169-a2cd-6fbf-89e4-9b23e64f12c7@redhat.com> (sfid-20170830_123025_979672_7720D021)
Date: Wed, 30 Aug 2017 12:30:19 +0200
MIME-Version: 1.0
In-Reply-To: <d59fb4f8-4ba3-bd75-8de4-9b6b04e4dbe0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 30-08-17 12:24, Hans de Goede wrote:
> Hi Arend,
> 
> Sorry I was a bit slow to respond to this.
> 
> On 04-08-17 14:35, Arend van Spriel wrote:
>> On 5/26/2017 12:57 PM, Hans de Goede wrote:
>>> The firmware responding with -EBUSY when trying to add an extra virtual-if
>>> is a normal thing, do not print an error for this.
>>
>> Hi Hans,
>>
>> First of all, sorry! This one is long overdue (thanks for the reminder, Kalle). Not sure what the claim is here. I have to check the firmware to see what could make this fail. Thing is that wpa_supplicant will try to create the interface upon startup and it is really required for P2P operations. Now people not using that will probably not care about the failure, but I would like to find out why it is failing. wpa_supplicant will not do a retry upon -EBUSY.
>>
>> With which firmware (target string and version) are you seeing this so I know where to dive in.
> 
> [root@localhost ~]# dmesg | grep brcm
> [   11.252078] brcmutil: loading out-of-tree module taints kernel.
> [   11.252159] brcmutil: module verification failed: signature and/or required key missing - tainting kernel
> [   11.484195] brcmfmac: brcmf_sdio_probe: Loading firmware brcm/brcmfmac43430a0-sdio.bin for chip 0000a9a6 rev 00000000
> [   11.484290] usbcore: registered new interface driver brcmfmac
> [   11.616053] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  6 2014 14:50:39 version 7.10.226.49 (r) FWID 01-8962686a
> [   14.782464] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   14.782488] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-16
> [   34.300531] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   34.300549] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-16
> 
> [root@localhost ~]# strings /lib/firmware/brcm/brcmfmac43430a0-sdio.bin | tail -n 1
> 43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-lpc-wl11u-rcc-fmc-wepso-ccx-okc-fbt-noccxaka-txpwr-ampduhostreorder-clm_43xx_lg Version: 7.10.226.49 CRC: bf92cb0b Date: Fri 2014-06-06 14:55:15 KST FWID 01-8962686a

Since that firmware is quite old, I've tried again with a newer version:

[   11.219863] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul  1 2016 18:02:40 version 7.10.1 (A0 Station/P2P feature) FWID 01-bae8afee

[root@localhost ~]# strings /lib/firmware/brcm/brcmfmac43430a0-sdio.bin | tail -n 1
43430a0-roml/sdio-g-pool-p2p-pno-pktfilter-keepalive-aoe-mchan-proptxstatus-lpc-wl11u-rcc-fmc-wepso-ccx-okc-fbt-noccxaka-txpwr-ampduhostreorder-clm_43xx_lg-ndoe Version: 7.10.1.244 CRC: 73c82137 Date: Fri 2016-07-01 18:03:15 KST Ucode Ver: 940.1020 FWID: 01-bae8afee

Which still results in the same errors.

Note this is with the a0 revision of the 43430 for which a firmware file is
still missing from linux-firmware. If you happen to be able to add a file
to linux-firmware while looking into this, that would be great.

Regards,

Hans
