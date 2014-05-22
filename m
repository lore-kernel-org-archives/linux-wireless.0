Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57158 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaEVN7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 09:59:07 -0400
Received: by mail-wg0-f52.google.com with SMTP id l18so3403474wgh.23
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 06:59:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400766356.4174.14.camel@jlt4.sipsolutions.net>
References: <1400765294-14732-1-git-send-email-michal.kazior@tieto.com>
	<1400765294-14732-3-git-send-email-michal.kazior@tieto.com>
	<1400766356.4174.14.camel@jlt4.sipsolutions.net>
Date: Thu, 22 May 2014 15:59:05 +0200
Message-ID: <CA+BoTQn4nkKAAwi_M6zp_jjaG8681enfEM+vr3EXUg2uH0B33g@mail.gmail.com> (sfid-20140522_155911_533028_787A7273)
Subject: Re: [PATCH 2/3] mac80211: use csa counter offsets instead of csa_active
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2014 15:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 15:28 +0200, Michal Kazior wrote:
>> vif->csa_active is protected by mutexes only. This
>> means it is unreliable to depend on it on codeflow
>> in non-sleepable beacon and CSA code. There was no
>> guarantee to have vif->csa_active update be
>> visible before beacons are updated on SMP systems.
>>
>> Using csa counter offsets which are embedded in
>> beacon struct (and thus are protected with single
>> RCU assignment) is much safer.
>
> This seems reasonable, but many uses of csa_active remain, no? hwsim for
> example seems to access it without locking as well.

Since the problem could be split I went with fixing things step-by-step.

I was trying to tackle csa_active issue as well but I'm yet to arrive
at a satisfactory solution. It's probably best to kill it and
introduce a drv_switch_beacon_done().

With my patchset csa_active isn't as critical for decision making in the code.


Michał
