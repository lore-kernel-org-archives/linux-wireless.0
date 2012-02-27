Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1289 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab2B0KND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 05:13:03 -0500
Message-ID: <4F4B571E.7040704@broadcom.com> (sfid-20120227_111310_660734_54C589F8)
Date: Mon, 27 Feb 2012 11:12:46 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Saul St. John" <saul.stjohn@gmail.com>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <4F48D997.1060400@hauke-m.de>
In-Reply-To: <4F48D997.1060400@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2012 01:52 PM, Hauke Mehrtens wrote:
> On 02/23/2012 10:52 PM, Arend van Spriel wrote:
>> Wireless Broadcom chips can have either their SPROM data stored
>> on either external SPROM or on-chip OTP memory. Both are accessed
>> through the same register space. This patch adds support for the
>> on-chip OTP memory.
>>
>> Tested with:
>> BCM43224 OTP and SPROM
>> BCM4331 SPROM
>> BCM4313 OTP
>
> Does bcma now support the same features regarding sprom and otp as
> brcmsamc expect it does not read out all the attributes brcmsmac reads
> out or are there any features still missing? I am just asking because
> the code used in brcmsmac is ~4 times longer.

I started on using bcma sprom content in brcmsmac and indeed there are 
some entries missing. The change in this patch only provides read-access 
to the srom data. As the chip comes up for read-access there is not much 
programming need to accomplish that. The only feature that is not there 
is that on some chips OTP can be powered down for power-saving. The 
current chips supported by BCMA don't have that.

>> This patch is in response so gmane article [1].
>>
>> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
>>
>> Cc: Saul St. John<saul.stjohn@gmail.com>
>> Cc: Rafal Milecki<zajec5@gmail.com>
>> Cc: Hauke Mehrtens<hauke@hauke-m.de>
>> Cc: Larry Finger<Larry.Finger@lwfinger.net>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> Determining the offset for OTP sprom data turned out to be
>> easier as it boils down to reading a register. This change
>> collides with patch posted by Hauke:
>
> I will test you patch on my device soon and will report if something is
> wrong. If you are sending a non RFC patch in the next days I would
> rebase my patch onto yours. The code searching in the SoCs flash chip
> will be added to run if bcma_sprom_onchip_available() returns false.

Appreciate any testing on SoCs. I think I will need some time to modify 
brcmsmac so let your patch go first.

>> bcma: add support for sprom not found on the device.
>>
>> Now working on changes in brcmsmac to start using the sprom
>> data stored in struct bcma_bus. Feel free to comment this patch.
>>
>> Gr. AvS
>> ---
>>   drivers/bcma/sprom.c                        |  118 ++++++++++++++++++++++++---
>>   include/linux/bcma/bcma_driver_chipcommon.h |    9 ++
>>   2 files changed, 115 insertions(+), 12 deletions(-)
>>
>> +#define BCMA_CC_OTPL			0x001C		/* OTP layout */
>> +#define  BCMA_CC_OTPL_GURGN_OFFSET	0x00000FFF	/* offset of general use region */
>>   #define BCMA_CC_IRQSTAT			0x0020
>>   #define BCMA_CC_IRQMASK			0x0024
>>   #define	 BCMA_CC_IRQ_GPIO		0x00000001	/* gpio intr */
>> @@ -79,6 +84,10 @@
>>   #define	 BCMA_CC_IRQ_WDRESET		0x80000000	/* watchdog reset occurred */
>>   #define BCMA_CC_CHIPCTL			0x0028		/* Rev>= 11 only */
>>   #define BCMA_CC_CHIPSTAT		0x002C		/* Rev>= 11 only */
>> +#define  BCMA_CC_CHIPST_4313_SPROM_PRESENT	1
>> +#define  BCMA_CC_CHIPST_4313_OTP_PRESENT	2
>> +#define  BCMA_CC_CHIPST_4331_SPROM_PRESENT	2
>> +#define	 BCMA_CC_CHIPST_4331_OTP_PRESENT	4
>>   #define BCMA_CC_JCMD			0x0030		/* Rev>= 10 only */
>>   #define  BCMA_CC_JCMD_START		0x80000000
>>   #define  BCMA_CC_JCMD_BUSY		0x80000000
>
> What is the correct way to format this file? BCMA_CC_JCMD_BUSY uses two
> spaces after the define and BCMA_CC_OTPS_CID_PROTECT uses a tabulator
> and a space, what is the correct or intended way to format this? This
> does not have directly something to do with this patches as both ways
> are currently coded in this file.

I assumed the convention was to use two spaces and I corrected 
BCMA_CC_CHIPST_4331_OTP_PRESENT accordingly after reading back my RFC patch.

Gr. AvS

