Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62764 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab0KPQMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:12:52 -0500
Received: by eye27 with SMTP id 27so385499eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 08:12:50 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Stezenbach <js@sig21.net>
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Date: Tue, 16 Nov 2010 17:11:51 +0100
Cc: Walter Goldens <goldenstranger@yahoo.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131911.47346.IvDoorn@gmail.com> <310488.65157.qm@web56802.mail.re3.yahoo.com> <20101116155951.GA21461@sig21.net>
In-Reply-To: <20101116155951.GA21461@sig21.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011161711.51581.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Am Dienstag 16 November 2010 schrieb Johannes Stezenbach:
> On Mon, Nov 15, 2010 at 01:45:24AM -0800, Walter Goldens wrote:
> > 
> > These patches appear to have finally brought some life in to the rt307x chips
> > in terms of stability and usability. There are no more duplicate (very few)
> > or lost packets and overall, the driver is improved immensely, however the
> > latency is increased compared to the STA driver. Pinging my gateway with STA
> > yields about 2-3ms average, whereas the rt2800usb is about 8-9ms. The
> > throughput is also about 20% less.
> 
> I'm runnung rt2800usb (RT3070) in AP mode, and when pinging
> from the client I get:
> 
> [12631.727724] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
> [12632.727451] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
> [12638.728027] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
> [12674.732633] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
> [12676.732855] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
> [12679.733581] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
> [12779.745991] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
> etc.
> 
> I wonder why it is using TX queue 2?  Isn't this QID_AC_VI, i.e.
> it should only be used when some programs uses setsockopt SO_PRIORITY
> to request QoS for video data?
> 
> 
> Lokking through the code, in rt2x00mac_tx():
> 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
> is passed to rt2x00queue_get_queue() which uses
> enum data_queue_qid has 2 == QID_AC_VI, but net/core/dev.c dev_pick_tx()
> calls skb_set_queue_mapping() with 2 == BE
> (from ieee802_1d_to_ac, return by ieee80211_netdev_select_queue())
> 
> Maybe I'm just confused?

Yep, it is indeed confusing. If you compiled rt2x00 with debug output have a
look at the queue setup in dmesg:

[   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 0 - CWmin: 3, CWmax: 4, Aifs: 2, TXop: 102.
[   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 1 - CWmin: 4, CWmax: 5, Aifs: 2, TXop: 188.
[   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 2 - CWmin: 5, CWmax: 10, Aifs: 3, TXop: 0.
[   47.590000] phy0 -> rt2x00mac_conf_tx: Info - Configured TX queue 3 - CWmin: 5, CWmax: 10, Aifs: 7, TXop: 0.

As you can see queue 2 gets the parameters for AC_BE assigned whereas queue 0
gets AC_VO assigned. So the naming within rt2x00 is not consitent with the
numbering within mac80211. However, since we configure the queue parameters
this should really just be a naming issue.

And btw. queue 0 is used for managment frames as well.

HTH,
Helmut
