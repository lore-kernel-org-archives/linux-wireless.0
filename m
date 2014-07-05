Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:30694 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbaGEIdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2014 04:33:08 -0400
Message-ID: <53B7B841.8000908@broadcom.com> (sfid-20140705_103315_999220_E1E192B7)
Date: Sat, 5 Jul 2014 10:33:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: <stable@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] brcmfmac: Fix brcmf_chip_ai_coredisable not applying
 reset bits to BCMA_IOCTL
References: <1402091675-6515-1-git-send-email-arend@broadcom.com> <20140704220533.GA10958@kroah.com>
In-Reply-To: <20140704220533.GA10958@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/14 00:05, Greg KH wrote:
> On Fri, Jun 06, 2014 at 11:54:31PM +0200, Arend van Spriel wrote:
>> From: Hans de Goede<hdegoede@redhat.com>
>>
>> brcmfmac has been broken on my cubietruck with a BCM43362:
>>
>> brcmfmac: brcmf_chip_recognition: found AXI chip: BCM43362, rev=1
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>>          Apr 22 2013 14:50:00 version 5.90.195.89.6 FWID 01-b30a427d
>>
>> since commit 53036261033: "brcmfmac: update core reset and disable routines".
>>
>> The problem is that since this commit brcmf_chip_ai_resetcore no longer sets
>> BCMA_IOCTL itself before bringing the core out of reset, instead relying on
>> brcmf_chip_ai_coredisable to do so. But brcmf_chip_ai_coredisable is a nop
>> of the chip is already in reset. This patch modifies brcmf_chip_ai_coredisable
>> to always set BCMA_IOCTL even if the core is already in reset.
>>
>> This fixes brcmfmac hanging in firmware loading on my board.
>>
>> upstream: 75691d9e4f4e156f71f3eaee69a5bd27b7b10384

Hi Greg,

I guess I did not swim far enough upstream ;-) Below the commit id as 
found in Linus's tree:

commit ffa216bb5eecfce0f01b0b2a95d5c320dde90005
Author: Hans de Goede <hdegoede@redhat.com>
Date:   Wed Apr 23 12:20:55 2014 +0200

     brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to 
BCMA_IOCT

Thanks for checking.

Regards,
Arend

> I see no such commit id in Linus's tree, are you sure this is the id you
> need?
>
> thanks,
>
> greg k-h

