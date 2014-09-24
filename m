Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63816 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaIXGuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 02:50:40 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so6558087wiv.7
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 23:50:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5421818A.9040501@candelatech.com>
References: <1411151304-31544-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQm1rZO+yBbYxihpgEvR1cGZWS4Pr0AP+KMODcG4jpd_jQ@mail.gmail.com>
	<5421818A.9040501@candelatech.com>
Date: Wed, 24 Sep 2014 08:50:38 +0200
Message-ID: <CA+BoTQkZaGSkC9mhE8UF0He0RZWmPghDukdE1A5qiO1UNAZj5Q@mail.gmail.com> (sfid-20140924_085044_521514_1A8A0A1C)
Subject: Re: [PATCH] ath10k: request firmware flush in ath10k_flush.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 September 2014 16:19, Ben Greear <greearb@candelatech.com> wrote:
> On 09/23/2014 02:16 AM, Michal Kazior wrote:
>> On 19 September 2014 20:28,  <greearb@candelatech.com> wrote:
>> [...]
>>>
>>> +       /* If we are CT firmware, ask it to flush all tids on all peers
>>> on
>>> +        * all vdevs.  Normal firmware will just crash if you do this.
>>> +        */
>>> +       if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
>>> +               ath10k_wmi_peer_flush(ar, 0xFFFFFFFF, peer_addr,
>>> 0xFFFFFFFF);
>>
>> I recall you've explained this some time ago, but can you refresh my
>> memory, please? Is this any different from iterating over all peers
>> and flushing each? Or does your firmware do so extra magic that is
>> impossible to do with normal firmware commands?
>
> My firmware does that iteration internally.
>
> You could probably do that in the driver, but it would be a lot
> of messages (for all vdevs, all peers, all tids)...
> I was not sure if there were limits to the number
> of commands you should attempt during the flush...

Thanks. I think ath10k should do this instead of having CT-specific
flush eventually.

I recall I actually did per-peer flushing in RFC patches a long time
ago but I didn't pursue getting them merged. I think Denton uses these
patches in his setup. They don't flush vdev self-peers though (do you
do that internally?).


Michał
