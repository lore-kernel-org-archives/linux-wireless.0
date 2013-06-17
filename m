Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1398 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab3FQRif (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:38:35 -0400
Message-ID: <51BF498F.1010007@broadcom.com> (sfid-20130617_193847_379810_7790A98A)
Date: Mon, 17 Jun 2013 10:38:23 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Jason Cooper" <jason@lakedaemon.net>
cc: rvossen@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] net: brcmfmac: add sdio chip id 0x4319
References: <20130612222123.GB31667@titan.lakedaemon.net>
 <20130617161903.GN31667@titan.lakedaemon.net>
In-Reply-To: <20130617161903.GN31667@titan.lakedaemon.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2013 09:19 AM, Jason Cooper wrote:
> Added Franky...
>
> On Wed, Jun 12, 2013 at 06:21:23PM -0400, Jason Cooper wrote:
>> All,
>>
>> I have a Seagate Wireless Plus I am trying to put a vanilla kernel on
>> (currently v3.10-rc5 for various omap DT bits).
>>
>> I have the board booting and running a debian rootfs on the HD.  I just
>> got mmc to come up and I've discovered that the wireless card is vendor
>> 0x02d0, device 0x4319.
>>
>> My hope, once I got to this point, was that I would be able to use
>> the mainline, open source driver.  Unfortunately, it looks like brcmfmac
>> lost support for the 0x4319 while it was in staging.
>>
>> The commit in question is:
>>
>>    4dad253 staging: brcm80211: remove code for unsupported chip
>>
>> Is adding it back in a bridge too far?
> It looks like only two things are needed, adding the chip id and then
> setting the addresses.  Here's a preliminary patch to do just that.
> Note, the addresses I have used are a straight copy from the 4329.  It
> causes this:
>
> [   12.346466] mmcblk mmc0:0001: no of_node; not parsing pinctrl DT
> [   12.353149] brcmfmac_sdio mmc0:0001:1: no of_node; not parsing pinctrl DT
> [   12.360717] brcmfmac_sdio mmc0:0001:2: no of_node; not parsing pinctrl DT
> [   12.368804] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength init done for chip 4319 rev 1 pmurev 7
> [   12.380462] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> [   12.391906] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> [   12.403289] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> [   12.412261] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
> [   12.418457] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> [   12.429718] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> [   12.441101] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> [   12.450073] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
>
> I've taken a quick look at aosp, the provided GPL broadcom code, and I
> haven't seen anything for the 4319 wrt to addresses.  How hard would it
> be to get those addresses from you guys?

Hi Jason,

The major obstacle of adding 4319 support is the obsolete firmware. 
Since it's an EOL chip we are not planning to add the support to brcmfmac.

Franky

