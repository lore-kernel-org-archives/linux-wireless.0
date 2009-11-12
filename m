Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60174 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZKLLbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 06:31:31 -0500
Received: by bwz27 with SMTP id 27so2094246bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 03:31:36 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 12:31:35 +0100
Message-ID: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
Subject: Possible memory leak in ath9k monitor mode injection
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: technoboy85@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all

I am playing with ath9k/mac80211 in monitor mode and I suspect there
is a memory leak.
The leak happens when injecting in monitor mode when the destination
MAC address is unicast.
In fact there is no leak sending broadcast packet.
I wrote this minimal test case module which triggers the leak.

Cheers.

Lorenzo Bianconi

#include <linux/init.h>
#include <linux/module.h>
#include <linux/etherdevice.h>
#include <linux/netdevice.h>
#include <linux/skbuff.h>
#include <linux/timer.h>
#include <linux/version.h>

MODULE_LICENSE("Dual BSD/GPL");

const char ping_packet[] =
	"\x00\x00\x1a\x00\x2f\x48\x00\x00\x06\x81\x1a\x05\x00\x00\x00\x00"
	"\x10\x6c\x76\x09\xc0\x00\xdf\x00\x00\x00\x08\x00\x2c\x00\x00\x15"
	"\x6d\x84\x13\x06\x00\x15\x6d\x84\x13\x05\xee\x74\x25\xdf\x3b\x78"
	"\x00\x00\xaa\xaa\x03\x00\x00\x00\x08\x00\x00\x05\x5d\x44\xfb\xc3"
	"\x40\x36\x5a\x21\xc9\x8e\x08\x00\x45\x00\x00\x54\x24\x22\x00\x00"
	"\x40\x01\xd5\x2a\xc0\xa8\x00\x0b\xc0\xa8\x00\x01\x00\x00\x09\x95"
	"\x84\x72\x01\x09\x38\x91\xfa\x4a\x51\x10\x02\x00\x08\x09\x0a\x0b"
	"\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b"
	"\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b"
	"\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x93\x5a\x7b\x07"
	;

const int ping_packet_size = 160;

struct net_device *dev;
struct timer_list timer;

int delay = HZ/1000;
static char *device = "wlan0";

module_param(device, charp, 0600);
module_param(delay, int, 0);

static struct sk_buff * create_skb(void)
{
	struct sk_buff *skb = dev_alloc_skb(ping_packet_size);
	if (!skb)
		return NULL;

	memcpy(skb_put(skb, ping_packet_size), ping_packet, ping_packet_size);
	skb->dev = dev;
	skb->ip_summed = CHECKSUM_UNNECESSARY;
	skb->len = ping_packet_size;
	skb->pkt_type = PACKET_OUTGOING;
	
	return skb;
}

static void inject_packet(unsigned long x)
{
	struct sk_buff *skb =  create_skb();
	dev->netdev_ops->ndo_start_xmit(skb, dev);

	mod_timer(&timer, jiffies + delay);
}

static int __init inject_init(void)
{
	printk(KERN_ALERT "%s Inject, inserting module\n", __func__);
	dev = dev_get_by_name(&init_net, device);
	
	printk(KERN_ALERT "%s Inject, initializing the timer\n", __func__);
	init_timer(&timer);
	timer.data = (unsigned long)0;
	timer.function = inject_packet;
	timer.expires = jiffies + delay;
	add_timer(&timer);

	return 0;
}

static void __exit inject_exit(void)
{
	del_timer_sync(&timer);
	printk(KERN_ALERT "%s Inject, exiting module\n", __func__);
}


module_init(inject_init);
module_exit(inject_exit);
