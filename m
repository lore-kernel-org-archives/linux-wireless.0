Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33300 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1CXGux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 02:50:53 -0400
Received: by vws1 with SMTP id 1so6253012vws.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 23:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103232358.29966.helmut.schaa@googlemail.com>
References: <201103232358.29966.helmut.schaa@googlemail.com>
Date: Thu, 24 Mar 2011 08:50:52 +0200
Message-ID: <AANLkTi=BLTJhxYf552GLW1zG-AvVdeKj86e2K-vEm_Wy@mail.gmail.com>
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: users@rt2x00.serialmonkey.com, Jay Hung <Jay_Hung@ralinktech.com>,
	Eddy Tsai <Eddy_Tsai@ralinktech.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> According to 802.11n-2009 the BA originator could send a BlockAckReq if
> an AMPDU is not BlockAcked in time. However, I never see the hw sending a
> BlockAckReq.
>

Not sending BAR (BlockAckReq) can be quite problematic. The originator
needs to send BAR to tell the recipient that the frames that are
pending in the reordering buffer can be released to the upper level
even if there are holes in the packet sequence. Not sending BAR could
in theory lead to deadlock. In practice, most implementations of
reordering buffers release frames out of order after timeout.

taken from rx.c of mac80211:
/*
 * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
 * the skb was added to the buffer longer than this time ago, the earlier
 * frames that have not yet been received are assumed to be lost and the skb
 * can be released for processing. This may also release other skb's from the
 * reorder buffer if there are no additional gaps between the frames.
 *
 * Callers must hold tid_agg_rx->reorder_lock.
 */
#define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)

I am quite surprised that you see that frames are "stuck in the
driver". This would mean that the windows drivers's implementation of
the reordering buffer doesn't have timer... or I miss something...

> At least, I hacked rt2x00 to set IEEE80211_TX_STAT_AMPDU_NO_BACK for failed
> aggregated frames such that mac80211 sends a BlockAckReq for this failed MPDU
> and this indeed seems to improve the situation but doesn't fix it completely.

Can you please be more specific by "improve situation" ? better TPT ?
lower packet loss ?
What do you mean by not fixed completely ?
Do you track packets out of the driver ?
