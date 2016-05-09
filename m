Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44012 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbcEIR6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 13:58:33 -0400
Subject: Re: [PATCH v2 5/5] ath10k: Fix deadlock when peer cannot be created.
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
 <1459545132-11295-5-git-send-email-greearb@candelatech.com>
 <5730C697.206@candelatech.com> <1462816487256.22920@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <5730CFC7.5010901@candelatech.com> (sfid-20160509_195853_741418_498BC28F)
Date: Mon, 9 May 2016 10:58:31 -0700
MIME-Version: 1.0
In-Reply-To: <1462816487256.22920@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2016 10:54 AM, Manoharan, Rajkumar wrote:
>> On Monday, May 9, 2016 10:49 PM, greearb@candelatech.com wrote:
>>> On 04/01/2016 02:12 PM, greearb@candelatech.com wrote:
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> We must not attempt to send WMI packets while holding the data-lock,
>>> as it may deadlock:
>>>
>>> BUG: sleeping function called from invalid context at drivers/net/wireless/ath/ath10k/wmi.c:1824
>>> in_atomic(): 1, irqs_disabled(): 0, pid: 2878, name: wpa_supplicant
>>>
>> Kalle:  I notice these 5 patches are not in the latest wireless-testing.
>>
>> Are they not acceptable, or???
>>
> Aah!.. I recently cooked up similar patch for BUG_ON issue. I think this one is stable candidate. no?

All 5 have a possibility of being worth stable I think, but at least they should probably
go into upstream!

They were not a lot of fun to find or fix, so it would be nice if no one else had to waste
time on it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

