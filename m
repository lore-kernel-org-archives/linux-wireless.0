Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53486 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0KPQnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:43:10 -0500
Received: by eye27 with SMTP id 27so416356eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 08:43:08 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Date: Tue, 16 Nov 2010 17:42:08 +0100
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131911.47346.IvDoorn@gmail.com> <201011161711.51581.helmut.schaa@googlemail.com> <20101116163434.GA29414@sig21.net>
In-Reply-To: <20101116163434.GA29414@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161742.08503.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> On Tue, Nov 16, 2010 at 05:11:51PM +0100, Helmut Schaa wrote:
> > Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> > > 
> > > I wonder why it is using TX queue 2?  Isn't this QID_AC_VI, i.e.
> > > it should only be used when some programs uses setsockopt SO_PRIORITY
> > > to request QoS for video data?
> > > 
> > > 
> > > Lokking through the code, in rt2x00mac_tx():
> > > 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
> > > is passed to rt2x00queue_get_queue() which uses
> > > enum data_queue_qid has 2 == QID_AC_VI, but net/core/dev.c dev_pick_tx()
> > > calls skb_set_queue_mapping() with 2 == BE
> > > (from ieee802_1d_to_ac, return by ieee80211_netdev_select_queue())
> > > 
> > > Maybe I'm just confused?
> > 
> > Yep, it is indeed confusing. If you compiled rt2x00 with debug output have a
> > look at the queue setup in dmesg:
> > 
> > [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
> > [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
> > [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
> > [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
> > 
> > As you can see queue 2 gets the parameters for AC_BE assigned whereas queue 0
> > gets AC_VO assigned. So the naming within rt2x00 is not consitent with the
> > numbering within mac80211. However, since we configure the queue parameters
> > this should really just be a naming issue.
> 
> Hm, yes, rt2x00mac_conf_tx() has the same issue that it calls
> rt2x00queue_get_queue() with an argument which is a mac80211 AC,
> but expects an enum data_queue_qid.  So one could says one
> bug cancels the other out.

Right. We could of course add a mac80211-queue <-> rt2x00-queue mapping in
the appropriate places or rename the QID_* identifiers accordingly. Not sure
if it's worth it ...

> > And btw. queue 0 is used for managment frames as well.
> 
> Queue 0 means QID_AC_BE?  Or AC_VI?

It's AC_VO.

Helmut
