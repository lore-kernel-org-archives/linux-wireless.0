Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iabervon.org ([66.92.72.58]:33812 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYE0Bi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2008 21:38:59 -0400
Date: Mon, 26 May 2008 21:38:58 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: linux-wireless@vger.kernel.org
cc: ipw3945-devel@lists.sourceforge.com
Subject: rf_kill and txpower.disabled on iwl3945
Message-ID: <alpine.LNX.1.00.0801301319200.13593@iabervon.org> (sfid-20080527_033905_049740_33AC00DB)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been having a problem where restarting the userspace handling for my 
wifi would make it stop working entirely. I eventually tracked this down 
to the conflation of txpower.disable and rf_kill; if I make siwtxpower not 
change radio_enabled, it all works as expected.

I think there are two issues:

# iwconfig iface txpower off
# echo 0 > /sys/class/net/iface/device/rf_kill
# iwconfig iface <anything>

Causes the radio to go back to being disabled, to the confusion of 
userspace (or at least, me), since it's not expected that changing other
settings will kill the radio again.

Also, I think I was having a problem with:

# iwconfig iface txpower off
# iwconfig iface txpower auto

because it tries using REPLY_TX_POWER_TABLE_CMD before it unkills the 
radio, but the part that's supposed to respond to that command is shut off 
when the radio is killed. And it seems to fail, therefore, and then not 
actually unkill the radio.

Is "txpower off" (or !radio_enabled) supposed to disable the radio 
completely (such that the driver can't turn on the chipset temporarily to 
configure it or get its configuration), or is it just supposed to be a 
power saving measure, and not affect the availability of other operations?

	-Daniel
*This .sig left intentionally blank*
