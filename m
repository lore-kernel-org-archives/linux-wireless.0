Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3446 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832Ab1KUV67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 16:58:59 -0500
Message-ID: <4ECAC99B.8090507@broadcom.com> (sfid-20111121_225902_586769_17A8A879)
Date: Mon, 21 Nov 2011 13:58:51 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Lang=E5s?= <thomas.langas@fxitech.com>
cc: "Arend Van Spriel" <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Howard Harte" <hharte@broadcom.com>
Subject: Re: brcm80211 (with bcm4329-chip)
References: <CADrAYBnwWEaigcgQYYk6V3VEuEYyrmzJQXegKVk6TgOTPh5N8A@mail.gmail.com>
 <4ECA8908.7070304@broadcom.com> <4ECA98DB.4030608@broadcom.com>
 <CADrAYBk7_fsVJUAYNqEZpdBPKOTGUai_UhPT9LMHaEyY+Zm24w@mail.gmail.com>
 <4ECAAD6C.4080103@broadcom.com>
 <CADrAYBndEsNz5nypirSxQPObpSV5BWARWOQzwmBTmzg+tgUbBA@mail.gmail.com>
 <CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
In-Reply-To: <CADrAYB=wDwrzCFEi4-PFepLiLMbPLAGxoaNGtXBaPZPR1onokA@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/21/2011 01:34 PM, Thomas Langås wrote:
> On Mon, Nov 21, 2011 at 10:13 PM, Thomas Langås
> <thomas.langas@fxitech.com>  wrote:
>> Hmm, doing that, and loading this as a module instead of compiling it into the
>> kernel seemed to work.
>>
>> Is there a reason for this not working when being compiled into the kernel? Is
>> it possible that I need to change the order of  some of the units
>> being initialized
>> in my machine-description / init?\

Usually we compile it as module instead of built-in. But I just tried it 
with built-in and it can intialize and scan. Some issue did happen 
during joining  an AP. So I would suggest use module for your 
development for now.

>
> Ok, so I get the device listed as a wlan0-device, and I see the driver
> being able to communicate
> with the chip, sort of (it can read registers at least), but then I
> start seeing errors like this (from
> the previously attached log):

It's possible that the firmware carshed. Are you using the 
firmware/nvram from Linux repository? You should use the nvram that fits 
your platform.

Franky

