Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from walmailout02.yourhostingaccount.com ([65.254.253.157]:38979
	"EHLO walmailout02.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbcGLTxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 15:53:02 -0400
Received: from mailscan08.yourhostingaccount.com ([10.1.15.8] helo=walmailscan08.yourhostingaccount.com)
	by walmailout02.yourhostingaccount.com with esmtp (Exim)
	id 1bN3BR-0004Ii-RY
	for linux-wireless@vger.kernel.org; Tue, 12 Jul 2016 15:17:29 -0400
Received: from [10.114.3.32] (helo=walimpout12)
	by walmailscan08.yourhostingaccount.com with esmtp (Exim)
	id 1bN3BR-0005jL-Kt
	for linux-wireless@vger.kernel.org; Tue, 12 Jul 2016 15:17:29 -0400
From: "Michael Eskowitz" <MichaelE@inventeksys.com>
To: "'Arend Van Spriel'" <arend.vanspriel@broadcom.com>,
	<linux-wireless@vger.kernel.org>
References: <002601d1d305$183c3070$48b49150$@inventeksys.com> <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com>
In-Reply-To: <6d12bb3e-a01d-34c7-c1a9-b1952a84f99e@broadcom.com>
Subject: RE: building brcmfmac driver for iMX6 Ultralite platform
Date: Tue, 12 Jul 2016 15:17:22 -0400
Message-ID: <001201d1dc72$0675f030$1361d090$@inventeksys.com> (sfid-20160712_215314_401015_1C3911D2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend,

That is news to me.  I was under the impression that bcmdhd was Broadcom's
proprietary (closed source) Linux driver and brcmfmac was the open source
Linux driver.

Either way, I am now running

	insmod  brcmutil.ko
	insmod  brcmfmac.ko

I receive no errors and no kernel messages.

When I insert the 43341 module into the SDIO slot nothing happens.  I'm
guessing that the version of the brcmfmac driver that I built does not
support that chip.

When I insert the 43362 module into the SDIO slot I receive the following
errors

	mmc0: queuing unknown CIS tuple 0x80 (7 bytes)
	mmc0: new high speed SDIO card at address 0001
	brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  7 2012
18:27:16 version 5.90.225 FWID 01-d8fe14bd
	brcmfmac: brcmf_fil_cmd_data: Failed err=-23
	brcmfmac: brcmf_fil_cmd_data: Failed err=-23
	brcmfmac: brcmf_fil_cmd_data: Failed err=-23
	brcmfmac: brcmf_fil_cmd_data: Failed err=-23
	brcmfmac: brcmf_add_if: ERROR: netdev:wlan0 already exists
	brcmfmac: brcmf_add_if: ignore IF event
	brcmfmac: brcmf_fil_cmd_data: Failed err=-23
	brcmfmac: brcmf_construct_reginfo: channel 1: f=2412 bw=0
sb=-1998840228
	brcmfmac: brcmf_construct_reginfo: channel 2: f=2417 bw=0
sb=-1998840228

and suddenly ifconfig shows the interface wlan0.  The interface looks to be
valid as it is displaying a MAC from our address range.  

Although the interface wlan0 is present I am not able to use wl commands to
scan for networks.  wl reports "wl driver adapter not found" for all command
arguments.  If I run the command

	iwlist  wlan0  scan

I'm told that the interface does not support scanning.  If I run wpa_cli and
then the commands scan and scanresults I don't see any networks.

I'm thinking that the interface has not come up successfully.  Are any of
the error messages above meaningful to you?

Thanks,
-Mike




-----Original Message-----
From: Arend Van Spriel [mailto:arend.vanspriel@broadcom.com] 
Sent: Friday, July 1, 2016 3:49 AM
To: Michael Eskowitz <MichaelE@inventeksys.com>;
linux-wireless@vger.kernel.org
Subject: Re: building brcmfmac driver for iMX6 Ultralite platform

On 30-6-2016 21:24, Michael Eskowitz wrote:
> I am trying to bring up the brcmfmac driver on an iMX6 Ultralite 
> board.  I have both a 43341 and 43362 Wi-Fi SDIO module up and running 
> on this platform already using the standard bcmdhd.  I am told by some 
> Broadcom folks that the brcmfmac driver should support concurrent 
> connections which is something the bcmdhd does not do and that is my 
> primary motivation for getting the fmac driver up and running.

bcmdhd is the standard *android* driver as provided in AOSP. So do you
intend to productize your platform with android. The brcmfmac is our
upstream driver so it will not have android specific functionality.

> The brcmfmac driver is included in NXP's kernel git and I have 
> successfully built it and have it on the Ultralite platform running 
> kernel 3.14.38.  When I attempt to insert the module using the command
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
in 
> module
> 
> I'm not sure that the firmware_path and nvram_path should be specified 
> in this manner, but I doubt that is what is causing these errors.

The brcmfmac driver does not have module parameters firmware_path and
nvram_path. The filenaming is determined by the driver and it must be in a
location that firmware api provider looks for:

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
MODULE_PARM_DESC(path, "customized firmware image search path with a higher
priority than default path");

However, this is indeed not the reason for the errors. The brcmfmac needs
functions exported by brcmutil.ko which should be created in the build you
executed.

Regards,
Arend

> The module compiled and built just fine so I am assuming that there 
> are some dependencies that aren't being met.  Is there another module 
> that I need to load before attempting to load the fmac driver?
> 
> Thanks,
> -Mike

