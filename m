Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:53482 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZJNO2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 10:28:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: cfg80211 question: impedance mismatch of .connect versus .assoc
Date: Wed, 14 Oct 2009 16:26:53 +0200
Cc: linux-wireless@vger.kernel.org
References: <200910141136.03288.hs4233@mail.mn-solutions.de> <1255527718.4095.292.camel@johannes.local>
In-Reply-To: <1255527718.4095.292.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910141626.53440.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This was intentional, as with ->connect() the driver is
> supposed to handle roaming/pre-connect scanning etc. Basically
> it's mostly for the case of full-mac drivers that do that in
> the device firmware. 

The libertas firmware doesn't do roaming *)

But it also doesn't allow for individual auth/deauth
assoc/disassoc things, e.g. with the libertas firmware you cannot
stay authenticated when and just disassociate/reassociate when
some settings changes.  Therefore I have an impedance mismatch 
between libertas and .auth/.deauth .assoc/.disassoc as well. The 
most in-the-eye-springing point is that libertas doesn't have a 
CMD_802_11_DEASSOCIATE command. And the 
CMD_802_11_DEAUTHENTICATE command does both .deauth/.disassoc 
one go. Another mismatch is that CMD_802_11_ASSOCIATE also does 
both .auth/.assoc in one go.

So, libertas is not really FULLMAC and not really SOFTMAC, it's 
HALFMAC :-)





*) however, it can send a disconnect event when the AP is out of
reach, this will give you poor-mans roaming with the help of 
wpa_supplicant.

-- 
http://www.holgerschurig.de
