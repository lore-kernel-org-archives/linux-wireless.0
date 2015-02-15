Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52386 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754735AbbBONcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 08:32:17 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 747AF209D2
	for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2015 08:32:16 -0500 (EST)
Message-Id: <1424007136.2042747.227726249.45B6A0E2@webmail.messagingengine.com> (sfid-20150215_143338_943280_EAEC749D)
From: "Nikita N." <nikitan@operamail.com>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	arend@broadcom.com
MIME-Version: 1.0
Content-Type: text/plain
Subject: BCM4313 lowering TX power
Date: Sun, 15 Feb 2015 05:32:16 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dear backports Devs for driver brcmsmac,
Coming to the point, I want to lower the TX power of my BCM4313, under
the official values set by the regdom, to any special value I need.
So I'm trying to build such a "personal" patch, only for me, based on
latest backports v3.19 and latest Ubuntu.
Useless to say, "iwconfig <wlan> txpower" doesn't work, the resulting TX
power doesn't change.
I know it doesn't work because I can measure the RSSI coming out from
the BCM4313, using another device: it doesn't change, whatever value I
set.

So, I gave a look at the code for the brcmsmac module, and I think I
found the location where the TX power is *finally* set: inside
wlc_lcnphy_txpower_recalc_target (phy_lcn.c), call to
wlc_lcnphy_set_target_tx_pwr.
AFAIU, in that function a table of tx_power_offsets (calculated by
another function) is written in the device EPROM registry, and the TX
power is set to the relative minimum.

Now, my question: is that the right way to change effectively the TX
power?
I need to ask You a confirmation about that, if that is correct, before
I start building my patch.
I don't want to frustrate my time developing in the wrong code, or
damage the device, or other issues... :)

Thank you for your attention, and looking forward your feedback.

-- 
http://www.fastmail.com - mmm... Fastmail...

