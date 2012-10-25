Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54582 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935009Ab2JYTNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:13:17 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so6323405wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 12:13:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351191838.10421.15.camel@jlt4.sipsolutions.net>
References: <1351188618-11155-1-git-send-email-javier@cozybit.com> <1351191838.10421.15.camel@jlt4.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Oct 2012 12:12:55 -0700
Message-ID: <CAPjQAd9T5Ju3aEE1HeWT_5zLjW+rPQWkGQbh5Km9E1XunyFB9A@mail.gmail.com> (sfid-20121025_211320_765235_4E20CB0F)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on control frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, Oct 25, 2012 at 12:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-10-25 at 11:10 -0700, Javier Cardona wrote:
>> Per IEEE Std. 802.11-2012, Sec 8.2.4.4.1, the sequence Control field is
>> not present in control frames.  We noticed this problem when processing
>> Block Ack Requests.
>>
>
> Cc stable?

Sure.

>>       hdr = (struct ieee80211_hdr *)rx->skb->data;
>>       fc = hdr->frame_control;
>> +
>> +     if (ieee80211_is_ctl(fc))
>> +             return RX_CONTINUE;
>
> Shouldn't that be "goto out"?

If we goto out, we'll increment the rx_packets counter, which
according to sta_info.h should only count MSDUs.

> And it seems it should also incorporate the skb->len check here, rather than accessing the field before checking
> that it's present?

ieee80211_rx_h_check() zaps all skbs with len < 16, so I don't think
it's needed, no?

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
