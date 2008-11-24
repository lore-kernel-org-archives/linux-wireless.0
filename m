Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out3.libero.it ([212.52.84.103]:36852 "EHLO
	cp-out3.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYKXJfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 04:35:44 -0500
Message-ID: <5135663.819601227519341762.JavaMail.defaultUser@defaultHost> (sfid-20081124_103548_355823_3CB4270C)
Date: Mon, 24 Nov 2008 10:35:41 +0100 (CET)
From: "rossi.f@inwind.it" <rossi.f@inwind.it>
Reply-To: "rossi.f@inwind.it" <rossi.f@inwind.it>
To: <hs4233@mail.mn-solutions.de>, <linux-wireless@vger.kernel.org>
Subject: Re: ath5k: problems during the connection to a sitecom AP
Cc: Bob Copeland <me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> When I do a scan after having loaded the driver, the iwlist
>> can't report 
the SSID because it's hidden. I don't know if
>> this is a problem but I have 
noticed that the reported SSIDs
>> of the two APs are a little bit different. 
With the 3com AP
>> (the working one) I get ESSID:" " (1 char blank string) 
while
>> with the Sitecom AP ESSID:"" (0 chars empty string).
>
>Okay, that 
could very well be the problem.
>
>Side node: it doesn't buy you anything to 
"hide" the SSID of an 
>AP. Actually, you can't really hide. The hidden bit 
only makes 
>the AP lie about the SSID in it's beacons, but for other 802.11 

>WLAN protocol messages (like Association Request, Assoc Resp) 
>the SSID has 
to be send in cleartext anyway.
>
>So turn of this stupid thingy. This also 
makes your roaming 
>slightly faster and use slightly less battery (because 
the 
>client doesn't need to probe the AP if it has the right, 
>expected, 
SSID. The client knows in an instant that this is the 
>case).

Yes, I know 
that the hidden SSID technique doesn't have to be used for
security purposes. I 
might activate the transmission of the SSID on
my AP but this doesn't solve the 
problem in the mac80211 framework
regarding the empty SSIDs (if this is really 
the bug).

The problem is that the ieee80211_direct_probe() function is
never 
called during the associating request via iwconfig.

Regards,
Fabio

