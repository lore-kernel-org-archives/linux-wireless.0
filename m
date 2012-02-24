Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2324 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2BXJ4F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 04:56:05 -0500
Message-ID: <4F475EAA.8030200@broadcom.com> (sfid-20120224_105609_376513_D2EB4274)
Date: Fri, 24 Feb 2012 10:55:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Saul St. John" <saul.stjohn@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rafal Milecki" <zajec5@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for
 SPROM storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
 <20120224024202.GA30429@eris.garyseven.net>
In-Reply-To: <20120224024202.GA30429@eris.garyseven.net>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/24/2012 03:42 AM, Saul St. John wrote:
> On Thu, Feb 23, 2012 at 10:52:57PM +0100, Arend van Spriel wrote:
>> Wireless Broadcom chips can have either their SPROM data stored
>> on either external SPROM or on-chip OTP memory. Both are accessed
>> through the same register space. This patch adds support for the
>> on-chip OTP memory.
>>
>> Tested with:
>> BCM43224 OTP and SPROM
>> BCM4331 SPROM
>> BCM4313 OTP
>>
>> This patch is in response so gmane article [1].
>>
>> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
>>
> Tested-by: Saul St. John<saul.stjohn@gmail.com>
>> Cc: Rafal Milecki<zajec5@gmail.com>
>> Cc: Hauke Mehrtens<hauke@hauke-m.de>
>> Cc: Larry Finger<Larry.Finger@lwfinger.net>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
>> ---
>> Determining the offset for OTP sprom data turned out to be
>> easier as it boils down to reading a register. This change
>> collides with patch posted by Hauke:
>>
>> bcma: add support for sprom not found on the device.
>>
>> Now working on changes in brcmsmac to start using the sprom
>> data stored in struct bcma_bus. Feel free to comment this patch.
>>
>> Gr. AvS
>
> This works for me. Do you still need to define BCMA_CC_SPROM_PCIE6?
>

Nope. You are right. I will remove that define in the final patch.

Gr. AvS

