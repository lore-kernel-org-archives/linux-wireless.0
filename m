Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4924 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596Ab1CTREi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Mar 2011 13:04:38 -0400
cc: "Greg KH" <greg@kroah.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?utf-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>
References: <op.vslagcb13ri7v4@arend-laptop>
 <op.vslaxakc3ri7v4@arend-laptop>
 <AANLkTim8SHdE8b9_gFLwbeEJM-uDegBDxU+AUJEb_rfc@mail.gmail.com>
 <1300626438.16689.21.camel@dev.znau.edu.ua>
Subject: Re: new utility kernel module for detecting cores in newer
 chipsets
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"George Kashperko" <george@znau.edu.ua>
Date: Sun, 20 Mar 2011 18:04:18 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsni1gbi3ri7v4@arend-laptop>
In-Reply-To: <1300626438.16689.21.camel@dev.znau.edu.ua>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 20 Mar 2011 14:07:18 +0100, George Kashperko <george@znau.edu.ua>
wrote:

>> I don't want to have support for AI in 10 places, even if this is
>> about staging area.
>>
> Agree here completely. The only arguable point here I think could be
> that AXI and SB should be different drivers but honestly they are too
> much similar softwire-wise to even be placed in separate directories if
> only bus managing code model is designed well.

Agree and a valid point at that as one would typically need either ssb or
axi support. If with a little refactoring the ssb tree can provide two
separate drivers that is fine by me if the axi flavour is not burdened by
shortcomings of the the ssb driver, which you are said to have pointed out
(I missed most of the discussion about this, sorry). In brcm80211 we have
two drivers and one typically needs the ssb support and the other axi
support. We abstracted the core access (not judging how well we did that)
with an additional layer but there is actually no need when having
separate drivers requiring either one or the other interconnect support.

Depending on the driver it may depend on one of them or both, but with two
separate modules this choice is up to the driver which makes most sense to
me.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the
human
mind to correlate all its contents." - "The Call of Cthulhu"

