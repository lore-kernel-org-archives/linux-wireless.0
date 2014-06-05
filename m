Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50134 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaFELKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 07:10:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Firmware debugging patches?
References: <53891ACD.7070902@candelatech.com>
	<87wqczz3h9.fsf@kamboji.qca.qualcomm.com>
	<538CA904.4000508@candelatech.com>
	<87ioojz1b1.fsf@kamboji.qca.qualcomm.com>
	<538CB782.1000509@candelatech.com> <538CC68C.10808@gmail.com>
	<538CC949.5020901@candelatech.com>
	<CANUX_P2vbKD3zkwE=DvJJWpo=gEMORCBy=XFoC2YSFpmg9sr_A@mail.gmail.com>
	<538CD507.1050803@candelatech.com>
	<CANUX_P1iaTtFccraAF_p1dFZ3SJFpdNfF=i=eAVXP8yM3GrM4A@mail.gmail.com>
	<538F7381.4070100@candelatech.com>
Date: Thu, 5 Jun 2014 14:10:45 +0300
In-Reply-To: <538F7381.4070100@candelatech.com> (Ben Greear's message of "Wed,
	4 Jun 2014 12:29:05 -0700")
Message-ID: <877g4vpq6i.fsf@kamboji.qca.qualcomm.com> (sfid-20140605_131053_796578_4EF18387)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 06/04/2014 12:23 PM, Emmanuel Grumbach wrote:
>
>>> Do you have a link to your patch that defines the types you used?
>>>
>> 
>> Take a look at 1bd3cbc1a0e9ed977a6bd470c5bc7bd36fd87e26.
>> But I am adding more and more content to this file.
>
> Yeah, after implementing it in ath10k it seems there would
> be very little over-lap, so probably each driver should just
> do their own.
>
> We can keep the debugfs file names the same, and the udev
> event types the same, which should help user-space a bit.

In the future I would actually want to take this a step further and put
all that to cfg80211. That way the driver would only need to call
cfg80211_firmware_crashed(wiphy, dump) and cfg80211 will handle the
rest. This would make sure that all drivers use the exactly same user
space interfaces and hopefully also motivate other drivers to use it.

-- 
Kalle Valo
