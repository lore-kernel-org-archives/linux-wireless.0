Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37471 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2FFImM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:42:12 -0400
Message-ID: <4FCF17DA.4010100@hauke-m.de> (sfid-20120606_104219_772192_FCA6B135)
Date: Wed, 06 Jun 2012 10:42:02 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/8] bcma: Fix for 4329b0 bad LPOM is detection
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <1338933307-13446-4-git-send-email-hauke@hauke-m.de> <2043822.26J1ek8FFi@flexo>
In-Reply-To: <2043822.26J1ek8FFi@flexo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2012 10:08 AM, Florian Fainelli wrote:
> Hi Hauke,
> 
> On Tuesday 05 June 2012 23:55:02 Hauke Mehrtens wrote:
>> This workaround should be triggered based on the chipid and rev and not
>> the core id and rev. This is based on code in the Broadcom SDK.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  drivers/bcma/driver_chipcommon_pmu.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/bcma/driver_chipcommon_pmu.c 
> b/drivers/bcma/driver_chipcommon_pmu.c
>> index da8769e..dd2b55d 100644
>> --- a/drivers/bcma/driver_chipcommon_pmu.c
>> +++ b/drivers/bcma/driver_chipcommon_pmu.c
>> @@ -166,6 +166,7 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
>>  void bcma_pmu_init(struct bcma_drv_cc *cc)
>>  {
>>  	u32 pmucap;
>> +	struct bcma_bus *bus = cc->core->bus;
>>  
>>  	pmucap = bcma_cc_read32(cc, BCMA_CC_PMU_CAP);
>>  	cc->pmu.rev = (pmucap & BCMA_CC_PMU_CAP_REVISION);
>> @@ -180,7 +181,7 @@ void bcma_pmu_init(struct bcma_drv_cc *cc)
>>  		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
>>  			     BCMA_CC_PMU_CTL_NOILPONW);
>>  
>> -	if (cc->core->id.id == 0x4329 && cc->core->id.rev == 2)
>> +	if (bus->chipinfo.id == 0x4329 && bus->chipinfo.rev == 2)
>>  		pr_err("Fix for 4329b0 bad LPOM state not implemented!\n");
> 
> Does not that deserve a new define to be in line with your previous patch?
> --
> Florian

Probably we can remove this completely. The BCM4329 is a fullmac chip
mostly used in phones and this part is done in the firmware.

Hauke
