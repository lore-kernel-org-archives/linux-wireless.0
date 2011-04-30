Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4141 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1D3IOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Apr 2011 04:14:34 -0400
Message-ID: <4DBBC4DA.8000101@broadcom.com> (sfid-20110430_101440_457034_27094028)
Date: Sat, 30 Apr 2011 10:14:18 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Ben Hutchings" <ben@decadent.org.uk>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	=?UTF-8?B?V2VuY2VzbGFvIEdvbnrDoWxlei1WacOxYXM=?=
	<wens@fisica.unav.es>,
	"622842@bugs.debian.org" <622842@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: brcm80211 not setting correct country code?
References: <20110415070730.4178.6175.reportbug@calpurnia>
 <20110415081334.GD1387@vostochny.stro.at>
 <20110415161039.15535n2vg4igcykg@webmail.unav.es>
 <20110429164822.62112d9at4vs5xa8@webmail.unav.es>
 <1304088874.3105.57.camel@localhost>
 <20110429173944.10906p14p6bdid4w@webmail.unav.es>
 <1304139874.2833.29.camel@localhost>
In-Reply-To: <1304139874.2833.29.camel@localhost>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2011 07:04 AM, Ben Hutchings wrote:

> I looked at the driver source code and there is certainly an attempt to
> use a country code from NVRAM.  But maybe it hasn't actually been read
> from NVRAM at the point this is done.  'US' seems to be the default if
> the country code is blank.
>
> Ben.

Please refer to the information on wireless.kernel.org:
http://wireless.kernel.org/en/users/Drivers/brcm80211#Regulatory_Implementation

You could investigate whether the NVRAM/SROM country code is indeed 
blank or really configured with 'US'. For the driver itself channel 13 
can be used as long as your access point is transmitting beacons, 
because it is regarded as a passive channel.

Reading the logs listed in bug #622842 I would suggest running the 
following command after loading the brcm80211 driver:
$ iw set reg EU

You should see following in the log:
Apr 30 10:05:22 myhost kernel: [ 3967.072332] cfg80211: Calling CRDA for 
country: EU

Gr. AvS

