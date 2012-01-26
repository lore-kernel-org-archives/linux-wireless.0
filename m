Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1371 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2AZSz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 13:55:57 -0500
Message-ID: <4F21A1AD.10605@broadcom.com> (sfid-20120126_195600_604973_EA4A6856)
Date: Thu, 26 Jan 2012 10:55:41 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Renzo Navas" <renzoefra@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [bcm4329] brcmfmac on kernel 2.6.35 (Andorid)
References: <CAD2CPUEu2ha6TeYrQ4WUdXU0-hdSAAJZR5PGWagSguE1DtBSfQ@mail.gmail.com>
 <4F20663C.3030500@broadcom.com>
 <CAD2CPUH6s=UuWy0S--SjmA0WZHARVQ70qmBjh9XW9s+f2ZkoLg@mail.gmail.com>
In-Reply-To: <CAD2CPUH6s=UuWy0S--SjmA0WZHARVQ70qmBjh9XW9s+f2ZkoLg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2012 08:04 AM, Renzo Navas wrote:
> As regards the hardware: basically I don't have many other choices,
> the University gave me a Nexus S to develop. I think I can have access
> to a Samsung Galaxy S, Galaxy S II and an HTC Dream HD, I have to find
> out if some of them has a wifi card which uses a softmac driver.

Galaxy S is using bcm4329, Galsxy S II is using 4330. Both are fullmac 
dongle.

  The
> idea is going to the wild (to the city which has high density of open
> wifi APs) to test the algorithm -so I need some portable device-. I
> yet have to find out how much can I accomplish with the bcm4329.

Some laptop products are using Broadcom PCIE NIC(DELL, Macbook Air and 
so on). Do you have access to any laptop? We can try to figure out 
what's in there.

> I'm interested on this "bcmdhd" driver which uses cfg80211,
> I have one request: is there an official source with the code of bcmdhd?

git clone https://android.googlesource.com/kernel/omap.git
drivers/net/wireless

Any scan request will be wrapped as an iovar and sent to the dongle. 
Scan results are sent back to the driver as a dongle event.

Hope this can help.

Franky

