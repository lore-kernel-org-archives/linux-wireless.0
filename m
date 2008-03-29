Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:60529 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYC2SdF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Mar 2008 14:33:05 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JffrR-0007oq-62
	for linux-wireless@vger.kernel.org; Sat, 29 Mar 2008 18:33:01 +0000
Received: from port-87-193-186-180.static.qsc.de ([87.193.186.180])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 18:33:01 +0000
Received: from thomas by port-87-193-186-180.static.qsc.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 29 Mar 2008 18:33:01 +0000
To: linux-wireless@vger.kernel.org
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: mac80211 bug? no data is being transmitted after interface is brought
 down and then up again
Date: Sat, 29 Mar 2008 19:32:51 +0100
Message-ID: <fsm20k$usk$1@ger.gmane.org> (sfid-20080329_183313_563700_497BD04E)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the result of my quest to find the reason why I couldn't roam 
with any mac80211 driver (tested with iwl3945 and b43).

When you use dhclient for dhcp, the (very old) default dhclient-script 
brings the interface down and then up again after it receives a DHCPNAK 
(and on some other occasions). With the ieee80211 stack, this never 
caused any problems.

However, with mac80211, after the interface has been brought down and 
then up again, the "RUNNING" flag in ifconfig disappears and no data is 
being transmitted. Due to dhclient's weird behaviour, this makes any 
mac80211 driver unusable with dhclient and the (very old) default script.

I had no difficulty fixing this problem (once I found it), simply remove 
the word 'down' from all ifconfig-lines in dhclient-script.

My question is, should this be considered a bug in mac80211?
IMO, when an interface is brought down and then up again, one of the 
following things should happen:
1) Everything works as before
2) Nothing works, but the card disassociates from the network.
The current behaviour (card stays associated, but no data is transmitted 
any more) is unintuitive and costed me much time.

