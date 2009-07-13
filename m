Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:45495 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbZGMNBU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 09:01:20 -0400
Received: by qyk30 with SMTP id 30so619026qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 06:01:19 -0700 (PDT)
Message-ID: <4A5B301B.8060405@gmail.com>
Date: Mon, 13 Jul 2009 09:01:15 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Proper Regulatory Enforcement
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Many discussions in #Linux-wireless and even on this list seem to 
revolve around how regulatory enforcement is provided.  At one point I 
thought that I understood how this works, but as things evolve it seems 
I am losing my edge.  With the goal of understanding a unified policy 
for all drivers and proper (safe) regulatory enforcement, I'm starting 
this thread so that people can help clarify how this currently works, 
and how it should work.

As I see this all working in an ideal world is as follows:

1.) Driver reads eeprom of card for the permissible frequencies for that 
hardware. It is only safe to allow the frequencies in the eeprom because 
we cannot assume that any other values were calibrated in the hardware.  
This information (or initial regulatory domain) should be passed up to 
and immediately enforced by crda.  Drivers shouldn't have their own 
enforcement in addition to crda as we have a properly functioning 
regulatory enforcement engine and having 1 per driver makes things 
pointlessly complicated.

2.) If the user sets a reg domain, intersect user reg domain with eeprom 
reg domain.

3.) When user connects to AP, if available, read country IE and 
intersect that with the currently effective reg domain (which is at 
least the eeprom and may include user input from step 2 as well).

I realize some distros have cool stuff happening like setting a reg 
domain using the location from the timezone or some other cool thing.  
For the purpose of this discussion however, that is really nothing 
different from a user set reg domain (in fact I believe that is how it 
is done) so let's not worry about those specifics of "well the user 
didn't directly call iw reg set so blah blah blah".

How far off base am I here? I know that Intel enforces reg domain in 
their ucode and we cannot do anything about it, but I'm more interested 
in the cards where our drivers have full control.  Are the drivers 
themselves performing limiting that users don't even get to see? Or is 
all this actually passed up to crda as it should be? I'm personally 
especially interested in how the three atheros drivers do it, but I 
think this discussion should extend beyond my personal interests and any 
and all drivers should be discussed.

Thanks,
Rick Farina
