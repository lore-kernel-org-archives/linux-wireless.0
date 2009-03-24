Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:31625 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbZCXKrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 06:47:06 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
Date: Tue, 24 Mar 2009 11:46:51 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>, Mircea Gherzan <mgherzan@gmail.com>
References: <20090320215705.GE8120@tesla> <200903241006.43512.hs4233@mail.mn-solutions.de> <200903241115.29868.helmut.schaa@gmail.com>
In-Reply-To: <200903241115.29868.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903241146.51795.hs4233@mail.mn-solutions.de> (sfid-20090324_114710_103193_A43004B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes, that's a good idea. There are some more scenarios where
> different roaming algorithms might make sense. However, I'm
> still not sure where the roaming decision should be made (and
> thus where the algorithm should be implemented). In user space
> (wpa_supplicant) or in mac80211. Having it in user space would
> allow non-mac80211-drivers to benefit too but the driver would
> have to provide the necessary information.

User-space is often easier to change *)


However, if you want to use beacon-information, then user-space 
doesn't spring to my mind so quickly. Beacons come in quite 
fast, and I'd if I have to transport all of this to 
user-space ...


Or we divide it: if user-spaces tells the kernel, then the kernel 
maintains a bss-list and whenever the kernel modifies the 
list "considerably", kernel pushes a nl80211 message to 
user-space, notifying it about the new state "once in a while". 
Then data gathering is in kernel, but decision making is in 
user-space. However, we need a good defintion for "considerably" 
and "once in a while", thought :-)





*) EXCEPT if we're talking wpa_supplicant. Not everyone find 
wpa_supplicant easy to modify, because of the number of 
interwoven state-machines and handled corner-cases.
