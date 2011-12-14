Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58897 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547Ab1LNWKd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 17:10:33 -0500
Subject: Re: iwlwifi havoc on some APs (rekeying?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EE8B12C.4090906@gmx.net> (sfid-20111214_152308_583031_CCEA7CD9)
References: <4EE2202A.4080303@gmx.net>
	 <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>
	 <1323451436.13074.158.camel@wwguy-huron>
	 (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
	 <4EE35877.1060507@gmx.net>
	 (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>
	 <4EE5D2D3.406@gmx.net>
	 (sfid-20111212_110955_792336_68917631) <1323684754.3442.36.camel@jlt3.sipsolutions.net>
	 <4EE5E3CD.1070409@gmx.net>
	 (sfid-20111212_122224_090419_DF83BB07) <1323712082.3442.43.camel@jlt3.sipsolutions.net>
	 <4EE64522.5090107@gmx.net>
	 (sfid-20111212_191739_160874_7027323F) <1323790688.3355.24.camel@jlt3.sipsolutions.net>
	 <4EE8B12C.4090906@gmx.net> (sfid-20111214_152308_583031_CCEA7CD9)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 23:10:27 +0100
Message-ID: <1323900627.3599.4.camel@jlt3.sipsolutions.net> (sfid-20111214_231036_565800_87905FFD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-14 at 15:22 +0100, Wolfgang Breyha wrote:
> Johannes Berg wrote, on 13.12.2011 16:38:
> > The program will allocate 2GiB memory (edit to suit, should be OK on
> > your machine), fill them with 0x94 and then continually scan them for
> > corruption. Identifying what kind of corruption happened will hopefully
> > allow me to figure out where it's coming from.
> > 
> > It prints out the wrong data & resets the memory so new corruption later
> > is also identified.
> 
> Ok, I had only 20 minutes yesterday evening, but the results are not very
> pleasant, because there are no results:(

Ouch! So we aren't actually just dealing with random memory corruption?!

> I did the usual steps to reproduce the case on my laptop:
> 
> *) stay connected on the "working" AP (no rekeying)
> --> *) new here: start "mc"
> *) echo "1" >...iwlwifi/debug
> *) open multitail, firefox, vlc
> *) connect to the other AP (rekeying every 20 seconds currently)
> *) start video stream
> *) wait for the second "group rekey finished"
> *) watch the artifacts, closing applications and listen to crackling sound
> 
> Everything happened exactly the same way as always. BUT "mc" didn't show any
> corrupted memory regions.

Hmmm. Yeah if it was random memory corruption that should have done
something.

> I already tried to remember which applications crashed, but currently I'm not
> able to give them a clear category like "all (network-)IO" or "all
> audio/video". Allocating memory seems not to be enough to trigger "something".
> <brainstorm mode>Maybe mmap'ed regions are affected?</brainstorm mode>

But my tool was using mmap ;-) I can't think why mmap would make a
difference though.

> Watching a video is only one way to notice that issue. Simply starting firefox
> with a group of tabs open is an other and has a high probability to
> immediately crash firefox while fetching the contents.
> 
> Watching a video shows the coincidence with the second rekeying event best.
> 
> I'll try to give "mc" some more time and start it after/before the others as
> soon as my pre-x-mas schedule allows it.

I wouldn't. If it was really memory corruption, this should've caught
it. No way firefox would crash while "mc" would run fine. Back to square
1!

Maybe we somehow invented the best fuzzer ever? Wrongly decrypted
packets being sent up without being dropped, and your video stream and
firefox hating random binary data in the middle of the input?

johannes

