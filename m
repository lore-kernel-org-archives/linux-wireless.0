Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37572 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbcEIRy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 13:54:57 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] ath10k: Fix deadlock when peer cannot be created.
Date: Mon, 9 May 2016 17:54:47 +0000
Message-ID: <1462816487256.22920@qti.qualcomm.com> (sfid-20160509_195500_696456_33638F02)
References: <1459545132-11295-1-git-send-email-greearb@candelatech.com>
 <1459545132-11295-5-git-send-email-greearb@candelatech.com>,<5730C697.206@candelatech.com>
In-Reply-To: <5730C697.206@candelatech.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Monday, May 9, 2016 10:49 PM, greearb@candelatech.com wrote:
>> On 04/01/2016 02:12 PM, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> We must not attempt to send WMI packets while holding the data-lock,
>> as it may deadlock:
>>
>> BUG: sleeping function called from invalid context at drivers/net/wireless/ath/ath10k/wmi.c:1824
>> in_atomic(): 1, irqs_disabled(): 0, pid: 2878, name: wpa_supplicant
>>
> Kalle:  I notice these 5 patches are not in the latest wireless-testing.
> 
> Are they not acceptable, or???
>
Aah!.. I recently cooked up similar patch for BUG_ON issue. I think this one is stable candidate. no?

-Rajkumar