Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37932 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755279AbcHYGZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 02:25:10 -0400
Received: by mail-wm0-f48.google.com with SMTP id o80so55196786wme.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2016 23:24:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a9bf9a29-f020-7118-79ee-b6c1aaa95ffe@candelatech.com>
References: <1468924452-23877-1-git-send-email-michal.kazior@tieto.com>
 <1468924452-23877-5-git-send-email-michal.kazior@tieto.com> <a9bf9a29-f020-7118-79ee-b6c1aaa95ffe@candelatech.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Thu, 25 Aug 2016 08:18:35 +0200
Message-ID: <CA+BoTQk5GPFnC7tT5qoG6aiN0hSNbiDAVNv7O7j2SXgCvUUjBA@mail.gmail.com> (sfid-20160825_082616_002271_7E37C7F4)
Subject: Re: [PATCH 4/4] ath10k: fix spurious tx/rx during boot
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Marek Puzyniak <marek.puzyniak@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 August 2016 at 19:20, Ben Greear <greearb@candelatech.com> wrote:
> On 07/19/2016 03:34 AM, Michal Kazior wrote:
>>
>> HW Rx filters and masks are not configured
>> properly by firmware during boot sequences. The
>> MAC_PCU_ADDR1 is set to 0s instead of 1s which
>> allows the HW to ACK any frame that passes through
>> MAC_PCU_RX_FILTER. The MAC_PCU_RX_FILTER itself
>> is misconfigured on boot as well.
>>
>> The combination of these bugs ended up with the
>> following manifestations:
>>  - "no channel configured; ignoring frame(s)!"
>>    warnings in the driver
>>  - spurious ACKs (transmission) on the air during
>>    firmware bootup sequences
>>
>> The former was a long standing and known bug
>> originally though mostly harmless.
>>
>> However Marek recently discovered that this
>> problem also involves ACKing *all* frames the HW
>> receives (including beacons ;). Such frames
>> are delivered to host and generate the former
>> warning as well.
>>
>> This could be a problem with regulatory compliance
>> in some rare cases (e.g. Taiwan which forbids
>> transmissions on channel 36 which is the default
>> bootup channel on 5Ghz band cards). The good news
>> is that it'd require someone else to violate
>> regulatory first to coerce our device to generate
>> and transmit an ACK.
>>
>> The problem could be reproduced in a rather busy
>> environment that has a lot of APs. The likelihood
>> could be increased by injecting an msleep() of
>> 5000 or longer immediately after
>> ath10k_htt_setup() in ath10k_core_start().
>>
>> The reason why the former warnings were only
>> showing up seldom is because the device was either
>> quickly reset again (i.e. during firmware probing)
>> or wmi vdev was created (which fixes hw and fw
>> states).
>>
>> It is technically possible for host driver to
>> override adequate hw registers however this can't
>> work reliably because the bug root cause lies in
>> incorrect firmware state on boot (internal
>> structure used to program MAC_PCU_ADDR1 is not
>> properly initialized) and only vdev create/delete
>> events can fix it. This is why the patch takes
>> dummy vdev approach.
>>
>> This could be fixed in firmware as well but having
>> this fixed in driver is more robust, most notably
>> when thinking of users of older firmware such as
>> 999.999.0.636.
>>
>> Reported-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
>
> I was looking at firmware to make sure that I fixed what I could there...=
.
>
> From what I can tell, 10.4 should not have this bug.  Did you see this on=
ly
> on 10.1/10.2 firmware?  It is of course possible that I am mis-understand=
ing
> 10.4....

I did see it on 10.1 and 10.2. Don't recall seeing it on 10.4 though.
If you didn't see warnings on 10.4 even after adding msleep() as per
commit log then I guess it doesn't suffer from the bug.


Micha=C5=82
