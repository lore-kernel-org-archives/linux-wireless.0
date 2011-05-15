Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3459 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1EOMxZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 08:53:25 -0400
Message-ID: <4DCFCCB4.1010303@broadcom.com> (sfid-20110515_145328_664047_5DD10706)
Date: Sun, 15 May 2011 14:53:08 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Greg KH" <greg@kroah.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/32] staging: brcm80211: new Kconfig item to
 enable IO reordering fix
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
 <1305280792-9475-2-git-send-email-arend@broadcom.com>
 <20110514154636.GA25783@kroah.com>
In-Reply-To: <20110514154636.GA25783@kroah.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2011 05:46 PM, Greg KH wrote:
> On Fri, May 13, 2011 at 11:59:22AM +0200, Arend van Spriel wrote:
>> From: Roland Vossen<rvossen@broadcom.com>
>>
>> bcm4716 (which includes 4717&  4718), plus 4706 on PCIe can reorder
>> transactions. As a fix, a read after write is performed on certain places
>> in the code. Older chips and the newer 5357 family don't require this fix.
>>
>> Cc: devel@linuxdriverproject.org
>> Cc: linux-wireless@vger.kernel.org
>> Reviewed-by: Henry Ptasinski<henryp@broadcom.com>
>> Reviewed-by: Brett Rudley<brudley@broadcom.com>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>>   drivers/staging/brcm80211/Kconfig                  |    8 ++++++++
>>   .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 ++--
>>   drivers/staging/brcm80211/include/bcmutils.h       |   11 +++++++++++
>>   3 files changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
>> index f4cf9b2..a11ffc7 100644
>> --- a/drivers/staging/brcm80211/Kconfig
>> +++ b/drivers/staging/brcm80211/Kconfig
>> @@ -36,3 +36,11 @@ config BRCMDBG
>>   	depends on BRCMSMAC || BRCMFMAC
>>   	---help---
>>   	  Selecting this enables additional code for debug purposes.
>> +
>> +config BRCM_FIX_IO_ORDER
>> +	bool "Broadcom I/O order fix"
>> +	default n
>> +	depends on BRCMSMAC
>> +	---help---
>> +	  Select this for for platforms running on bcm4706, 4716, 4717 or 4718.
>> +	  It resolves an I/O issue with the PCIe core used in these chips.
> No, don't make a new kconfig option for something that everyone has to
> enable as they don't know what they have on their system (think
> universal kernels built by distros.)
>
> Do this check dynamically, depending on the chip the driver is running
> on, don't rely on a user to know what to do here.
>
> So I'm not going to accept this patch, sorry.
Hi Greg,

No problem. Thanks for the feedback. There are two other patches in this 
series which depend on this one. Could you also drop the following:

[PATCH 03/32] staging: brcm80211: replaced #ifdef __mips__ sections by 
W_REG_FLUSH
[PATCH 11/32] staging: brcm80211: Kconfig fix for 'Broadcom I/O order fix'

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


