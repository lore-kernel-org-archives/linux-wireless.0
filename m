Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.mail-out.ovh.net ([213.251.189.42]:51779 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753561AbZK1VOo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 16:14:44 -0500
Message-ID: <4B1192C4.5010909@free.fr>
Date: Sat, 28 Nov 2009 22:14:44 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: improved ieee80211_verify_alignment
References: <1259419649-1422-1-git-send-email-benoit.papillault@free.fr> <1259421237.5428.28.camel@johannes.local>
In-Reply-To: <1259421237.5428.28.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Sat, 2009-11-28 at 15:47 +0100, Benoit Papillault wrote:
>> From: Benoit PAPILLAULT <benoit.papillault@free.fr>
>>
>> ieee80211_verify_alignment has been improved to avoid small 802.11 frame (<2
>> bytes) and skip checking for data alignment when there is no 802.11 data (when
>> the frame length is less or egal to the header length)
> 
> None of this is necessary.
> 
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -386,10 +386,23 @@ static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
>>  		      "unaligned packet at 0x%p\n", rx->skb->data))
>>  		return;
>>  
>> +	/* before using the hdr->frame_control field, we need to check that
>> +	 * skb contains at least 2 bytes */
>> +
>> +	if (rx->skb->len < 2)
>> +		return ;
>> +
> 
> Frames shorter than 16 bytes never reach this point.
> 
>>  	if (!ieee80211_is_data_present(hdr->frame_control))
>>  		return;
>>  
>>  	hdrlen = ieee80211_hdrlen(hdr->frame_control);
>> +
>> +	/* before checking data alignment, we need to check that skb contains
>> +	 * at least 1 byte of data */
>> +
>> +	if (rx->skb->len <= hdrlen)
>> +		return;
>> +
> 
> Even if this could happen it's not true -- we do not need a byte of data
> to verify that it's aligned properly. After all, even the empty string
> can be aligned -- we never actually dereference the data there.
> 
> johannes

My purpose was to make ieee80211_verify_alignment autonomous, ie without
assuming that other functions have done some checks before. I got some
problems since this function is called by
__ieee80211_rx_handle_packet(), called by ieee80211_rx() where skb can
be anything (and is anything since i'm doing injection!).

Following our discussion, I understand that :

- for the first case, frames with skb->len < 16 are already filtered out
by ieee80211_rx_monitor() when it calls should_drop_frame().

- for the second case, we don't dereference data, so we are on the safe
side. I'll further study this point since my feeling was that I got some
warning where I would not expect them. The case would be : skb->len = 24
for instance, hdrlen = 26 and skb->data aligned on a 2 bytes boundary
only. The current code would issue a warning even if no payload part is
present.

So, forget this patch for now.

Regards,
Benoit
