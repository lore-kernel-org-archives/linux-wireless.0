Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46130 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269AbZCXKwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 06:52:08 -0400
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <j@w1.fi>, Mircea Gherzan <mgherzan@gmail.com>
In-Reply-To: <200903241146.51795.hs4233@mail.mn-solutions.de>
References: <20090320215705.GE8120@tesla>
	 <200903241006.43512.hs4233@mail.mn-solutions.de>
	 <200903241115.29868.helmut.schaa@gmail.com>
	 <200903241146.51795.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 24 Mar 2009 06:49:53 -0400
Message-Id: <1237891793.25734.27.camel@localhost.localdomain> (sfid-20090324_115211_722921_B38C5096)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-24 at 11:46 +0100, Holger Schurig wrote:
> > Yes, that's a good idea. There are some more scenarios where
> > different roaming algorithms might make sense. However, I'm
> > still not sure where the roaming decision should be made (and
> > thus where the algorithm should be implemented). In user space
> > (wpa_supplicant) or in mac80211. Having it in user space would
> > allow non-mac80211-drivers to benefit too but the driver would
> > have to provide the necessary information.
> 
> User-space is often easier to change *)
> 
> 
> However, if you want to use beacon-information, then user-space 
> doesn't spring to my mind so quickly. Beacons come in quite 
> fast, and I'd if I have to transport all of this to 
> user-space ...
> 
> 
> Or we divide it: if user-spaces tells the kernel, then the kernel 
> maintains a bss-list and whenever the kernel modifies the 
> list "considerably", kernel pushes a nl80211 message to 
> user-space, notifying it about the new state "once in a while". 
> Then data gathering is in kernel, but decision making is in 
> user-space. However, we need a good defintion for "considerably" 
> and "once in a while", thought :-)

Right now the kernel will only keep the list for 10 seconds or so.
That's not enough to determine "considerably" really.  Since of course
not every AP shows up every scan, if you don't keep some scan history
there's no good way to know what "considerably" really means...  So
yeah, it would mean keeping a larger BSS list around in the kernel, or
even the last few BSS lists and a timestamp for each one, and figuring
out an algorithm to 'diff' the scan lists and come up with a threshold
for when that 'diff' is large enough to warrant a signal.

Dan

> 
> 
> 
> 
> *) EXCEPT if we're talking wpa_supplicant. Not everyone find 
> wpa_supplicant easy to modify, because of the number of 
> interwoven state-machines and handled corner-cases.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

