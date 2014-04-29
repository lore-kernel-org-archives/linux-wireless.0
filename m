Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48245 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933447AbaD2MEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 08:04:30 -0400
Received: by mail-wg0-f50.google.com with SMTP id k14so98443wgh.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 05:04:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <535631B7.7050208@openwrt.org>
References: <1398122097-23544-1-git-send-email-tharvey@gateworks.com>
	<1398122097-23544-2-git-send-email-tharvey@gateworks.com>
	<535631B7.7050208@openwrt.org>
Date: Tue, 29 Apr 2014 05:04:28 -0700
Message-ID: <CAJ+vNU1mdgtZuT8NeQmZDJ25cufohqZyvcG4y2EM8tjpfntG7w@mail.gmail.com> (sfid-20140429_140754_055457_4F4DD387)
Subject: Re: [PATCH 2/2] ath9k: add a recv budget
From: Tim Harvey <tharvey@gateworks.com>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>,
	ath9k-devel@lists.ath9k.org, Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 2:09 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2014-04-22 01:14, Tim Harvey wrote:
>> Implement a recv budget so that in cases of high traffic we still allow other
>> taskets to get processed.
>>
>> Without this, we can encounter a host of issues during high wireless traffic
>> reception depending on system load including rcu stall's detected (ARM),
>> soft lockups, failure to service critical tasks such as watchdog resets,
>> and triggering of the tx stuck tasklet.
>>
>> The same thing was proposed previously by Ben:
>>  http://www.spinics.net/lists/linux-wireless/msg112891.html
>>
>> The only difference here is that I make sure only processed packets are counted
>> in the budget by checking at the end of the rx loop.
>>
>> Signed-off-by: Tim Harvey <tharvey@gateworks.com>
> For both patches:
> Acked-by: Felix Fietkau <nbd@openwrt.org>
>

+cc ath9k-devel@lists.ath9k.org
+cc Ben Greear

Any other ack's or comments on these? These address some fairly
long-standing bugs.

Tim
