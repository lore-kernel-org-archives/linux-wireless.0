Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42739 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750727Ab1LNOWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 09:22:40 -0500
Message-ID: <4EE8B12C.4090906@gmx.net> (sfid-20111214_152243_806197_9FE28829)
Date: Wed, 14 Dec 2011 15:22:36 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>  <4EE35877.1060507@gmx.net>  (sfid-20111210_140255_490293_C3C0F113) <1323680657.3442.7.camel@jlt3.sipsolutions.net>  <4EE5D2D3.406@gmx.net>  (sfid-20111212_110955_792336_68917631) <1323684754.3442.36.camel@jlt3.sipsolutions.net>  <4EE5E3CD.1070409@gmx.net>  (sfid-20111212_122224_090419_DF83BB07) <1323712082.3442.43.camel@jlt3.sipsolutions.net>  <4EE64522.5090107@gmx.net> (sfid-20111212_191739_160874_7027323F) <1323790688.3355.24.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323790688.3355.24.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote, on 13.12.2011 16:38:
> The program will allocate 2GiB memory (edit to suit, should be OK on
> your machine), fill them with 0x94 and then continually scan them for
> corruption. Identifying what kind of corruption happened will hopefully
> allow me to figure out where it's coming from.
> 
> It prints out the wrong data & resets the memory so new corruption later
> is also identified.

Ok, I had only 20 minutes yesterday evening, but the results are not very
pleasant, because there are no results:(

I did the usual steps to reproduce the case on my laptop:

*) stay connected on the "working" AP (no rekeying)
--> *) new here: start "mc"
*) echo "1" >...iwlwifi/debug
*) open multitail, firefox, vlc
*) connect to the other AP (rekeying every 20 seconds currently)
*) start video stream
*) wait for the second "group rekey finished"
*) watch the artifacts, closing applications and listen to crackling sound

Everything happened exactly the same way as always. BUT "mc" didn't show any
corrupted memory regions.

I already tried to remember which applications crashed, but currently I'm not
able to give them a clear category like "all (network-)IO" or "all
audio/video". Allocating memory seems not to be enough to trigger "something".
<brainstorm mode>Maybe mmap'ed regions are affected?</brainstorm mode>

Watching a video is only one way to notice that issue. Simply starting firefox
with a group of tabs open is an other and has a high probability to
immediately crash firefox while fetching the contents.

Watching a video shows the coincidence with the second rekeying event best.

I'll try to give "mc" some more time and start it after/before the others as
soon as my pre-x-mas schedule allows it.

Greetings, Wolfgang
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
