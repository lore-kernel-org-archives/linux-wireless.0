Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12353 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKXIba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 03:31:30 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: ath5k: problems during the connection to a sitecom AP
Date: Mon, 24 Nov 2008 09:31:24 +0100
Cc: Fabio Rossi <rossi.f@inwind.it>,
	"Bob Copeland" <me@bobcopeland.com>
References: <200811150207.12084.rossi.f@inwind.it> <b6c5339f0811211222t745c65fve38958c9baa98e46@mail.gmail.com> <200811221733.56583.rossi.f@inwind.it>
In-Reply-To: <200811221733.56583.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811240931.24447.hs4233@mail.mn-solutions.de> (sfid-20081124_093133_719865_EB864433)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> When I do a scan after having loaded the driver, the iwlist
> can't report the SSID because it's hidden. I don't know if
> this is a problem but I have noticed that the reported SSIDs
> of the two APs are a little bit different. With the 3com AP
> (the working one) I get ESSID:" " (1 char blank string) while
> with the Sitecom AP ESSID:"" (0 chars empty string).

Okay, that could very well be the problem.


Side node: it doesn't buy you anything to "hide" the SSID of an 
AP. Actually, you can't really hide. The hidden bit only makes 
the AP lie about the SSID in it's beacons, but for other 802.11 
WLAN protocol messages (like Association Request, Assoc Resp) 
the SSID has to be send in cleartext anyway.

So turn of this stupid thingy. This also makes your roaming 
slightly faster and use slightly less battery (because the 
client doesn't need to probe the AP if it has the right, 
expected, SSID. The client knows in an instant that this is the 
case).

