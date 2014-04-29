Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49715 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbaD2MZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 08:25:25 -0400
Message-ID: <535F9A28.9070809@openwrt.org> (sfid-20140429_142529_002364_3A487C3C)
Date: Tue, 29 Apr 2014 14:25:12 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Tim Harvey <tharvey@gateworks.com>, linux-wireless@vger.kernel.org
CC: John Linville <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org, Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 2/2] ath9k: add a recv budget
References: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>	<1398122097-23544-2-git-send-email-tharvey@gateworks.com>	<535631B7.7050208@openwrt.org> <CAJ+vNU1mdgtZuT8NeQmZDJ25cufohqZyvcG4y2EM8tjpfntG7w@mail.gmail.com>
In-Reply-To: <CAJ+vNU1mdgtZuT8NeQmZDJ25cufohqZyvcG4y2EM8tjpfntG7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-04-29 14:04, Tim Harvey wrote:
> On Tue, Apr 22, 2014 at 2:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> On 2014-04-22 01:14, Tim Harvey wrote:
>>> Implement a recv budget so that in cases of high traffic we still allow other
>>> taskets to get processed.
>>>
>>> Without this, we can encounter a host of issues during high wireless traffic
>>> reception depending on system load including rcu stall's detected (ARM),
>>> soft lockups, failure to service critical tasks such as watchdog resets,
>>> and triggering of the tx stuck tasklet.
>>>
>>> The same thing was proposed previously by Ben:
>>>  http://www.spinics.net/lists/linux-wireless/msg112891.html
>>>
>>> The only difference here is that I make sure only processed packets are counted
>>> in the budget by checking at the end of the rx loop.
>>>
>>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
>> For both patches:
>> Acked-by: Felix Fietkau <nbd@openwrt.org>
>>
> 
> +cc ath9k-devel@lists.ath9k.org
> +cc Ben Greear
> 
> Any other ack's or comments on these? These address some fairly
> long-standing bugs.
No need for further ack's or comments, since the change has been picked
up by John already.

- Felix
