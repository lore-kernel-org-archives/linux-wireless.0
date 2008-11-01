Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:14861 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbYKAPZX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 11:25:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so735240nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 08:25:21 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Sat, 1 Nov 2008 16:25:18 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200811011129.25387.IvDoorn@gmail.com> <1225541114.3619.2.camel@johannes.berg>
In-Reply-To: <1225541114.3619.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811011625.18745.IvDoorn@gmail.com> (sfid-20081101_162534_025376_E55A84E5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 November 2008, Johannes Berg wrote:
> On Sat, 2008-11-01 at 11:29 +0100, Ivo van Doorn wrote:
> > On Saturday 01 November 2008, Johannes Berg wrote:
> > > On Sat, 2008-11-01 at 09:58 +0100, Ivo van Doorn wrote:
> > > 
> > > > Could you try this patch? It doesn't matter if it is on top or as a replacement
> > > > of my previous patch.
> > > > 
> > > > This patch should also fix suspend/resume handling in general, I suddenly realized
> > > > there was quite a big bug in there regarding EEPROM/CSR handling. 
> > > 
> > > Now it just hangs at resume, rather than crashing. At suspend it already
> > > logs some MCU errors though.
> > 
> > Hmm that is strange, those MCU errors could only come from right before the code I
> > just changed. :S
> > 
> > In any case, could you revert the previous patches and try this. This is the same LED patch
> > as before, but I have added the check for set_key() to return immediately when this is called
> > while the module is busy unloading.
> 
> Now I've upgraded wireless-testing and am running into the BUG_ON you
> added for antenna diversity...

Hmm, that's odd.. I'll look into it. Patches could take some time :(

Ivo
