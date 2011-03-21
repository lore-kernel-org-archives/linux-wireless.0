Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54428 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1CUQ2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 12:28:15 -0400
Subject: Re: new utility kernel module for detecting cores in newer chipsets
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	John Linville <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1300724675.23263.26.camel@maggie>
References: <20110319214234.GA5152@kroah.com>
	 <1300573336.11949.25.camel@maggie> <20110319234524.GA7493@kroah.com>
	 <op.vsmyhmei3ri7v4@arend-laptop> <20110320145421.GA13962@kroah.com>
	 <op.vsnd1a1i3ri7v4@arend-laptop> <20110320162200.GA17030@kroah.com>
	 <op.vsng7q1j3ri7v4@arend-laptop> <20110320185216.GD19375@kroah.com>
	 <AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
	 <20110321140505.GA7321@kroah.com>
	 <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
	 <op.vso77ddp3ri7v4@arend-laptop>
	 (sfid-20110321_160624_868281_FFFFFFFFFBF15756)  <1300724675.23263.26.camel@maggie>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 17:28:06 +0100
Message-ID: <1300724886.23263.29.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-21 at 17:24 +0100, Michael Büsch wrote: 
> On Mon, 2011-03-21 at 16:05 +0100, Arend van Spriel wrote: 
> > To summarize this, my main issue (and Michael's, I think) is with the  
> > dependency being imposed between ai and ssb.
> 
> That's part of my main issue, right.
> 
> > Having two completely independent modules really makes more sense.
> 
> I do think that any attempt to merge legacy-ssb with ai subsystems
> or even share significant amounts of code between these subsystems
> will result in a maintenance nightmare.
> 
> There are times where a fork or a rewrite is the best thing to do.
> And I think that is the case here.
> 
> SSB hardware is dead. Let the software die, too.
> You just need to realize that having ai code completely separate from
> ssb code makes life easier for you guys.
> Win: You don't need to take care about backwards compatibility.
> Win: You don't break our legacy devices.
> 
> Just look at the patches you guys already sent. Look at that TMSLOW
> abstraction layer, for instance. That's just a pain in the arms.
> Look at that:
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/66590
> You're carrying old legacy cruft into the shiny new subsystem
> (PCMCIA support, for instance) just to avoid duplicating a trivial
> 100 line function.
> 
> Please keep in mind that any attempt to merge SSB with AI code means
> that _you_ guys will have to maintain backwards compatibility
> with devices designed 10 years ago.
> 
> I really don't understand why you are so resistant against a fork
> or a rewrite, because it makes _your_ life easier (and mine, too).
> 
> PS: I do _not_ know whether the brcmaix code is reasonable or even
> useful
> as base to build up the new broadcom SOC bus subsystem, so I'm not
> going to pass and judgement on that code.
> 

I just realized that Arend was in the To: field.
The text was mainly addressed to Rafal and George. Probably Greg as
well.

-- 
Greetings Michael.

