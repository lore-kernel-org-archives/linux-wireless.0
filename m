Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35116 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752149AbdHBOgx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 10:36:53 -0400
Received: by mail-qt0-f182.google.com with SMTP id p3so27890564qtg.2
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 07:36:53 -0700 (PDT)
MIME-Version: 1.0
Reply-To: mike@hellotwist.com
In-Reply-To: <87h8xqrso6.fsf@kamboji.qca.qualcomm.com>
References: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
 <20170802070117.GA2790@redhat.com> <1501676470.11126.2.camel@sipsolutions.net>
 <87h8xqrso6.fsf@kamboji.qca.qualcomm.com>
From: Michael Skeffington <mike@astro.ai>
Date: Wed, 2 Aug 2017 10:36:52 -0400
Message-ID: <CAKXXJEwT0EK=dmswxP90WNJQcSM1sUAE3E46AzZ8Pd9a2XXtxg@mail.gmail.com> (sfid-20170802_163657_019706_2FB1B00F)
Subject: Re: [PATCH] rt2x00: Fix MMIC countermeasures.
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I traced through this code during MMIC failure and
ieee80211_rx_h_decrypt() drops the frame before getting to
ieee80211_rx_h_michael_mic_verify().  Johannes suggested this change
to me in response to a previous thread and I am offering this patch
after having conducted the proper testing on it.

On Wed, Aug 2, 2017 at 9:43 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Wed, 2017-08-02 at 09:01 +0200, Stanislaw Gruszka wrote:
>>
>>> The relevant mac80211 code look like this:
>>>
>>> ieee80211_rx_result
>>> ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>>
>> I believe that ieee80211_rx_h_decrypt() will drop the frames you're
>> looking at, and I do think the original patch is correct. If MMIC
>> validation was (and could be) done, then the frame must have been
>> decrypted properly.
>
> Just to avoid any confusion, with original patch you mean this one?
>
> rt2x00: Fix MMIC countermeasures.
> https://patchwork.kernel.org/patch/9875647/
>
> --
> Kalle Valo
