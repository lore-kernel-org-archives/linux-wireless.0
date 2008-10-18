Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:52423 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbYJRXPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 19:15:45 -0400
Message-ID: <48FA6E1E.5070303@lwfinger.net> (sfid-20081019_011602_114128_BA3F9683)
Date: Sat, 18 Oct 2008 16:15:42 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Warning from mac80211 with p54usb
References: <48F7D0D2.6090604@lwfinger.net> <200810170226.28774.chunkeey@web.de>
In-Reply-To: <200810170226.28774.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> I've attached a debug function that could help to take a look inside the memory
> management. what does it look like when put p54_dump_txqueue into 
> p54_start/p54_stop or p54_add_interface and replug your device?

Thanks. I placed a call to the dump routine into p54_add_interface() and in
p54_hw_config(). The resulting output is shown below.

> or... something totally different. p54_rx_frame_sent could be culprit,
> maybe we should check if the printk
>  	goto out;
>  }
> + printk(KERN_ERR "p54: leaked frame %p\n", entry);
>  spin_unlock_irqrestore(&priv->tx_queue.lock, flags);

This printk never gets triggered.

At initial startup, printed from p54_add_interface:

kernel: phy26: Tx queue entries: 5
kernel:        entry: ffff8800986c7f00 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800986c7500 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff8800986c7000 (range: [20380-20420]=(a0) free:0)
kernel:        entry: ffff8800986c7c00 (range: [20420-204c0]=(a0) free:0)
kernel:        entry: ffff8800986c7800 (range: [204c0-2053c]=(7c) free:0)
kernel:        last entry: (range: [2053c-24214] free: 15576)
kernel:        total_free:15576 bytes, biggest free hole:15576 bytes

When the driver works normally, by the time p54_config is called, we have:

kernel: phy26: Tx queue entries: 3
kernel:        entry: ffff8800986c7700 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800986c7500 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff8800986c7900 (range: [20380-20470]=(f0) free:0)
kernel:        last entry: (range: [20470-24214] free: 15780)
kernel:        total_free:15780 bytes, biggest free hole:15780 bytes

As I see it, the second one persists but the other 4 have been freed, and two
new ones added. When the device works correctly, the same pattern persists and
the second entry is constant but the total number stays at 3 or 4.

When failure occurs, We get the following calls:

kernel: phy31: Tx queue entries: 5
kernel:        entry: ffff8800b8de6500 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff8800a80c5800 (range: [20380-20420]=(a0) free:0)
kernel:        entry: ffff88009872d000 (range: [20420-204c0]=(a0) free:0)
kernel:        entry: ffff88009872d100 (range: [204c0-2053c]=(7c) free:0)
kernel:        last entry: (range: [2053c-24214] free: 15576)
kernel:        total_free:15576 bytes, biggest free hole:15576 bytes
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: p54: In p54_config
kernel: phy31: Tx queue entries: 3
kernel:        entry: ffff88009872d500 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff88009872d400 (range: [20380-20470]=(f0) free:0)
kernel:        last entry: (range: [20470-24214] free: 15780)
kernel:        total_free:15780 bytes, biggest free hole:15780 bytes
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: p54: In p54_config
kernel: phy31: Tx queue entries: 3
kernel:        entry: ffff88009871fc00 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff88009871f100 (range: [20380-20470]=(f0) free:0)
kernel:        last entry: (range: [20470-24214] free: 15780)
kernel:        total_free:15780 bytes, biggest free hole:15780 bytes
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: In p54u_tx_cb
kernel: In p54u_tx_reuse_skb_cb
kernel: p54: In p54_config
kernel: phy31: Tx queue entries: 4
kernel:        entry: ffff88009871f800 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff88009871f700 (range: [20380-20548]=(1c8) free:0)
kernel:        entry: ffff88009871ff00 (range: [20548-20638]=(f0) free:0)
kernel:        last entry: (range: [20638-24214] free: 15324)
kernel:        total_free:15324 bytes, biggest free hole:15324 bytes
kernel: In p54u_tx_cb
kernel: In p54u_tx_free_skb_cb
kernel: Entered p54_free_skb
kernel: p54: In p54_config
kernel: phy31: Tx queue entries: 6
kernel:        entry: ffff88009871f800 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff88009871f700 (range: [20380-20548]=(1c8) free:0)
kernel:        entry: ffff88009871f200 (range: [20548-20710]=(1c8) free:0)
kernel:        entry: ffff88009871fd00 (range: [20710-20800]=(f0) free:0)
kernel:        entry: ffff88009871f500 (range: [20800-208c0]=(c0) free:0)
kernel:        last entry: (range: [208c0-24214] free: 14676)
kernel:        total_free:14676 bytes, biggest free hole:14676 bytes
kernel: p54: In p54_config
kernel: phy31: Tx queue entries: 9
kernel:        entry: ffff88009871f800 (range: [20200-202c0]=(c0) free:0)
kernel:        entry: ffff8800b8de6600 (range: [202c0-20380]=(c0) free:0)
kernel:        entry: ffff88009871f700 (range: [20380-20548]=(1c8) free:0)
kernel:        entry: ffff88009871f200 (range: [20548-20710]=(1c8) free:0)
kernel:        entry: ffff88009871fd00 (range: [20710-20800]=(f0) free:0)
kernel:        entry: ffff88009871f500 (range: [20800-208c0]=(c0) free:0)
kernel:        entry: ffff88009871f300 (range: [208c0-20a88]=(1c8) free:0)
kernel:        entry: ffff88009871f900 (range: [20a88-20b78]=(f0) free:0)
kernel:        entry: ffff88009871f000 (range: [20b78-20c38]=(c0) free:0)
kernel:        last entry: (range: [20c38-24214] free: 13788)
kernel:        total_free:13788 bytes, biggest free hole:13788 bytes

Note that none of the p54u callback routines are entered. From here, each
successive call to p54_config() adds 3 new queue entries, non of which are ever
removed. Eventually, the number of entries gets to 59 and the free space is less
that the requested length causing the failure.

I'm still trying to analyze the output from usbmon and to correlate it with the
data in /var/log/messages, but callbacks stop occurring at a certain point,
which is consistent with what is seen above. Unless you have other ideas, I'm
content to attribute this problem to the old firmware. If I see similar troubles
with newer firmware, I'll be back.

Larry

