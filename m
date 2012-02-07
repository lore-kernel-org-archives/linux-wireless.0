Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3842 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab2BGR0O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 12:26:14 -0500
Message-ID: <4F315E7E.7040203@broadcom.com> (sfid-20120207_182623_054134_A489AA09)
Date: Tue, 7 Feb 2012 18:25:18 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: REGRESSION: crash in wireless-testing smoketest
References: <4F313815.3020107@broadcom.com> (
 sfid-20120207_154219_853529_011888C8)
 <4F313C53.2040604@sipsolutions.net>
In-Reply-To: <4F313C53.2040604@sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2012 03:59 PM, Johannes Berg wrote:
> On 2/7/2012 3:41 PM, Arend van Spriel wrote:
>> Hi Johannes,
>>
>> For the brcm80211 drivers we have nightly tests running on both internal
>> repo and wireless-testing. Last nights test failed for wireless-testing
>> and it occurred during AUTH/ASSOC. I bisected the issue to following commit:
>>
>> commit 7852e36186d2a1983c215836d7e3d7b8927c930d
>> Author: Johannes Berg<johannes.berg@intel.com>
>> Date:   Fri Jan 20 13:55:24 2012 +0100
>>
>>      mac80211: remove dummy STA support
>>
>>      The dummy STA support was added because I didn't
>>      want to change the driver API at the time. Now
>>      that we have state transitions triggering station
>>      add/remove in the driver, we only call add once a
>>      station reaches ASSOCIATED, so we can remove the
>>      dummy station stuff again.
>>
>>      While at it, tighten the RX check and accept only
>>      port control (EAP) frames from the AP station if
>>      it's not associated yet -- in other cases there's
>>      no race.
>>
>>      Signed-off-by: Johannes Berg<johannes.berg@intel.com>
>>      Signed-off-by: John W. Linville<linville@tuxdriver.com>
>>
>> The brcmsmac driver does not provide a sta_remove callback. I suspect
>> that is causing the issue here. Can you confirm?
> 
> I'm on a business trip right now, but I can take a look. Did it really 
> *crash*? You said so in the subject but have no crash data.
> 
> johannes
> 

The logs did not catch it before the crash. I dug a bit deeper and it
does not seem the missing sta_remove is a problem as drv_sta_remove
checks the function pointer being non-NULL before using it.

Can you recommend a kernel hacking option so the log may give a better clue?

Gr. AvS

