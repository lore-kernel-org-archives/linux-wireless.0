Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34956 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030467AbeEXRxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 13:53:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id o78-v6so7750538wmg.0
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 10:53:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vabdb53p.fsf@kamboji.qca.qualcomm.com>
References: <20180516140820.1636-1-daniel@zonque.org> <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org>
 <874lj5jj96.fsf@kamboji.qca.qualcomm.com> <65b0f1d0-0c74-0efb-c7ca-c0fbae681810@zonque.org>
 <877entigth.fsf@codeaurora.org> <00f05d66-3076-0e49-f4af-74c797210948@zonque.org>
 <87a7spcm0y.fsf_-_@kamboji.qca.qualcomm.com> <7da8eaca-8a29-941e-8d63-e29f959ebad8@zonque.org>
 <87vabdb53p.fsf@kamboji.qca.qualcomm.com>
From: Ramon Fried <ramon.fried@gmail.com>
Date: Thu, 24 May 2018 20:53:05 +0300
Message-ID: <CA+Kvs9ktN4V2oPygF71EXB7paSciXFHqBByRN07-2Vf3jG9WUQ@mail.gmail.com> (sfid-20180524_195328_185775_590D683E)
Subject: Re: wcn36xx: bug #538: stuck tx management frames
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Daniel Mack <daniel@zonque.org>, loic.poulain@linaro.org,
        linux-wireless@vger.kernel.org, bjorn.andersson@linaro.org,
        nicolas.dechesne@linaro.org, wcn36xx@lists.infradead.org,
        rfried@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 24, 2018 at 3:39 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Daniel Mack <daniel@zonque.org> writes:
>
>> On Thursday, May 24, 2018 01:48 PM, Kalle Valo wrote:
>>> Daniel Mack <daniel@zonque.org> writes:
>>>> On Thursday, May 24, 2018 10:44 AM, Kalle Valo wrote:
>>>>> Daniel Mack <daniel@zonque.org> writes:
>>
>>>> It seems that once a network is successfully joined, the network
>>>> stability is fine. I haven't seen any starvation of streams lately, at
>>>> least not with the the patches in this series which I'm running since
>>>> a while. That is, until a disconnect/reconnect attempt is made, and at
>>>> this point, only management frames are involved.
>>>
>>> Ah, maybe originally you were seeing different issues with similar
>>> symptoms? But now you have fixed the other bugsand now the stuck
>>> transmitted management frame issue is left? Just guessing...
>>
>> Yeah, I wish I had a clearer picture on all this myself :(
>>
>> My patches definitely address some of the issues I have seen before,
>> also the fixes for potential race conditions are likely to have a
>> positive effect. But as you guessed yourself, I'm afraid that there's
>> a multitude of possible sources for bugs, so it's hard to tell.
>
> Sure, but things seem to going be forward in steady state. Thanks for
> your hard work!
>
>>> It would be great to have wcn36xx logging via tracing, just like ath10k
>>> and iwlwifi does. This way logging shouldn't slow down the system too
>>> much and with wpasupplicant's -T switch you can even get wpasupplicant's
>>> debug messages to the same log with proper timestamps! And almost
>>> forgot, you can also include mac80211 tracing logs as well:
>>>
>>> https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/tracing
>>>
>>> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/debug#tracing
>>>
>>> See ath10k_dbg() and trace_ath10k_log_dbg() for ideas how to implement
>>> this, and you can also take a look at iwlwifi. Should be pretty easy.
>>> Patches more than welcome :)
>>
>> Okay, I'll see if I can find some time to look into this.
>>
>> The reason why I didn't focus the logging possibilities is that I
>> looked at the SMD messages that are flying around which result from
>> ieee80211 API calls into the driver, and I can't seem to find anything
>> that's wrong, especially not before the timeouts occur. Hence, I don't
>> actually expect any oddness on the ieee80211 layer.
>>
>> But I agree that in general, better logging is certainly helpful.
>
> Yeah, I'm not expecting tracing logs to solve this case either but maybe
> we could find some hints. And it just makes it so much easier to see
> what's really happening from tracing logs instead trying to guess from
> the bug description. "a tracing log is worth a thousand words" ;)
>
> But if you don't have time to implement tracing support to wcn36xx
> hopefully someone else has, all one needs is a DragonBoard 410c. A
> simple project for a student or someone who wants to contribute
> something to the kernel.
I have time to do it. If nobody else started yet...
Thanks.
>
>>>> It seems it does, yes. Tests at night seem to take a bit more time to
>>>> make the effect happen. But then again, it could also be unrelated. I
>>>> can't be certain at this point.
>>>
>>> Can you describe what kind of radio environment you have, is it a busy
>>> office complex? How many APs around etc?
>>
>> I've tried different environments. In the office with 15-20
>> laptops/mobiles in the room I see about 10-15 APs. At home, where I
>> did long-term nightly test, there's maybe a higher number of APs, but
>> fewer devices on the channel of the AP that I used for tests.
>>
>> I haven't used any more sophisticated environments like a sealed
>> reverberation chamber yet though.
>
> Ok, but please let me know if you see any differences caused by the
> environment.
>
> --
> Kalle Valo
>
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
