Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60348 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab2CJOTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Mar 2012 09:19:00 -0500
Received: by vcqp1 with SMTP id p1so2448493vcq.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Mar 2012 06:18:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F5B5A15.1000808@neratec.com>
References: <1331340008-1713-1-git-send-email-ashok@cozybit.com>
	<201203100206.46537.chunkeey@googlemail.com>
	<4F5B5A15.1000808@neratec.com>
Date: Sat, 10 Mar 2012 19:48:59 +0530
Message-ID: <CAD2nsn3zjFkvdHQaokSpzrZeA_qK2j+U_rUtx0ywz+1o_x8=xw@mail.gmail.com> (sfid-20120310_151904_688681_A8AD6F98)
Subject: Re: [PATCH] ath9k: Fix mactime from being clobbered in rx_status
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Ashok Nagarajan <ashok@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 10, 2012 at 7:11 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> Thanks for the ping.
>
> The patch that is reverted here was meant as pre-work for modifications
> required to generate DFS events with correctly set mactime that are still
> pending. It was obviously not as 'trivial' as claimed, since I overlooked
> the memset() in ath9k_rx_skb_preprocess() that effectively set the time to 0
> for all fragments.
>
> Therefore full ACK to revert it. Just wondering why it was not noticed for
> nearly 4 months now.

blame me, i also missed the memset in ath9k_rx_skb_preprocess. also we
missed quite a few of patches that caused some other regression and
they were missed

>
>
> On 10.03.2012 02:06, Christian Lamparter wrote:
>>
>> On Saturday 10 March 2012 01:40:08 Ashok Nagarajan wrote:
>>>
>>> mactime was being overwritten by the function
>>> ath9k_rx_skb_preprocess.  Fixed by calling the
>>> function before setting the mactime.
>>
>>
>> This looks rather odd... In essence you're trying to revert
>> "ath9k: trivial: reorder rx_tasklet processing"
>>
>> Anyway, I 'CC'ed the original author Zefir Kurtisi. So if
>> there are any open question, now is the time.
>>
>>> Signed-off-by: Ashok Nagarajan<ashok@cozybit.com>
>>> Signed-off-by: Javier Cardona<javier@cozybit.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/recv.c |    5 +++--
>>>  1 files changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c
>>> b/drivers/net/wireless/ath/ath9k/recv.c
>>> index 1b1b279..52a0466 100644
>>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>>> @@ -1841,6 +1841,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush,
>>> bool hp)
>>>                if (sc->sc_flags&  SC_OP_RXFLUSH)
>>>
>>>                        goto requeue_drop_frag;
>>>
>>> +               retval = ath9k_rx_skb_preprocess(common, hw, hdr,&rs,
>>> +                                                rxs,&decrypt_error);
>>> +
>>
>>
>> Instead of moving ath9k_rx_skb_preprocess around, you could just
>> put the memset(rx_status, 0, sizeof(struct ieee80211_rx_status));
>> right here.
>>
>> [Also, why leave the if (retval) check behind?]
>>
>>>                rxs->mactime = (tsf&  ~0xffffffffULL) | rs.rs_tstamp;
>>>                if (rs.rs_tstamp>  tsf_lower&&
>>>                unlikely(rs.rs_tstamp - tsf_lower>  0x10000000))
>>> @@ -1850,8 +1853,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush,
>>> bool hp)
>>>                    unlikely(tsf_lower - rs.rs_tstamp>  0x10000000))
>>>                        rxs->mactime += 0x100000000ULL;
>>>
>>> -               retval = ath9k_rx_skb_preprocess(common, hw, hdr,&rs,
>>> -                                                rxs,&decrypt_error);
>>>                if (retval)
>>>                        goto requeue_drop_frag;
>>
>>                ^^ that one
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
thanks,
shafi
