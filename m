Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:33789 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbbFIXQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 19:16:53 -0400
Received: by yhpn97 with SMTP id n97so13611931yhp.0
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jun 2015 16:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ae0dc14a0cf7a0d8008a49dd6b2376f@mail.gmail.com>
References: <CAEFj986CCryd1fK6NpoQYOmCiu+KRjq8RsSgvWqQOvLBPvFoeg@mail.gmail.com>
	<CAEFj987VjaQpwx2VMxYeH7TWcKVvjN6hSRsqTSbSXa1ZammezQ@mail.gmail.com>
	<3ae0dc14a0cf7a0d8008a49dd6b2376f@mail.gmail.com>
Date: Tue, 9 Jun 2015 16:16:53 -0700
Message-ID: <CAAnMG+P8S-gUVZhdaGj2Yyqkmp_EYE8Ce=HOjnwEncfswFORCA@mail.gmail.com> (sfid-20150610_011658_147750_01080972)
Subject: Re: [PATCH] mac80211: Fix a case of incorrect metric used when
 forwarding a PREQ
From: Alexis Green <agreen@cococorp.com>
To: yeohchunyeow@gmail.com, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resubmitting as v2 due to mangled white spaces.

On Mon, Jun 8, 2015 at 10:28 AM, Jesse Jones <jjones@cococorp.com> wrote:
> I took a look at the spec too and also didn't see mention of the MP_F_RF
> flag. Section 13.10.9.3 for example talks about PREQ handling and in case E2
> talks about sending replies back. It says to do that if target only is not
> set which makes sense: MP_F_RF and MP_F_DO are exclusive options so it's
> silly to use two different flags for them.
>
> But for the purposes of this patch that is a moot issue: the semantics of
> the function don't change and the original code was both confusing and using
> the wrong value for metric for the not target only, intermediate station
> case.
>
>   -- Jesse
>
> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Yeoh Chun-Yeow
> Sent: Monday, June 08, 2015 1:55 AM
> To: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] mac80211: Fix a case of incorrect metric used when
> forwarding a PREQ
>
> As mentioned in Section 13.10.9.3 Case E2, the PREQ forwarding should use
> metric "as received + own metric toward transmitter of received PREQ". So
> you are right.
>
> Just MP_F_RF bit is no longer use. After replying with PREP, forwarding the
> PREQ by setting the IEEE80211_PREQ_TO_FLAG in the per target flags.
>
> ---
> Chun-Yeow
>
> On Mon, Jun 8, 2015 at 4:07 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
> wrote:
>> Hi, Alexis Green
>>
>> I just take a look back on the code before implementing the Proactive
>> PREQ for PREP. For the case of reply and forward (target_flags &
>> MP_F_RF), the previous metric used is the one which resolved from
>> mpath->metric.
>>
>> Refer here:
>> https://github.com/o11s/open80211s/blob/o11s-0.4.2/net/mac80211/mesh_h
>> wmp.c
>>
>> But to say that, I cannpt confirm whether this is correct. The
>> standard 802.11-2012 has no longer specified bit-1 MP_F_RF (Refer
>> section 8.4.2.115 per target flag). So maybe it is not relevant
>> anymore. We may need to remove as well.
>>
>> ----
>> Chun-Yeow
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
