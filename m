Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44635 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbdKTRFD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 12:05:03 -0500
Received: by mail-wr0-f196.google.com with SMTP id l22so8697631wrc.11
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 09:05:02 -0800 (PST)
From: Christian Lamparter <chunkeey@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix recent bandwidth conversion bug
Date: Mon, 20 Nov 2017 18:05:00 +0100
Message-ID: <1882220.dvZB77Gu54@debian64> (sfid-20171120_180507_169701_C34787A1)
In-Reply-To: <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com>
References: <20171101200157.27096-1-chunkeey@gmail.com> <1666282.PC3nhpCf9f@debian64> <87tvxpf9i8.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 20, 2017 11:57:21 AM CET Kalle Valo wrote:
> Christian Lamparter <chunkeey@gmail.com> writes:
> 
> > On Wednesday, November 1, 2017 9:37:53 PM CET Sebastian Gottschall wrote:
> >> a additional array bounds check would be good
> >
> > Ah, about that:
> >
> > the bw variable in ath10k_htt_rx_h_rates() is extracted from info2
> > in the following way [0]:
> > |	bw = info2 & 3;
> >
> > the txrate.bw variable in ath10k_update_per_peer_tx_stats() is set by [1]:
> > |	txrate.bw = ATH10K_HW_BW(peer_stats->flags);
> >
> > ATH10K_HW_BW is a macro defined as [2]:
> > |	#define ATH10K_HW_BW(flags)		(((flags) >> 3) & 0x3)
> >
> > In both cases the bandwidth values already are limited to 0-3 by
> > the "and 3" operation.
> 
> Until someone changes that part of the code (and the firmware
> interface). IMHO a switch is safer as there we don't have any risk of
> out of bands access.

The kbuild-bot/CI can catch this too. 

For example, it will look like this:
drivers/net/wireless/ath/ath10k//htt_rx.c:710:52: warning: invalid access past the end of 'ath10k_bw_to_mac80211' (4 4)

BTW:
Have you noticed:

<https://github.com/lede-project/source/blob/master/package/kernel/mac80211/patches/319-ath10k-fix-recent-bandwidth-conversion-bug.patch>

Is this really your signed-off-by or not?

In any case, you - as the maintainer - can modify the patch as
you see fit. So, please do so.
