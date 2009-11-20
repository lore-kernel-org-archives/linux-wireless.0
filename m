Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:45190 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754780AbZKTV3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 16:29:17 -0500
Message-ID: <4B0708A3.3060209@free.fr>
Date: Fri, 20 Nov 2009 22:22:43 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: jmalinen@atheros.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: This patch fix RX unpadding for any received
 frame.
References: <1258665566-4212-1-git-send-email-benoit.papillault@free.fr> <43e72e890911200917m47ad6a8aje23577bf734b4952@mail.gmail.com>
In-Reply-To: <43e72e890911200917m47ad6a8aje23577bf734b4952@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Thu, Nov 19, 2009 at 1:19 PM, Benoit Papillault
> <benoit.papillault@free.fr> wrote:
>> From: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
>>
>> It has been tested with a 802.11 frame generator and by checking the FCS field
>> of each received frame with the value reported by the Atheros hardware. This
>> patch is useful if you are trying to analyze non standard 802.11 frame going
>> over the air.
> 
> Thank you for your patch! But can you please elaborate on your commit
> log entry? This just tells me that you've tested it and how its useful
> but it in no way tells me what you found was wrong and also does not
> explain how you fixed it.

Sure. I use a 802.11 frame generator that generates every value for the
first 2 bytes (frame control field) and a varying length. What was wrong
is that using ath9k and a monitor interface, I was getting frames with
padding still inside or unpadding done at the wrong position and as
such, wrong FCS. In order to fix it, I use the FCS field of received
frame and tried every position and size for unpadding. This way I found
a formula that gives me the exact position and size for proper
unpadding. I then put this formula into ath9k. This formula is different
from 802.11 hdrlen.

> 
>> Signed-off-by: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
>> ---
>>  drivers/net/wireless/ath/ath9k/common.c |   19 ++++++++++++++-----
>>  1 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
>> index 2f1e161..4a13632 100644
>> --- a/drivers/net/wireless/ath/ath9k/common.c
>> +++ b/drivers/net/wireless/ath/ath9k/common.c
>> @@ -231,26 +231,35 @@ void ath9k_cmn_rx_skb_postprocess(struct ath_common *common,
>>  {
>>        struct ath_hw *ah = common->ah;
>>        struct ieee80211_hdr *hdr;
>> -       int hdrlen, padsize;
>> +       int hdrlen, padpos, padsize;
>>        u8 keyix;
>>        __le16 fc;
>>
>>        /* see if any padding is done by the hw and remove it */
>>        hdr = (struct ieee80211_hdr *) skb->data;
>>        hdrlen = ieee80211_get_hdrlen_from_skb(skb);
>> +       padpos = 24;
>>        fc = hdr->frame_control;
>> +       if ((fc & cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) ==
>> +           cpu_to_le16(IEEE80211_FCTL_FROMDS|IEEE80211_FCTL_TODS)) {
>> +         padpos += 6; /* ETH_ALEN */
>> +       }
> 
> How about just using ETH_ALEN then?

Indeed. I was just in a hurry.

> 
>> +       if ((fc & cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FCTL_FTYPE)) ==
>> +           cpu_to_le16(IEEE80211_STYPE_QOS_DATA|IEEE80211_FTYPE_DATA)) {
>> +         padpos += 2;
>> +       }
>>
>>        /* The MAC header is padded to have 32-bit boundary if the
>>         * packet payload is non-zero. The general calculation for
>>         * padsize would take into account odd header lengths:
>> -        * padsize = (4 - hdrlen % 4) % 4; However, since only
>> +        * padsize = (4 - padpos % 4) % 4; However, since only
>>         * even-length headers are used, padding can only be 0 or 2
>>         * bytes and we can optimize this a bit. In addition, we must
>>         * not try to remove padding from short control frames that do
>>         * not have payload. */
>> -       padsize = hdrlen & 3;
>> -       if (padsize && hdrlen >= 24) {
>> -               memmove(skb->data + padsize, skb->data, hdrlen);
>> +       padsize = padpos & 3;
>> +       if (padsize && skb->len>=padpos+padsize+FCS_LEN) {
>> +               memmove(skb->data + padsize, skb->data, padpos);
>>                skb_pull(skb, padsize);
>>        }
> 
> If the skb->len would have been short ieee80211_get_hdrlen_from_skb()
> would have picked up on this and 0 would have been used for hdrlen
> therefore skipping this operation. With this patch even if skb->len
> was 0 your padsize is always based on some static value. Additionally
> its unclear to me how and why you substitute
> ieee80211_get_hdrlen_from_skb() to a static 24 + something.

The substitution is indeed the key of this patch. The check about
skb->len is to make sure that the frame is large enough to contain the
computed padding, which cannot be contained in the FCS field itself.

> 
> Also the possible static values for padpos are either (24 + 2) or (24
> + 6) right? Well these & 3 will always give true. So you are always
> padding and this changes the way this was being implemented.

It can be 24, 24+6=30, 24+2=26 or 24+6+2=28. With the &3 mask, this
gives : 0 (for 24), 2 (for 30), 2 (for 26) and 0 (for 28).

> 
> Unless I'm missing something.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Regards,
Benoit
