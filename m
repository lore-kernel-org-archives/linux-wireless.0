Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:30082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab0BHUeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 15:34:04 -0500
Received: by fg-out-1718.google.com with SMTP id e21so145229fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2010 12:34:03 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: Retry null data frame for power save.
Date: Mon, 8 Feb 2010 21:30:09 +0100
Cc: Vivek Natarajan <vivek.natraj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, IvDoorn@gmail.com,
	gwingerde@gmail.com
References: <1265631421-2574-1-git-send-email-vnatarajan@atheros.com> <8e92b4101002080513n788ef64erb33baef2393b0d54@mail.gmail.com> <1265646279.3783.8.camel@johannes.berg>
In-Reply-To: <1265646279.3783.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002082130.10238.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2010 17:24:39 Johannes Berg wrote:
> On Mon, 2010-02-08 at 18:43 +0530, Vivek Natarajan wrote:
> 
> > > On a related issue: What about _inverting_ the flag, so it will
> > > be set for devices which can't give any accurate tx_status
> > > information. This has the advantage that we don't have to touch
> > > other drivers?
> > 
> > Shall I rename it as HW_NO_TX_ACK_REPORT?
> > Looking at the other flags, they show some positively present
> > feature in the hw. In those lines, HW_REPORTS_TX_ACK_STATUS
> > might be better.
> 
> The positive feature flag has the advantage that we don't have to touch
> any of the essentially unmaintained drivers, so I much prefer having it
> that way so maintainers can enable the flag after testing etc.

Alright. I count 2:1 votes. So "positive feature flag" it is.

BTW: I added rt2x00 project maintainers to the CC, because
If I'm not totally wrong, this patch _reduces_ some PS
features of rt2x00. This is because not all of rt2x00
supported & PS-capable/enabled devices return a proper tx_status
and therefore these devices will be the most affected AFAICT.

Any word from you guys? Or have you scrubbed the PS features already?

Regards,
	Chr
