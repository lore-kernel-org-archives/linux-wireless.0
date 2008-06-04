Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55587 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750723AbYFDULD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 16:11:03 -0400
Message-ID: <4846F6DE.4080009@lwfinger.net> (sfid-20080604_221109_547713_1E4ECA29)
Date: Wed, 04 Jun 2008 15:11:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression (?) with wireless-testing and mainline 2.6.26-rcX
 kernels
References: <4846EB9D.1080303@lwfinger.net> <1212607636.14371.46.camel@johannes.berg>
In-Reply-To: <1212607636.14371.46.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Larry,
> 
>> I have found what I think is a regression where b43 appears to be connected; 
>> however, no data can be transferred. Not very much information has been 
>> logged; however, I think it correlates with a switch from short to long 
>> barker preamble.
> 
> Interesting. Doesn't your AP support short preambles? That'd be the only
> reason for anything going wrong here to actually break your connection.
> hmm.

My AP works with short preambles. When this situation occurs, whatever 
happens causes a switch from short to long. The change in the preamble is 
likely a symptom of whatever is causing the breakage.


>> Do you have any suggestions on what should be logged in 
>> ieee80211_handle_protect_preamb or any other mac80211 routine so that I can 
>> isolate the problem? I use NM to control the connection and authentication to 
>> a WPA-PSK TKIP network.
> 
> Well I guess you should log what state it changes to (maybe even in b43)
> and at the same time monitor with say wireshark on a monitor interface
> to see what the AP is announcing. Not sure really, I have a hard time
> imagining this being the problem.

I'll try for a stack dump when the short => long transition occurs. Perhaps 
that will suggest something to dump. I'll also set up a monitor interface. 
Unfortunately, it is an unlikely event, but I have a lot of disk space.

Larry

