Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:54505 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0KPQeu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:34:50 -0500
Date: Tue, 16 Nov 2010 17:34:34 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Message-ID: <20101116163434.GA29414@sig21.net>
References: <201011131911.47346.IvDoorn@gmail.com>
 <310488.65157.qm@web56802.mail.re3.yahoo.com>
 <20101116155951.GA21461@sig21.net>
 <201011161711.51581.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201011161711.51581.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 16, 2010 at 05:11:51PM +0100, Helmut Schaa wrote:
> Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> > 
> > I wonder why it is using TX queue 2?  Isn't this QID_AC_VI, i.e.
> > it should only be used when some programs uses setsockopt SO_PRIORITY
> > to request QoS for video data?
> > 
> > 
> > Lokking through the code, in rt2x00mac_tx():
> > 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
> > is passed to rt2x00queue_get_queue() which uses
> > enum data_queue_qid has 2 == QID_AC_VI, but net/core/dev.c dev_pick_tx()
> > calls skb_set_queue_mapping() with 2 == BE
> > (from ieee802_1d_to_ac, return by ieee80211_netdev_select_queue())
> > 
> > Maybe I'm just confused?
> 
> Yep, it is indeed confusing. If you compiled rt2x00 with debug output have a
> look at the queue setup in dmesg:
> 
> [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
> [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
> [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
> [   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.
> 
> As you can see queue 2 gets the parameters for AC_BE assigned whereas queue 0
> gets AC_VO assigned. So the naming within rt2x00 is not consitent with the
> numbering within mac80211. However, since we configure the queue parameters
> this should really just be a naming issue.

Hm, yes, rt2x00mac_conf_tx() has the same issue that it calls
rt2x00queue_get_queue() with an argument which is a mac80211 AC,
but expects an enum data_queue_qid.  So one could says one
bug cancels the other out.

> And btw. queue 0 is used for managment frames as well.

Queue 0 means QID_AC_BE?  Or AC_VI?


Johannes
