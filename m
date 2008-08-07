Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:16430 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYHGSny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 14:43:54 -0400
Received: by nf-out-0910.google.com with SMTP id d3so254699nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 11:43:53 -0700 (PDT)
Message-ID: <489B425F.5060704@gmail.com> (sfid-20080807_204359_635471_22EB3AE9)
Date: Thu, 07 Aug 2008 19:43:43 +0100
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain>	 <1217970944.2908.11.camel@dv>	 <1217973349.30531.1.camel@localhost.localdomain>	 <1217976491.2908.36.camel@dv>	 <1218028414.16977.5.camel@localhost.localdomain>	 <4899FB91.8070501@gmail.com>	 <1218056165.12240.0.camel@localhost.localdomain>	 <489A12E2.8060909@gmail.com> <1218077300.30724.10.camel@localhost.localdomain>
In-Reply-To: <1218077300.30724.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Wed, 2008-08-06 at 22:08 +0100, Dave wrote:
>> Dan Williams wrote:
>>> Well, since the driver supports SSID scanning, we can use ap_scan=1
>>> anyway.  ap_scan=2 is actually pretty evil since it depends on WEXT
>>> ordering and whatnot.
>>
>> ap_scan=1 requires the use of SIOCSIWWAP (to set desired BSSID), which
>> the Agere firmware doesn't support. The firmware only supports setting a
>> desired SSID (via SIOCSIWESSID), so Agere based orinoco is stuck with
>> ap_scan=2 :(
>>
>> Symbol and Intersil don't have this problem.
> 
> In practice that shouldn't be a problem because drivers (at least
> ipw2200 does this) usually roam BSSIDs anyway.  Technically a bug I
> think.  But honestly, the driver needs to work with ap_scan=1 and I
> don't see why it couldn't.

I had a reread of <http://hostap.epitest.fi/wpa_supplicant/devel/driver_wrapper.html>. 

As a FullMAC driver without support for selecting the BSSID to associate with (or frequency in Managed mode), the only way I can see to make the driver work with ap_scan=1 is to silently ignore the SIOCSIWFREQ and SIOCSIWAP. I don't think this is an approach I would want to pursue.

That said, what's wrong with the ap_scan=2 mode? You've stated it's not great (and I'm prepared to believe it), but what is the actual problem?



Dave.
