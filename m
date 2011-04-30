Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1988 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab1D3Lah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 07:30:37 -0400
Message-ID: <4DBBF2CF.8050608@broadcom.com> (sfid-20110430_133040_361889_5C231C96)
Date: Sat, 30 Apr 2011 13:30:23 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Wenceslao_Gonz=E1lez-Vi=F1as?= <wens@fisica.unav.es>
cc: "Ben Hutchings" <ben@decadent.org.uk>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"622842@bugs.debian.org" <622842@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 not setting correct country code?
References: <20110415070730.4178.6175.reportbug@calpurnia>
 <20110415081334.GD1387@vostochny.stro.at>
 <20110415161039.15535n2vg4igcykg@webmail.unav.es>
 <20110429164822.62112d9at4vs5xa8@webmail.unav.es>
 <1304088874.3105.57.camel@localhost>
 <20110429173944.10906p14p6bdid4w@webmail.unav.es>
 <1304139874.2833.29.camel@localhost> <4DBBC4DA.8000101@broadcom.com>
 <20110430103817.14736hcizu57ujrw@webmail.unav.es>
In-Reply-To: <20110430103817.14736hcizu57ujrw@webmail.unav.es>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2011 10:38 AM, Wenceslao González-Viñas wrote:
> After
> iw reg set EU
> I do not get any answer in dmesg log.

I assume you did this as root or used sudo. You may have to check 
whether you have the proper udev rules in place. See 
http://wireless.kernel.org/en/developers/Regulatory/CRDA#Letting_the_kernel_call_CRDA

> and if I do (after)  : iw reg get , I get:
>
> country 98:
> 	(2402 - 2472 @ 40), (N/A, 20)
> 	(5170 - 5250 @ 40), (N/A, 17)
> 	(5250 - 5330 @ 40), (N/A, 20), DFS
> 	(5490 - 5600 @ 40), (N/A, 20), DFS
> 	(5650 - 5710 @ 40), (N/A, 20), DFS
>
> So, something is not working properly.

I get country US (after iw reg set EU). I tried 'iw reg set ES' after 
that and another message showed up in the log:
[ 1613.052044] cfg80211: Calling CRDA for country: EU
[ 1845.365115] cfg80211: Pending regulatory request, waiting for it to 
be processed...

It seems cfg80211 expects CRDA to respond to the country setting for EU. 
I am not familiar what modules are involved in this usage scenario.

Gr. AvS

