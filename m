Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:33651 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3HZSNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 14:13:07 -0400
Received: from [149.241.34.189] (helo=[192.168.1.108])
	by p15195424.pureserver.info with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.43)
	id 1VE1Ha-00067S-Bz
	for linux-wireless@vger.kernel.org; Mon, 26 Aug 2013 19:13:04 +0100
Message-ID: <521B9A74.60603@ilande.co.uk> (sfid-20130826_201311_648729_08717350)
Date: Mon, 26 Aug 2013 19:12:04 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
References: <5217B01D.4000609@ilande.co.uk>
In-Reply-To: <5217B01D.4000609@ilande.co.uk>
Subject: Re: Problems associating to AP with rtl8192cu driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/08/13 19:55, Mark Cave-Ayland wrote:

> Can anyone provide any hints to debugging the issue? I've just updated
> to Linus' latest git master from earlier today and the issue still
> appears :(

I spent some more time today trying to debug what was happening, and 
ended up setting up a temporary hostapd access point so that I could get 
logs from both the AP and my laptop workstation.

The bug I'm chasing seems to be related to the EAPOL handshake between 
my laptop and the AP. A session with Wireshark shows something like this:

AP -> Laptop : EAPOL 1/4
Laptop -> AP : EAPOL 2/4

(pause - EAPOL timeout of several seconds)

AP -> Laptop : EAPOL 1/4
Laptop -> AP : EAPOL 2/4

This pattern is repeated throughout the connection attempts. Comparing 
wpa_supplicant logs from a workstation with an Intel iwlwifi card shows 
that the AP never sends the EAPOL 3/4 packet, suggesting that something 
in the EAPOL 2/4 packet was invalid causing the authentication attempt 
to be dropped.

Interestingly enough if I leave the wpa_supplicant running for a minute 
or two, then sometimes the laptop will authenticate successfully with 
the AP - this suggests that perhaps it may be an initialisation bug of 
some description?

Can anyone suggest any reasons why the AP never responds with the EAPOL 
3/4 packet as part of the 4-way handshake? To get more information, I 
set up a fake AP using hostapd with logging enabled and recorded the 
authentication attempts on both the AP and the laptop (note that 
remarkably the laptop managed to associate to the AP on the second 
attempt in this particular session):

AP hostapd log:
http://www.ilande.co.uk/tmp/hostapd-rtl8192cu-connect.txt

Laptop workstation log:
http://www.ilande.co.uk/tmp/wpasupplicant-rtl8192cu-connect.txt

Also just to confirm that all testing was done against commit 
6a7492a4b2e05051a44458d7187023e22d580666 and therefore should contain 
the WPA association fix "rtlwifi: rtl8192cu: Fix problem in connecting 
to WEP or WPA(1) networks" from commit 
5b8df24e22e0b00b599cb9ae63dbb96e1959be30.


Many thanks,

Mark.
