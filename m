Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42498 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbZBXPHT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 10:07:19 -0500
Date: Tue, 24 Feb 2009 17:07:10 +0200
From: Jouni Malinen <j@w1.fi>
To: pat-lkml <pat-lkml@erley.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add module parameter to disable hardware crypto
Message-ID: <20090224150710.GA1419@jm.kir.nu> (sfid-20090224_160723_912297_91387B92)
References: <20090224114201.GB21933@jm.kir.nu> <49A40320.1040902@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49A40320.1040902@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2009 at 09:24:32AM -0500, pat-lkml wrote:

> With this patch, and nohwcrypt=1, I get the following in hostapd (this
> system runs as an access point) when I try to associate with a client.
> 
> I can't say whether this is a hostapd problem or an ath9k problem yet,
> but it's a different behavior than with nohwcrypt=0 or without this 
> patch.  With this patch, wpa2 works perfectly, as without it, as well
> as wep working perfectly.  

Are you saying that you get different behavior from hostapd when
comparing nohwcrypt=0 and nohwcrypt=1 (i.e., no changes in the driver
code, just the module parameter change)?

> I wouldn't call this report a 'ACK/NACK' report as it has caused no
> new problems, nor fixed any old problems.  Unfortunately I don't have 
> a log around of the old behavior right now, for comparison.  I just 
> wanted to report what I've found based on this patch.

> wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
> wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
> wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
> wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout
> wlan0: STA 00:1f:a7:70:2d:8d WPA: sending 1/4 msg of 4-Way Handshake
> wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key frame (2/4 Pairwise)
> wlan0: STA 00:1f:a7:70:2d:8d WPA: invalid MIC in msg 2/4 of 4-Way Handshake
> wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
> wlan0: STA 00:1f:a7:70:2d:8d WPA: received EAPOL-Key 2/4 Pairwise with unexpected replay counter
> wlan0: STA 00:1f:a7:70:2d:8d WPA: EAPOL-Key timeout

Which client are you using? Are you sure that the passphrase/PSK is set
correctly? The nohwcrypt patch should make absolutely no difference for
this part (this is key handshake which in the initial phase is sent
without encrypted EAPOL-Key frames, so neither sw nor hw crypto used).

-- 
Jouni Malinen                                            PGP id EFC895FA
