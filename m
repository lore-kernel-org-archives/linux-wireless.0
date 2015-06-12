Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35266 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbbFLGDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 02:03:33 -0400
Received: by wiga1 with SMTP id a1so6601034wig.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 23:03:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <557A1BE9.7070305@candelatech.com>
References: <5579F87F.4070601@candelatech.com>
	<557A1BE9.7070305@candelatech.com>
Date: Fri, 12 Jun 2015 08:03:32 +0200
Message-ID: <CA+BoTQkLyaP-2sHiu7Wn-ZzGj2JnZs4qzQKGu7PiTtUy4d9xLQ@mail.gmail.com> (sfid-20150612_080337_147543_28923447)
Subject: Re: Question on beacon-miss offloading.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 June 2015 at 01:38, Ben Greear <greearb@candelatech.com> wrote:
> On 06/11/2015 02:07 PM, Ben Greear wrote:
>> In my ath10k CT firmware, I am disabling the beacon-miss offloading
>> to save space and because it will not work with lots of virtual
>> stations.
>>
>> But, it must be that I need some way to tell the stack that this
>> feature is not enabled, because when suddenly kill my AP, then
>> the ath10k station connected to it shows endless 'beacon loss' events
>> in 'iw events' output, but it never actually loses connection.
>>
>> Stock firmware works fine, so probably I just need to disable
>> some feature flag when registering the ath10k hardware
>> when using CT firmware.
>>
>> With stock firmware, I see a quick dissassociation due to inactivity.
>>
>> I am having poor luck finding how a driver tells the stack
>> it has beacon miss offload or not, so, does anyone know how
>> this is controlled?
>
> I still am not sure why stock firmware works, but it appears
> the reason mine is failing is that the ACK status for mgt frames
> is always set to TRUE since the ath10k wmi-mgt-tx API is so
> lame.  So, mac80211 does a probe, ath10k lies and says it was
> acked, and mac80211 then things all is well for another few
> seconds.

mac80211 shouldn't do a Probe Req to an AP on beacon loss because
ath10k advertises it supports tx-status report. Hence mac80211 should
use NullFunc frames which shouldn't go through wmi-mgmt-tx but htt
tx-frm.

But then again: NullFunc status reporting via htt tx-frm was broken on
10.1 if memory serves right. I believe it was fixed in 10.2 or 10.2.4.

This problem has been effectively obscured on stock 10.1 by the
offloaded beacon miss.


Michał
