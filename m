Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4261 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909Ab1CUPGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 11:06:15 -0400
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: =?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"John Linville" <linville@tuxdriver.com>,
	"George Kashperko" <george@znau.edu.ua>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: new utility kernel module for detecting cores in newer
 chipsets
References: <20110319214234.GA5152@kroah.com>
 <1300573336.11949.25.camel@maggie> <20110319234524.GA7493@kroah.com>
 <op.vsmyhmei3ri7v4@arend-laptop> <20110320145421.GA13962@kroah.com>
 <op.vsnd1a1i3ri7v4@arend-laptop> <20110320162200.GA17030@kroah.com>
 <op.vsng7q1j3ri7v4@arend-laptop> <20110320185216.GD19375@kroah.com>
 <AANLkTimEGR-8zhbMQpcAzYkuZ8fHkhj1bOQrb3rShfsP@mail.gmail.com>
 <20110321140505.GA7321@kroah.com>
 <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
Date: Mon, 21 Mar 2011 16:05:27 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vso77ddp3ri7v4@arend-laptop>
In-Reply-To: <AANLkTi=1eGo7uvP8Uy32yQezhGJTHYkHpEyX9vF=PujF@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 21 Mar 2011 15:27:49 +0100, Rafał Miłecki <zajec5@gmail.com> wrote:

> The case is, we discussed ssb/ai driver layout few days ago. George
> shared idea of layout I agree with, nobody shared any objections. If
> everything goes fine, we should have nicely modularized driver/project
> supporting Broadcom's buses.

Hi Rafał,

Does this give us one module supporting both buses or does it provide two  
kernel modules (my preference)? I did ask you and George this question  
earlier but I seem to have missed the response from you or George.

> In this situation I'm not really interested is simple ai driver
> stripped from brcm80211. According to me, it would led to harder
> maintenance and harder implementation of support for such a driver in
> b43.

I can imagine from b43 perspective the only good implementation would be  
to stick with the current b43<->ssb interface. So what will you do when  
another type of SoC interconnect is introduced. Forcing that in the same  
API as well? If you and George propose a new carefully considered API  
covering the functional capabilities of the current (and possibly future)  
interconnect buses I am all for that.

To summarize this, my main issue (and Michael's, I think) is with the  
dependency being imposed between ai and ssb. Having two completely  
independent modules really makes more sense.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

