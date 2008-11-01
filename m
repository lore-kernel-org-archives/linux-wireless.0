Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:64433 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKAXKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 19:10:53 -0400
Received: by nf-out-0910.google.com with SMTP id d3so771081nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 16:10:51 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Sun, 2 Nov 2008 00:10:47 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200811011625.18745.IvDoorn@gmail.com> <1225553696.3619.11.camel@johannes.berg>
In-Reply-To: <1225553696.3619.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811020010.47762.IvDoorn@gmail.com> (sfid-20081102_001057_642421_D7C4665C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 November 2008, Johannes Berg wrote:
> On Sat, 2008-11-01 at 16:25 +0100, Ivo van Doorn wrote:
> > On Saturday 01 November 2008, Johannes Berg wrote:
> > > On Sat, 2008-11-01 at 11:29 +0100, Ivo van Doorn wrote:
> > > > On Saturday 01 November 2008, Johannes Berg wrote:
> > > > > On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:
> > > > > 
> > > > > > Could you try this patch? It doesn't matter if it is on top or as a replacement
> > > > > > of my previous patch.
> > > > > > 
> > > > > > This patch should also fix suspend/resume handling in general, I suddenly realized
> > > > > > there was quite a big bug in there regarding EEPROM/CSR handling. 
> > > > > 
> > > > > Now it just hangs at resume, rather than crashing. At suspend it already
> > > > > logs some MCU errors though.
> > > > 
> > > > Hmm that is strange, those MCU errors could only come from right before the code I
> > > > just changed. :S
> > > > 
> > > > In any case, could you revert the previous patches and try this. This is the same LED patch
> > > > as before, but I have added the check for set_key() to return immediately when this is called
> > > > while the module is busy unloading.
> > > 
> > > Now I've upgraded wireless-testing and am running into the BUG_ON you
> > > added for antenna diversity...
> > 
> > Hmm, that's odd.. I'll look into it. Patches could take some time :(
> 
> That was with that patch applied, but I don't think it caused it. No
> worries, I don't usually actually use the rt61 card, but had used it for
> monitoring the night before I wrote my bug report, suspended, and
> ejected it while suspended the next morning because I had to run... :)

I think I found something, I'm sending a patch series for John in a few minutes,
it will contain a fix for this BUG_ON().

Ivo
