Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36160 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbcGAHtS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2016 03:49:18 -0400
Received: by mail-pf0-f176.google.com with SMTP id t190so38016275pfb.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2016 00:49:18 -0700 (PDT)
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform
To: Michael Eskowitz <MichaelE@inventeksys.com>,
	linux-wireless@vger.kernel.org
References: <002601d1d305$183c3070$48b49150$@inventeksys.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com> (sfid-20160701_094921_861254_F7F19A1C)
Date: Fri, 1 Jul 2016 09:49:09 +0200
MIME-Version: 1.0
In-Reply-To: <002601d1d305$183c3070$48b49150$@inventeksys.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30-6-2016 21:24, Michael Eskowitz wrote:
> I am trying to bring up the brcmfmac driver on an iMX6 Ultralite board.  I
> have both a 43341 and 43362 Wi-Fi SDIO module up and running on this
> platform already using the standard bcmdhd.  I am told by some Broadcom
> folks that the brcmfmac driver should support concurrent connections which
> is something the bcmdhd does not do and that is my primary motivation for
> getting the fmac driver up and running.

bcmdhd is the standard *android* driver as provided in AOSP. So do you
intend to productize your platform with android. The brcmfmac is our
upstream driver so it will not have android specific functionality.

> The brcmfmac driver is included in NXP's kernel git and I have successfully
> built it and have it on the Ultralite platform running kernel 3.14.38.  When
> I attempt to insert the module using the command
> 
> 	insmod  brcmfmac.ko
> firmware_path=ISM4334X_Wifi_FW_6.10.190.49_P.bin
> nvram_path=ISM4334X_NVRAM_C1.txt
> 
> I receive the following errors:
> 
> 	brcmfmac: Unknown symbol brcmu_pktq_mlen (err 0)
> 	brcmfmac: Unknown symbol brcmu_pkt_buf_free_skb (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_init (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_penq_head (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_pdeq (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_peek_tail (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_flush (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_pdeq_match (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_mdeq (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_penq (err 0)
> 	brcmfmac: Unknown symbol brcmu_pktq_pdeq_tail (err 0)
> 	brcmfmac: Unknown symbol brcmu_pkt_buf_get_skb (err 0)
> 	brcmfmac: Unknown symbol brcmu_d11_attach (err 0)
> 	insmod: ERROR: could not insert module brcmfmac.ko: Unknown symbol
> in module
> 
> I'm not sure that the firmware_path and nvram_path should be specified in
> this manner, but I doubt that is what is causing these errors.  

The brcmfmac driver does not have module parameters firmware_path and
nvram_path. The filenaming is determined by the driver and it must be in
a location that firmware api provider looks for:

drivers/base/firmware_class.c:277:
/* direct firmware loading support */
static char fw_path_para[256];
static const char * const fw_path[] = {
        fw_path_para,
        "/lib/firmware/updates/" UTS_RELEASE,
        "/lib/firmware/updates",
        "/lib/firmware/" UTS_RELEASE,
        "/lib/firmware"
};

/*
 * Typical usage is that passing 'firmware_class.path=$CUSTOMIZED_PATH'
 * from kernel command line because firmware_class is generally built in
 * kernel instead of module.
 */
module_param_string(path, fw_path_para, sizeof(fw_path_para), 0644);
MODULE_PARM_DESC(path, "customized firmware image search path with a
higher priority than default path");

However, this is indeed not the reason for the errors. The brcmfmac
needs functions exported by brcmutil.ko which should be created in the
build you executed.

Regards,
Arend

> The module compiled and built just fine so I am assuming that there are some
> dependencies that aren't being met.  Is there another module that I need to
> load before attempting to load the fmac driver?
> 
> Thanks,
> -Mike
