Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46730 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760431AbXHVR5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 13:57:37 -0400
Subject: Re: [PATCH 1/2] mac80211:  Remove ieee80211_privacy_mismatch
From: Volker Braun <vbraun@physics.upenn.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1187787855.4314.6.camel@johannes.berg>
References: <1187406018.30247.17.camel@thinkpad>
	 <20070818034146.GC1415@jm.kir.nu>  <1187787855.4314.6.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 13:57:35 -0400
Message-Id: <1187805455.9845.104.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-22 at 15:04 +0200, Johannes Berg wrote:
> Volker, can you try # iwpriv wlan0 param 1039 1

Thats PRISM2_PARAM_MIXED_CELL=1039, which you removed in your
023-remove-unused-ioctls-3.patch. If I revert that then I'm sure your
iwpriv call would work around my problem.

Note that I'm not in a mixed cell! iee80211_privacy_mismatch checks the
wrong mismatch. In my case, the AP broadcasts privacy, but I do not
(yet) have a WEP key. But really mixed cell support is about the AP
_not_ broadcasting privacy, yet the user _having_ a WEP key configured. 

So say we fix iee80211_privacy_mismatch in checking for the right
mismatch only. Then everybody would be happy, except some poor soul on a
mixed cell network who would probably never figure out how to enable
mixed cell mode. Why do we hate him so much? ;-) There is no security
implication in enabling mixed mode by default --- management frames stay
unencrypted and data frames with privacy mismatch continue to be
dropped. 

------------------ snip --------------------------------
Mixed Cells Mode

Some access points, for example Cisco 350 or Cisco 1200, support
environments in which not all client stations support WEP encryption;
this is called Mixed-Cell Mode. When these wireless networks operate in
"optional encryption" mode, client stations that join in WEP mode send
all messages encrypted, and stations that join in using standard mode
send all messages unencrypted. These access points broadcast that these
network do not use encryption, but allow clients to join using WEP mode.
When "Mixed-Cell" is enabled in a profile, it allows you to connect to
access points that are configured for "optional encryption".
--------------------------------------------------------

-Volker


