Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42152 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757999Ab2FGNUA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 09:20:00 -0400
Message-ID: <4FD0AA77.4000108@hauke-m.de> (sfid-20120607_152004_462078_55445FB8)
Date: Thu, 07 Jun 2012 15:19:51 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/18] brcmsmac: do not call brcms_c_chipmatch() for non
 PCI
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-17-git-send-email-hauke@hauke-m.de> <4FCF3DA7.1080508@broadcom.com>
In-Reply-To: <4FCF3DA7.1080508@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 06/06/2012 01:23 PM, Arend van Spriel wrote:
> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>> brcms_c_chipmatch() just works for PCIe devices and returns false for
>> non PCIe devices. This stops brcms_ops_stop() from calling it when the
>> devices is not a PCIe device.
> 
> Although this is true you may want to consider what this function
> provides. The intent is to have a more accurate filter to determine
> support the device by the driver, ie. more accurate than what is in the
> driver device table.
> 
> So in brcms_c_chipmatch() we may want a host-type independent filtering
> and validate bcma_device_id, bcma_chipinfo, and possibly bcma_boardinfo.
I do not like this function at all. ;-)

Are these restrictions in this function really needed? I would more like
to restrict it to something like core revs, which is done in the device
table and the phy types and versions. A restriction by chipid would also
be reasonable as some chips are needing some special workarounds, these
checks could also be done for SoCs.

In my opinion this functions results in preventing users from running
this driver with some device which is working with this driver but which
is not in this list of supported devices, because some board vendor just
changed some id and no developer got such a card to test it and change
the detection code.
It is like with the PCIe card I found connected to my BCM4718, this card
is working expect for some problems with the PCIe host controller on the
BCM4716, but brcms_c_chipmatch() returned false for it.

By the way, why is a call to this function in brcms_ops_stop() in
addition to the call in the init code? In this case the device was
already started.

>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   22 +++++++++++++-------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
> 

