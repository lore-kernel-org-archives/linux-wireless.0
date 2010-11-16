Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:49881 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584Ab0KPQAI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 11:00:08 -0500
Date: Tue, 16 Nov 2010 16:59:51 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Walter Goldens <goldenstranger@yahoo.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>, jay_hung@ralinktech.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 7/9] rt2x00: Fix rt2800 USB TX Path DMA issue
Message-ID: <20101116155951.GA21461@sig21.net>
References: <201011131911.47346.IvDoorn@gmail.com>
 <310488.65157.qm@web56802.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <310488.65157.qm@web56802.mail.re3.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 15, 2010 at 01:45:24AM -0800, Walter Goldens wrote:
> 
> These patches appear to have finally brought some life in to the rt307x chips
> in terms of stability and usability. There are no more duplicate (very few)
> or lost packets and overall, the driver is improved immensely, however the
> latency is increased compared to the STA driver. Pinging my gateway with STA
> yields about 2-3ms average, whereas the rt2800usb is about 8-9ms. The
> throughput is also about 20% less.

I'm runnung rt2800usb (RT3070) in AP mode, and when pinging
from the client I get:

[12631.727724] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[12632.727451] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[12638.728027] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler
[12674.732633] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[12676.732855] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[12679.733581] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
[12779.745991] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 0 status timed out, invoke forced tx handler
etc.

I wonder why it is using TX queue 2?  Isn't this QID_AC_VI, i.e.
it should only be used when some programs uses setsockopt SO_PRIORITY
to request QoS for video data?


Lokking through the code, in rt2x00mac_tx():
	enum data_queue_qid qid = skb_get_queue_mapping(skb);
is passed to rt2x00queue_get_queue() which uses
enum data_queue_qid has 2 == QID_AC_VI, but net/core/dev.c dev_pick_tx()
calls skb_set_queue_mapping() with 2 == BE
(from ieee802_1d_to_ac, return by ieee80211_netdev_select_queue())

Maybe I'm just confused?


Queue stats after some flood pinging:

# cat /sys/kernel/debug/ieee80211/phy0/rt2800usb/queue/queue 
qid     count   limit   length  index   dma done        done
14      199365  128     128     69      69      69
0       785     64      1       18      18      17
1       0       64      0       0       0       0
2       196406  64      0       54      54      54
3       0       64      0       0       0       0
16      0       8       0       0       0       0


Johannes
