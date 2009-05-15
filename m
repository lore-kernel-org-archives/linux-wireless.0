Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:40062 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZEOSNE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 14:13:04 -0400
Received: by fk-out-0910.google.com with SMTP id 18so988506fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 11:13:02 -0700 (PDT)
Message-ID: <4A0DB0A5.9010301@gmail.com>
Date: Fri, 15 May 2009 19:12:53 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Howard Chu <hyc@highlandsun.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com> <4A0D3A83.4040809@highlandsun.com>
In-Reply-To: <4A0D3A83.4040809@highlandsun.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Howard Chu wrote:
> Sigh, nothing's ever easy. After abandoning the CTX714 I mentioned in an 
> earlier email, I find that the Thinkpad T42 I got from eBay came with some 
> kind of Orinoco 802.11B mini-PCI card installed. Ubuntu Jaunty's 2.6.28 kernel 
> loads up the orinoco_cs driver for this card. It appears that this driver only 
> supports WPA-PSK, and I use WPA-EAP on my home wlan. Has anyone done any work 
> on supporting WPA-EAP for this card?

Michael Stokes, who is primarily responsible for debugging my initial
WPA efforts, reported getting WPA-EAP working with a Toshiba Wireless
WLAN v01.01 shortly after we got WPA-PSK working. However I haven't had
 independent confirmation of this.

The driver has evolved since then, so it's possible that we've broken
something.

Note that the card only supports TKIP, so it won't work if the AP
doesn't offer it. At that time there seemed to be an issue with
wpa_supplicant attempting to use CCMP when offered by the AP, despite it
also offering TKIP - the workaround being to explicitly specify TKIP in
wpa_supplicant.conf.



Regards,

Dave.

PS. My contact with Michael has only been in private mail, so I've bcc'd
him (rather than cc'ing in case he want to keep his email off public
lists) in the hope that he can supply you with the necessary hints to
get it working.
