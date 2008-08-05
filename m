Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:50370 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYHEVuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 17:50:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1024452nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 14:50:14 -0700 (PDT)
Message-ID: <4898CB0E.805@gmail.com> (sfid-20080805_235025_483605_2476F328)
Date: Tue, 05 Aug 2008 22:50:06 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	Jean Tourrilhes <jt@hpl.hp.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain> <1217970944.2908.11.camel@dv>
In-Reply-To: <1217970944.2908.11.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Mon, 2008-08-04 at 11:34 -0400, Dan Williams wrote:
> 
>> Maybe the wireless-tools breakage you're experiencing is causing this to
>> fail on x86-64?  Are you using 64-bit wireless-tools and a 64-bit
>> kernel, or 32-bit wireless tools with a 64-bit kernel?
> 
> I'm using 64-bit kernel with 64-bit userspace.

I'm unsure as how to handle the 64 bit issues that you're seeing. Unless Jean gets back with a suggestion as to how to modify the code, I don't propose to address this. I am curious as to why this would only be affecting the orinoco driver though.
 
> If I use 32-bit kernel with 32-bit userspace, essid filtering works, but
> only to a degree.  Old scan results are cached somewhere, so if I scan
> with essid and then without essid, I get filtered results.  Likewise, If
> I don't use filtering the first time, but use it the second time, I get
> unfiltered results.

I know what you're talking about, but I don't think the description above gets it across very well. To be clear, the behaviour of the current patch (with each command run within 10s of each other):

iwlist scan eth0 essid hiddenAP
<results for hiddenAP>

iwlist scan eth0
<old results for hiddenAP>
<results for bcastAP>

iwlist scan eth0 essid hiddenAP
<results for hiddenAP>
<old results for bcastAP>

If you wait 10s between calls the cache should get cleared, and you don't see the old results.

This is the case because:
a) It doesn't require storing the state of the previous request in the driver
b) It doesn't require handling the case of simultaneous calls to iwlist from multiple processes.
c) I'm not clear on what the desired output from the API/iwlist is, especially how it should interact with the caching logic Dan implemented in the driver.

For my purposes the above is sufficient because when I want to check a hiddenAP I get the results for it. I also don't have a problem with the hidden/broadcast AP results leaking because I'm only ever inspecting the results visually.

If the desired effect is that iwlist scan essid only returns results for the specific essid, and the non essid version does not return results for hidden APs; then I believe the driver must only accept a single scan request at a time, and -EBUSY further requests until it has received results AND passed them to the calling process. It should also track what the user asked for last time and clear the cache if it is not the same as before.

I don't think this prevents other userspace processes from catching the SIOGIWCSCAN and picking up the results intended for another process anyway.

The alternative is to ditch the caching.
 
> I would prefer that we don't merge unreliable functionality.  It's not
> needed for WPA support.  And it don't look like and improvement in its
> present form.

Agreed, this patch is not required for WPA, though I think it is an improvement.


Regards,

Dave.
