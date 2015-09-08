Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:15783 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746AbbIHB2t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 21:28:49 -0400
From: David Lin <dlin@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chor Teck Law" <ctlaw@marvell.com>
Subject: RE: [PATCH v6] Add new mac80211 driver mwlwifi.
Date: Tue, 8 Sep 2015 01:28:44 +0000
Message-ID: <8b2f365955774ddea9d6e99c40c8a892@SC-EXCH02.marvell.com> (sfid-20150908_032852_167400_93CD9541)
References: <20456de5ab0b43b69441b19abb282c31@SC-EXCH02.marvell.com>
 <87zj0yb7rt.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zj0yb7rt.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Kalle Valo [mailto:kvalo@codeaurora.org] writes:
> 
> David Lin <dlin@marvell.com> writes:
> 
> > The Linux driver for WRT1900AC. The work was initially developed as
> > part of openwrt effort and maintained on https://github.com/kaloz/mwlwifi.
> >
> > This is still work in progress, with 8864 chipset more mature and
> > tested, while 8897 for the similar use case is added recently.
> >
> > Signed-off-by: David Lin <dlin@marvell.com>
> 
> The commit log is really short. For a new driver you should explain a lot more,
> for example what works and what doesn't. Also it should contained detailed
> info about how and why (!) this conflicts with mwifiex and the way that
> problem was solved.
> 
> Also no new BUG_ON() calls in drivers, please:
> 
> fwcmd.c:        BUG_ON(tid >= SYSADPT_MAX_TID);
> mac80211.c:     BUG_ON(queue > SYSADPT_TX_WMM_QUEUES - 1);
> mac80211.c:             BUG_ON(stream->state !=
> AMPDU_STREAM_IN_PROGRESS);
> tx.c:   BUG_ON(tid > 7);
> tx.c:   BUG_ON(tid >= SYSADPT_MAX_TID);
> tx.c:   BUG_ON(!tx_skb);
> 
> We should start to get rid of all 200+ calls we already have, wireless drivers
> should never call BUG_ON(). Instead use descriptive error message
> (WARN_ON() etc) and bail out nicely with an error. That's much more user
> friendly than crashing the kernel.
> 
> --
> Kalle Valo

I will change BUG_ON() to WARN_ON() for next patch.

Thanks,
David
