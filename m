Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:43763 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0KBOqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 10:46:33 -0400
Date: Tue, 2 Nov 2010 15:46:25 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Lee <lee-in-berlin@web.de>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
Message-ID: <20101102144625.GA32002@sig21.net>
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
> Sorry for slow response time.  I can confirm that changing
> 		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
> 				      intf->mac, intf->bssid);
> to
> 		rt2x00lib_config_intf(rt2x00dev, intf, vif->type,
> 				      intf->mac, NULL);
> in rt2x00mac_add_interface() fixes rt73usb AP mode for me, too.

After studying the code some more, I'm confused by the
comment for this code in rt2x00mac_add_interface():

	 * The BSSID address must only be configured in AP mode,
	 * however we should not send an empty BSSID address for
	 * STA interfaces at this time, since this can cause
	 * invalid behavior in the device.

On the contrary I think the BSSID needs to be configured for STA mode
since it acts as a receive filter for broadcase/multicast frames.
The 802.11 standard says in 7.2.2 Data frames:

	A STA uses the contents of the Address 1 field to perform address
	matching for receive decisions. In cases where the Address 1 field
	contains a group address, the BSSID also is validated to ensure that
	the broadcast or multicast originated from a STA in the BSS of which
	the receiving STA is a member.

The ralinktech.com drivers seem to set the BSSID for STA mode and IBSS mode.


Johannes
