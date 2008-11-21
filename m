Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:13289 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYKUHiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 02:38:55 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
Date: Fri, 21 Nov 2008 08:38:25 +0100
Cc: "Stefan Steuerwald" <salsasepp@googlemail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com> <200811201537.19047.hs4233@mail.mn-solutions.de> <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
In-Reply-To: <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811210838.25977.hs4233@mail.mn-solutions.de> (sfid-20081121_083900_514249_BB2FB5C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 November 2008 20:21:44 Stefan Steuerwald wrote:
> The iPod alternates Null Functions with the PWR MGT bit on and
> off - whatever that means. Is it ignoring the AP and snoring
> away?

This is because the Ipod WLAN card all the time takes a nap of 
sleep. Whenever it goes to sleep, it sets the PWR_MGT bit. When 
it wakes up, it sends again a null packet with the bit off. So 
the AP should always know if the station sleeps or not.

If the Ipod has data for the Ipod while it sleeps, it simply 
wakes up and sends the data, with the PWR_MGT bit off. Maybe it 
also sends a NULL packet iwth the PWR_MGT bit off in advance.

If the AP has data for the Ipod while the Ipod sleeps, it sets 
the bit that corresponds to the AID of the Ipod in its TIM map. 
This is sent in the beacons of the AP. Even when a WLAN station 
sleeps, it knows when a beacon get's broadcasted and wakes up 
just in order to receive this beacon and check for it's AID bit. 
If it is set, it wakes up fully, notifies the AP about this and 
the AP sends the data packet to the now fully awoke WLAN 
station.
