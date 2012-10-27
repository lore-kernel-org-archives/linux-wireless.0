Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41568 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2J0IX6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2012 04:23:58 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2409139pad.19
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2012 01:23:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351001506.18024.72.camel@jana.tkn.tu-berlin.de>
References: <1351001506.18024.72.camel@jana.tkn.tu-berlin.de>
Date: Sat, 27 Oct 2012 01:23:57 -0700
Message-ID: <CAJ-Vmo=KvjNX49hgZTtF_LTtn-KKWRJMc28AT+YKo3E=EWUDxg@mail.gmail.com> (sfid-20121027_102410_867839_C71DDFD7)
Subject: Re: Problem: AR5212 - sequence numbers in skb and on air do not match.
From: Adrian Chadd <adrian@freebsd.org>
To: Uwe Bergemann <mail@uwe.bergemann.name>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erm in FreeBSD the non-qos data frames get a sequence number from the
non-QoS "TID", which is TID 16 in FreeBSD.

Are you sure mac80211 doesn't do seqno assignment at all for non-qos
data frames? If so, maybe it should?



adrian

On 23 October 2012 07:11, Uwe Bergemann <mail@uwe.bergemann.name> wrote:
> Hello everybody,
>
> this is my first post to this list and I hope to be right here
>
> I need to obtain the sequence numbers of (mainly, but not only qos/data)
> frames that have been sent at mac80211 level (more precisely:  at the
> rate control module).
>
> Using a Hainan (AR5213A) I see different sequence numbers in the mac
> header (socket buffer, skb) and on the air (using a sniffer running
> wireshark).  The hardware seems to use its own counters only.
>
> Two possible solutions to this problem come to my mind:
> - if switching off h/w-assignment of seq nums is possible,  do
> everything in mac80211.
> - read the h/w-assigned seq num from registers and write them into the
> mac header,  which is then returned to mac80211.
>
> Any advice on this topic is appreciated.
> Thank you in advance
> Uwe Bergemann
>
>
>
> So far I have looked around here:
>
> mainly from mac80211/tx.c:
> - mac80211 claims that it can generate sequence numbers (seq num) only
> for qos/data frames.
> - It maintains one counter per STA and TID for this purpose and writes
> the correct value into the mac header.
> - All other frames are numbered by a global sequence counter ( delegated
> to the driver by setting the IEEE80211_TX_CTL_ASSIGN_SEQ flag).
>
> so qos/data is handled by mac80211,  all other is delegated to the
> driver.
>
> ath5k/reset.c:
> - On other h/w versions than AR5210, seq num and tsf counters are saved
> over a reset.
> - For mac revisions after Oahu (AR5211) only the global seq num counter
> (0) exists, earlier revisions have 10 seq num counters (one per queue).
>
> I use a Hainan (AR5213A), thus having only one (global) counter,  which
> is perfectly ok for mac80211.
>
> from observations (wireshark sniffer):
> - different qos classes are used,  so I believe that different queues
> are used.
> - frames are numbered w/o regard to qos class,  only the global counter
> seems to be is used.
> - sequence numbers are always assigned by hardware,  not regarding if
> IEEE80211_TX_CTL_ASSIGN_SEQ is set or not.
> - the h/w assigned sequence number is not written to the mac header/skb.
> After transmission,  the mac80211 sequence numbers are printed if
> tracing is switched on,  not showing what was actually 'aired'.
>
> The problem seems to be kind of the opposite of
>>
> http://lists.freebsd.org/pipermail/freebsd-wireless/2011-August/000473.html
> where no correct sequence numbers are set on beacon frames, since the
> AR5416 in this case does not assign sequence numbers by itself.
>
> Later in this thread, Adrian Chadd describes how h/w seq num assignment
> is switched off for the AR5416:
>> AR5416:
>>
>> * D_MISC for each DCU, bit 20: Sequence number increment disable; resets to 0x0.
>> * MAC_PCU_STA_ADDR_U16 - (0x8004) bit 29: REG_PRESERVE_SEQNUM: Stops
>> PCU from replacing the sequence number
>>
>> AR5212:
>>
>> * D_MISC: same deal: bit 20 - SEQNUMINCDIS
>> * same deal with MAC_PCU_STA_ADDR_U16 above: bit 29
>>
>> 30 seconds with the HAL has shown what's going on:
>>
>> ar5416Reset():
>>
>>         /*
>>          * disable seq number generation in hw
>>          */
>>          OS_REG_WRITE(ah, AR_STA_ID1,
>>              OS_REG_READ(ah, AR_STA_ID1) | AR_STA_ID1_PRESERVE_SEQNUM);
>>
>> That bit isn't set for the AR5212.
>>
>> Try disabling that, see if it works on the AR5416.
>
> To me this looks like h/w-controlled assignment of sequence numbers can
> be switched off globally (on an AR5212),  but I doubt this can be done
> on a per-frame basis only for qos/data frames.  All sequence numbers
> then would have to be assigned by mac80211.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
