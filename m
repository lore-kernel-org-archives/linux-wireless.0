Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51470 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbbKMVzB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 16:55:01 -0500
Subject: Re: Does mac80211 guarantee no data frames are sent to driver until
 encryption is setup?
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
References: <564535ED.6080703@candelatech.com>
 <CALhHN=qF55mHxqz6iX0PSHdBcMa_t6XYgXdkSt+Tt4W9gkFFYA@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56465C34.1090503@candelatech.com> (sfid-20151113_225510_656241_D889E74E)
Date: Fri, 13 Nov 2015 13:55:00 -0800
MIME-Version: 1.0
In-Reply-To: <CALhHN=qF55mHxqz6iX0PSHdBcMa_t6XYgXdkSt+Tt4W9gkFFYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2015 10:14 PM, Janusz Dziedzic wrote:
> On 13 November 2015 at 01:59, Ben Greear <greearb@candelatech.com> wrote:
>> A certain firmware tries to do EAPOL inspection and only allow data pkts
>> to be sent after the 4-way M4 has been sent, for instance.
>>
>> This was breaking .11r because in that case you don't do the 4-way after
>> roaming, so the firmware was waiting forever for an M4 to be sent and
>> thus all tx data was hung.
>>
>> I managed to get this working by just removing all of the EAPOL inspection
>> from the firmware,
>> but I am thinking that if the stack will send data packets to the driver
>> before 4-way auth is completed and keys are set, then maybe I would
>> be opening up a race where un-encrypted frames could hit the air.
>>
>> Any idea what protections, if any, the mac80211 stack provides
>> for this case?
>>
> Check WLAN_STA_AUTHORIZED in mac80211.

Thanks for the hint.  Looks like my firmware change should
be perfectly safe in that case.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

