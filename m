Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58253 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1BDJR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 04:17:29 -0500
Received: by wwa36 with SMTP id 36so2133636wwa.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 01:17:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19787.47298.50879.401166@gargle.gargle.HOWL>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<19787.47298.50879.401166@gargle.gargle.HOWL>
Date: Fri, 4 Feb 2011 14:47:27 +0530
Message-ID: <AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Sujith <m.sujith@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 4, 2011 at 1:58 PM, Sujith <m.sujith@gmail.com> wrote:
> Vivek Natarajan wrote:
>> In a highly noisy environment, a data frame which is queued before
>> a nullfunc frame on a different hw queue may be sent over the air
>> after the tx completion of nullfunc frame. This causes the station
>> to enter power save and the AP to see the station as awake and
>> continues to send the data traffic. Fix this by draining all tx
>> queues before we send the null function frame with PM bit set.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/xmit.c |   10 +++++++++-
>>  1 files changed, 9 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>> index 68a1c76..0cb6017 100644
>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>> @@ -1710,7 +1710,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
>>                           bf->bf_buf_addr,
>>                           txq->axq_qnum);
>>
>> -
>>       return bf;
>>  }
>>
>> @@ -1813,6 +1812,15 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
>>       if (unlikely(!bf))
>>               return -ENOMEM;
>>
>> +     if (ieee80211_is_nullfunc(hdr->frame_control) &&
>> +         ieee80211_has_pm(hdr->frame_control)) {
>> +             /* Drain all the pending frames before we send a nullfunc frame
>> +              * to avoid any power save state mismatch between the station
>> +              * and the AP.
>> +              */
>> +             ath_drain_all_txq(sc, false);
>> +     }
>> +
>
> There is a comment about the caller waking queues up properly in ath_drain_all_txq(),
> I don't think that requirement is handled properly.

So, will it be appropriate to add stop and wake queue while calling
ath_drain_all_txq?

> Also, mac80211's flush() callback exists precisely for this purpose.

Currently, flush() is called only when mac80211 is moving to off
channel. Even if we call flush before sending nullfunc frame for power
save, a question arises if it should be done with drop = true or
false.  If set as false, there is a possibility that the frames might
be still around in the hw when nullfunc is sent and the same issue
might pop up.
Drop is set as false for scanning. iwlwifi waits for 2sec for all the
packets to complete but for ath9k, since it is asynchronous, I am not
quite sure of how to wait for tx_completion of all pending packets.

> I think it would be better to use that rather than adding a check for every packet.

We were considering yet another approach too:
In this case, if a nullfunc frame for PS comes to the driver when
there are pending frames in the hw queue(the frames queued before
100ms and still pending because of highly noisy environment), silently
drop the frame so that mac80211 will try once again after 100ms to go
to PS. The issue that I face here is, ath9k does not know whether this
frame is actually for PS or for fake sleep before scanning.

Vivek.
