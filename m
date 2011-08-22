Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3649 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab1HVKGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 06:06:13 -0400
Message-ID: <4E52297D.9090301@broadcom.com> (sfid-20110822_120616_253338_D66235AA)
Date: Mon, 22 Aug 2011 12:03:41 +0200
From: "Roland Vossen" <rvossen@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
cc: "Dan Williams" <dcbw@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Subject: Re: brcmsmac driver only works when sitting next to the AP
References: <20110814121646.GA5188@stt008.linux.site>
 <4E4A5641.4020604@broadcom.com>
 <1313509211.2065.36.camel@dcbw.foobar.com>
 <4E4B9A45.5090507@broadcom.com> <4E4CC85A.7010504@broadcom.com>
 <4E4E73F4.4040105@broadcom.com>
 <20110819152140.GA7506@stt008.linux.site>
 <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
In-Reply-To: <CAKprTDEUVa6ouH92G_8UMo20wYNnrhu76c_XAPYDtbCbRjqdLw@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Camaleón,

> Okay, I finally managed to compile a kernel with the required flag
> enabled and booted with it. I am attaching the resulting trace file,
> should you need additional information, kindly ask.

thanks! I did the same thing on my setup and diff'ed the resulting trace 
file with yours. I spotted a difference but it should not be relevant:

(your trace): drv_prepare_multicast: phy0 prepare mc (5)
(my trace): drv_prepare_multicast: phy0 prepare mc (1)

I am wondering if the problem could be explained by a RF kill switch 
being active. Can you send me the output of 'rfkill list' and 'lsmod' ?

Are there wireless-related LEDs on your machine and do they act 
differently between kernel 3.0.1 and 2.6.39-2 ?

Can you do a 'rfkill unblock all' to see if that makes a difference ?

Can you read this thread for more ideas: 
http://ubuntuforums.org/archive/index.php/t-1604665.html ?

Let me know how this works out, if unsuccessful we'll have to dig a bit 
deeper.

Thanks, Roland.







