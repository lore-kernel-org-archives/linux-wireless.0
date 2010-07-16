Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48902 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0GPSRR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 14:17:17 -0400
Received: by bwz1 with SMTP id 1so1372993bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jul 2010 11:17:15 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [RFC] mac80211: indicate BA window size with IEEE80211_AMPDU_TX_OPERATIONAL drv_ampud_action
Date: Fri, 16 Jul 2010 20:16:35 +0200
Cc: yogeshp <yogeshp@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4C3F0AA3.4050706@marvell.com> <4C402360.5050502@marvell.com> <AANLkTim2fLLZfD5xrUtioY5mZaF-PgLwrVlMHQHwsL41@mail.gmail.com>
In-Reply-To: <AANLkTim2fLLZfD5xrUtioY5mZaF-PgLwrVlMHQHwsL41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007162016.35442.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag 16 Juli 2010 schrieb Luis R. Rodriguez:
> On Fri, Jul 16, 2010 at 2:16 AM, yogeshp <yogeshp@marvell.com> wrote:
> > Hi Luis,
> >  Please see inline comments
> >
> > Luis R. Rodriguez wrote:
> >> On Thu, Jul 15, 2010 at 6:18 AM, yogeshp <yogeshp@marvell.com> wrote:
> >>> BA window size for a successful BA setup is not made available to the driver by
> >>> mac80211. The patch below gets the BA window size from addba response and
> >>> indicates it to driver through IEEE80211_AMPDU_TX_OPERATIONAL drv_ampdu_action.
> >
> >> But why do you want that? Your patch and commit log do not mention why
> >> you need this.
> > BA window size from ADDBA response defines how many outstanding MPDUs are allowed for the BA stream by recipient. Since ADDBA response is processed in mac80211 stack, mac80211 should communicate the BA window size to driver (and may be from driver it is further communicated to firmware/hardware) to control the number of outstanding MPDUs while transmitting MPDUs for the stream.
> 
> What driver requires this? Your patch does all these changes but do
> not show any secondary patch of a user, so the patch is pointless
> right now.

JFI, rt2800 would also need the BA windows size in its tx path (not only once
but in every tx descriptor). So maybe it would even make sense to move it to
the ieee80211_sta structure? That way rt2800 could also benefit from that
change.

Using the approach as implemented in this patch we would have to store the
value for each STA on our own in rt2x00 although mac80211 has it already
in its own structures.

Just my 2 cents ...
Helmut
