Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59373 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab1CXHix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 03:38:53 -0400
Received: by bwz15 with SMTP id 15so7283044bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 00:38:51 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
Date: Thu, 24 Mar 2011 08:36:45 +0100
Cc: users@rt2x00.serialmonkey.com, Jay Hung <Jay_Hung@ralinktech.com>,
	Eddy Tsai <Eddy_Tsai@ralinktech.com>,
	linux-wireless@vger.kernel.org
References: <201103232358.29966.helmut.schaa@googlemail.com> <AANLkTi=BLTJhxYf552GLW1zG-AvVdeKj86e2K-vEm_Wy@mail.gmail.com>
In-Reply-To: <AANLkTi=BLTJhxYf552GLW1zG-AvVdeKj86e2K-vEm_Wy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103240836.45753.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 24. März 2011 schrieb Emmanuel Grumbach:
> > According to 802.11n-2009 the BA originator could send a BlockAckReq if
> > an AMPDU is not BlockAcked in time. However, I never see the hw sending a
> > BlockAckReq.
> >
> 
> Not sending BAR (BlockAckReq) can be quite problematic. The originator
> needs to send BAR to tell the recipient that the frames that are
> pending in the reordering buffer can be released to the upper level
> even if there are holes in the packet sequence. Not sending BAR could
> in theory lead to deadlock. In practice, most implementations of
> reordering buffers release frames out of order after timeout.

Thanks for the clarification. However 802.11n-2009 doesn't seem to require
a BA originator to send an BlockAckReq in that case:

Page 173, 9.10.7.7:

"The originator may send a BlockAckReq for non-Protected Block Ack agreement or a Robust Management
ADDBA frame for Protected Block Ack agreement when a data MPDU that was previously transmitted
within an A-MPDU that had the Ack Policy field set to Normal Ack is discarded due to exhausted MSDU
lifetime. The purpose of this BlockAckReq is to shift the recipient’s WinStartB value past the hole in the
sequence number space that is created by the discarded data MPDU and thereby to allow the earliest
possible passing of buffered frames up to the next MAC process."

But I agree, it makes totally sense to do so if a AMPDU subframe failed and
that's what I've tried by using IEEE80211_TX_STAT_AMPDU_NO_BACK.

> taken from rx.c of mac80211:
> /*
>  * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
>  * the skb was added to the buffer longer than this time ago, the earlier
>  * frames that have not yet been received are assumed to be lost and the skb
>  * can be released for processing. This may also release other skb's from the
>  * reorder buffer if there are no additional gaps between the frames.
>  *
>  * Callers must hold tid_agg_rx->reorder_lock.
>  */
> #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
> 
> I am quite surprised that you see that frames are "stuck in the
> driver". This would mean that the windows drivers's implementation of
> the reordering buffer doesn't have timer... or I miss something...

I don't know what the Windows driver is doing but it _looks_ as if it doesn't
release the frames with a timeout. I also tried to completely disable TX
aggregation on the rt2800 AP and that made the connection stable. Hence my
assumption that the frames are stuck somewhere in the reorder buffer. More
details below ...

> > At least, I hacked rt2x00 to set IEEE80211_TX_STAT_AMPDU_NO_BACK for failed
> > aggregated frames such that mac80211 sends a BlockAckReq for this failed MPDU
> > and this indeed seems to improve the situation but doesn't fix it completely.
> 
> Can you please be more specific by "improve situation" ? better TPT ?
> lower packet loss ?
> What do you mean by not fixed completely ?
> Do you track packets out of the driver ?

That's what I'm doing on the Intel machine:
- Associate the Intel 5100 Windows STA with the rt2800pci AP
- Start a ping from the Intel STA to a station on the LAN
- Run iperf between the Intel STA and a different station on the LAN attached
  to the AP (the direction doesn't matter that much as long as iperf is 
  running in TCP mode and thus frames are sent in both directions)

And that's what I observe:

It takes just a few seconds and iperf will stop printing stats and the
concurrently running ping always times out. Sniffing the traffic with a
different wifi STA I can see the pings (Intel -> AP -> lan station) on the
air and the reponse (lan station -> AP -> Intel) as well, and the reponse
also gets BlockAcked by the Intel STA but the user space ping process never
gets the ping response and still only prints timeouts. So, I can only observe
that the ping response is correctly send over the air by the rt2800 AP and the
Intel STA seems to correctly receive it but doesn't pass it to the user space.
Stopping all traffic now will lead to the BA session (AP -> STA) being teared
down (after a few seconds) and afterwards I can start to ping again.

After adding the code to issue BARs when a AMPDU subframe failed, the issue
seems to not happen anymore. However, in some rare cases it happened again and
the Intel STA wasn't able to "receive" anything anymore (for example it still
happenend after running an iperf for ~150 seconds instead of just a few seconds
as before).

At least I'll first submit a patch to pass IEEE80211_TX_STAT_AMPDU_NO_BACK to
mac80211 in case of a failed AMPDU subframe. And the remaining issue might be
due to a different bug.

Thanks,
Helmut
