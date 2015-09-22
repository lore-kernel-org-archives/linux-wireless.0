Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:52659 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934462AbbIVTOO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 15:14:14 -0400
Subject: Re: [PATCH] iwlwifi: fix requested firmware name for iwlwifi-3160
To: Johannes Berg <johannes@sipsolutions.net>,
	emmanuel.grumbach@intel.com
References: <1442659190-6060-1-git-send-email-hauke@hauke-m.de>
 (sfid-20150919_124007_995516_62A820AE)
 <1442911476.2018.2.camel@sipsolutions.net>
 (sfid-20150922_104447_027012_36D311B0)
 <1442911617.2018.3.camel@sipsolutions.net>
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
From: Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <5601A883.1010209@hauke-m.de> (sfid-20150922_211426_011461_64340ED0)
Date: Tue, 22 Sep 2015 21:14:11 +0200
MIME-Version: 1.0
In-Reply-To: <1442911617.2018.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/22/2015 10:46 AM, Johannes Berg wrote:
> On Tue, 2015-09-22 at 10:44 +0200, Johannes Berg wrote:
>> On Sat, 2015-09-19 at 12:39 +0200, Hauke Mehrtens wrote:
>>> modinfo iwlwifi showed the following required firmware:
>>> firmware: iwlwifi-3160-IWL3160_UCODE_API_OK.ucode
>>
>> This is obviously wrong.
>>
>>>
>>>  MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
>>> -MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
>>> +MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3165_UCODE_API_OK));
>>>
>> But this is also wrong, it should be 7260, and there should be a
>> separate entry for 3165. I'll get a patch on the way to fix it.
>>
> 
> Actually, no, there shouldn't be another entry since 3165 uses the same
> firmware as 7265-D.
> 
> johannes

Should I change something?

iwl3165 uses iwl3160 firmware, but support for that was added in rev 13
of that firmware. That's the information I got from the driver and the
linux-firmware commit messages.

Hauke
