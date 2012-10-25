Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36625 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965132Ab2JYTEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:04:04 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so6314293wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 12:04:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201210252048.34083.chunkeey@googlemail.com>
References: <1351188618-11155-1-git-send-email-javier@cozybit.com> <201210252048.34083.chunkeey@googlemail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Oct 2012 12:03:42 -0700
Message-ID: <CAPjQAd8+7oD8jJ-u_BF94SvRhxY83XdxHcR-0huWT9b-EgNuFg@mail.gmail.com> (sfid-20121025_210410_127527_6B392F3C)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on control frames
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian,

On Thu, Oct 25, 2012 at 11:48 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Thursday, October 25, 2012 08:10:18 PM Javier Cardona wrote:
>> Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
>> not present in control frames.  We noticed this problem when processing
>> Block Ack Requests.
>>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> Signed-off-by: Javier Lopez <jlopex@cozybit.com>
>> ---
>>  net/mac80211/rx.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index f975f64..bf54336 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1467,6 +1467,10 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
>>
>>       hdr = (struct ieee80211_hdr *)rx->skb->data;
>>       fc = hdr->frame_control;
>> +
>> +     if (ieee80211_is_ctl(fc))
>> +             return RX_CONTINUE;
>> +
>>       sc = le16_to_cpu(hdr->seq_ctrl);
>>       frag = sc & IEEE80211_SCTL_FRAG;
>>
> hmm, I see this function also calls skb_linearize() on said
> skb... Does anybody know of any possible side effects? Not
> that control frames (In fact, just BlockACK Requests come
> to my mind) usually so large...

skb_linearize() is only called on fragmented frames, which is how
regular BlockAckRequests were being processed before.
We are setting new flags introduced in 11aa, which is what caused
these new BARs to be mistakenly processed as fragments.

With our patch "regular" BARs (which are the only type of control
frames that hit mac80211) continue to be processed in the same way.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
