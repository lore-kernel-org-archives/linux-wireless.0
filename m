Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:36538 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0BHVCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:02:35 -0500
Received: by fxm7 with SMTP id 7so286097fxm.28
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 13:02:33 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
Date: Mon, 8 Feb 2010 22:02:23 +0100
Cc: Vivek Natarajan <vivek.natraj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, IvDoorn@gmail.com,
	gwingerde@gmail.com
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com> <1265646279.3783.8.camel@johannes.berg> <201002082130.10238.chunkeey@googlemail.com>
In-Reply-To: <201002082130.10238.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002082202.24297.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2010 21:30:09 Christian Lamparter wrote:
> On Monday 08 February 2010 17:24:39 Johannes Berg wrote:
> > On Mon, 2010-02-08 at 18:43 +0530, Vivek Natarajan wrote:
> > 
> > > > On a related issue: What about _inverting_ the flag, so it will
> > > > be set for devices which can't give any accurate tx_status
> > > > information. This has the advantage that we don't have to touch
> > > > other drivers?
> > > 
> > > Shall I rename it as HW_NO_TX_ACK_REPORT?
> > > Looking at the other flags, they show some positively present
> > > feature in the hw. In those lines, HW_REPORTS_TX_ACK_STATUS
> > > might be better.
> > 
> > The positive feature flag has the advantage that we don't have to touch
> > any of the essentially unmaintained drivers, so I much prefer having it
> > that way so maintainers can enable the flag after testing etc.
>
> BTW: I added rt2x00 project maintainers to the CC, because
> If I'm not totally wrong, this patch _reduces_ some PS
> features of rt2x00. This is because not all of rt2x00
> supported & PS-capable/enabled devices return a proper tx_status
> and therefore these devices will be the most affected AFAICT.
> 
> Any word from you guys? Or have you scrubbed the PS features already?
>

Oops,

Johannes pointed out that the patch does not break rt2x00.
and indeed ... he IS right and I misread the check !HW_STATUS_CHECK
in ieee80211_enable_ps.

Sorry for all the noise!
