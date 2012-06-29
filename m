Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:57314 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812Ab2F2FAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 01:00:55 -0400
Message-ID: <4FED3679.4080107@net.t-labs.tu-berlin.de> (sfid-20120629_070058_540505_9275CBBE)
Date: Thu, 28 Jun 2012 22:00:41 -0700
From: thomas <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@openwrt.org
Subject: Re: [PATCH] mac80211: correct size the argument to kzalloc in minstrel_ht
References: <1340926085-54416-1-git-send-email-thomas@net.t-labs.tu-berlin.de> <CAGRGNgXCoQNYbs7MVtEsDdoPUgvV+JDP28tCbKWG2cBHcJ60kQ@mail.gmail.com>
In-Reply-To: <CAGRGNgXCoQNYbs7MVtEsDdoPUgvV+JDP28tCbKWG2cBHcJ60kQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

Compiler wise both of our suggestions will lead to the same machine code.
So beside the matter of taste, I just followed the other overall usage
pattern of kzalloc in minstrel_ht.
And it seems to be explicitly using the struct type.

Bye Thomas

Julian Calaby schrieb:
> Hi Thomas,
>
> On Fri, Jun 29, 2012 at 9:28 AM, Thomas Huehn
> <thomas@net.t-labs.tu-berlin.de> wrote:
>> msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.
>>
>> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
>> ---
>>  net/mac80211/rc80211_minstrel_ht.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
>> index 2d1acc6..dc2b801 100644
>> --- a/net/mac80211/rc80211_minstrel_ht.c
>> +++ b/net/mac80211/rc80211_minstrel_ht.c
>> @@ -809,7 +809,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
>>                        max_rates = sband->n_bitrates;
>>        }
>>
>> -       msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
>> +       msp = kzalloc(sizeof(struct minstrel_ht_sta_priv), gfp);
>
> Why not use sizeof(*msp)?
>
> Thanks,
>
