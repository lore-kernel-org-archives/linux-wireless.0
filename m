Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:57472 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109Ab0KCOOS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 10:14:18 -0400
Date: Wed, 3 Nov 2010 15:14:13 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101103141413.GA5364@sig21.net>
References: <4CC0D0F6.4080507@web.de>
 <201010290017.13174.helmut.schaa@googlemail.com>
 <4CCB3F24.1030701@web.de>
 <201010301430.15868.helmut.schaa@googlemail.com>
 <20101102125007.GA30000@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101102125007.GA30000@sig21.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 02, 2010 at 01:50:07PM +0100, Johannes Stezenbach wrote:
> 
> While reading through the code I noticed the following in rt2800_config_intf():
> 
> 		rt2x00_set_field32(&reg, MAC_BSSID_DW1_BSS_ID_MASK, 3);
> 
> However, in Ralink source from http://www.ralinktech.com/support.php?s=2
> in DPO_RT3370_LinuxSTA_V2.4.0.1_20100831/include/chip/rtmp_mac.h it says:
>                 USHORT          BssIdMask:2; // 0: one BSSID, 10: 4 BSSID,  01: 2 BSSID , 11: 8BSSID
> 
> This is different from rt73usb where 3 means "one BSSID".

Any comments on this?


I still have a very limited understanding of mac80211 and rt2xx code,
but I'm reading through the code and report what looks suspicious
to me.  I hope that's OK?   Here's another one:

In rt2x00lib_rxdone():

	/*
	 * Allocate a new sk_buffer. If no new buffer available, drop the
	 * received frame and reuse the existing buffer.
	 */
	skb = rt2x00queue_alloc_rxskb(rt2x00dev, entry);
	if (!skb)
		return;

Should this not be "goto submit_entry;"?


Johannes
