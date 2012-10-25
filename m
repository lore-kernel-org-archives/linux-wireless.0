Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46185 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992530Ab2JYTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 15:45:16 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1589660wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2012 12:45:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351194222.10421.18.camel@jlt4.sipsolutions.net>
References: <1351188618-11155-1-git-send-email-javier@cozybit.com> <1351194222.10421.18.camel@jlt4.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 25 Oct 2012 12:44:54 -0700
Message-ID: <CAPjQAd-L4jJqaw7aXw6_Yi17c5-p67edQgR+=Zu2F+W=_V+T4A@mail.gmail.com> (sfid-20121025_214520_561411_4790B806)
Subject: Re: [PATCH] mac80211: Don't inspect Sequence Control field on control frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, Javier Lopez <jlopex@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 25, 2012 at 12:43 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-10-25 at 11:10 -0700, Javier Cardona wrote:
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
>
> Different question -- why check _is_ctl rather than !_is_data?

Per the Std, management frames can also be fragmented (not that I've
ever seen one).  The standard only excludes control frames.

Javier


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
