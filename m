Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49690 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab2FJNDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2012 09:03:22 -0400
Message-ID: <4FD49B12.9030705@hauke-m.de> (sfid-20120610_150326_677264_2121BE3E)
Date: Sun, 10 Jun 2012 15:03:14 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, brudley@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 16/18] brcmsmac: do not call brcms_c_chipmatch() for non
 PCI
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de> <1338937641-8519-17-git-send-email-hauke@hauke-m.de> <4FCF3DA7.1080508@broadcom.com> <4FD0AA77.4000108@hauke-m.de> <4FD0FBB5.6040008@broadcom.com>
In-Reply-To: <4FD0FBB5.6040008@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2012 09:06 PM, Arend van Spriel wrote:
> On 06/07/2012 03:19 PM, Hauke Mehrtens wrote:
>> Hi Arend,
>>
>> On 06/06/2012 01:23 PM, Arend van Spriel wrote:
>>> On 06/06/2012 01:07 AM, Hauke Mehrtens wrote:
>>>> brcms_c_chipmatch() just works for PCIe devices and returns false for
>>>> non PCIe devices. This stops brcms_ops_stop() from calling it when the
>>>> devices is not a PCIe device.
>>>
>>> Although this is true you may want to consider what this function
>>> provides. The intent is to have a more accurate filter to determine
>>> support the device by the driver, ie. more accurate than what is in the
>>> driver device table.
>>>
>>> So in brcms_c_chipmatch() we may want a host-type independent filtering
>>> and validate bcma_device_id, bcma_chipinfo, and possibly bcma_boardinfo.
>> I do not like this function at all. ;-)
>>
>> Are these restrictions in this function really needed? I would more like
>> to restrict it to something like core revs, which is done in the device
>> table and the phy types and versions. A restriction by chipid would also
>> be reasonable as some chips are needing some special workarounds, these
>> checks could also be done for SoCs.
> 
> I look where the function came from and it is called in several places
> in our proprietary driver, which has a pretty coarse filter in the
> device table.
> 
> The BCMA device table in brcmsmac is more finegrained and currently has
> entries for the different 80211 core revisions. However, the brcmsmac
> may have additional revision requirement for chipcommon and other cores
> inside the chip so this function may have it merits for checking that.
> 
> Gr. AvS
> 
Hi Arend,

ok, then I will extend it somehow to also handle the SoCs based on the
chip id and rev in that function.

Hauke
