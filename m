Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:28552 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbYHMO22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 10:28:28 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 16:28:19 +0200
Cc: Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <200808130852.15051.hs4233@mail.mn-solutions.de> <1218628950.27171.7.camel@localhost.localdomain>
In-Reply-To: <1218628950.27171.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808131628.19465.hs4233@mail.mn-solutions.de> (sfid-20080813_162841_767747_DAC81260)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes; a scan list is a system resource, not per-process of
> course; the driver should be adding the new results to it's
> internal scan cache and timing out old results as appropriate.

Agreed.


> That said, it would be useful to pass the requested scan
> options along with the "scan completed" response.  Say process
> A just scans "ch1 + ssid foo", and process B wants full scans.
> If process B just listens for scan events, and backs off a
> scan timer each time an event comes in, it'll never ever get
> any results other than what process A requested. If scan
> options were passed along with the "scan completed" event,
> then process B could figure out that it needs more complete
> scan information and trigger a scan by itself.  Right now with
> WEXT, we can't do this AFAIK.

That's one possible solution, but if I get you correctly, then 
the kernel would need to keep a FIFO of the various scan 
requests.

However, scanning is something that is restricted by the 
hardware. We just define that "There can only be one scan in 
progress per time per hardware".

So if the hardware is busy, we can return an error. The client 
than knows that he has to request the same scan later (ideally 
probably after a "scan done" event has been seen).


Process A     Process B               mac80211 / Hardware
"do scan MUH" -                       scan for MUH on channel 1
-             -                       scan for MUH on channel 2
-             -                       ...
-             -                       scan for MUH on channel 12
-             "scan BLAH" -> -EAGAIN  scan for MUH on channel 13
-             -                       "scan done" notification
"get result"  "do scan BLAH"          scan for BLAH on channel 1
-             -                       ...

So, if you do a "scan MUH" and you don't get an -EAGAIN, the 
next "scan done" event is yours and you get "your" scan result 
with "get result".

If you get an -EAGAIN, you cannot scan until the current scan is 
done. This is marked by the next "scan done" event. You can then 
decide to get the other process' scan result and do something 
with it --- or you can issue your own "do scan" command and wait 
until you get your "scan done".

I think this is both efficient and flexible.
