Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:39446 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964960AbXCSVQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 17:16:33 -0400
Message-ID: <45FEFDAE.1000107@warmcat.com>
Date: Mon, 19 Mar 2007 21:16:30 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Faking powersave for fun and realtime channel muxing
References: <45FEEB34.1000403@warmcat.com> <200703191638.48742.flamingice@sourmilk.net>
In-Reply-To: <200703191638.48742.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Monday 19 March 2007 15:57, Andy Green wrote:
>> Hi folks -
>>
>> If you could generate and manage powersave protocol frames to an AP from
>> the mac80211 stack, without actually putting the radio to sleep, you
>> could do some interesting things.
>>
> Like in my scanning patch series?
> 
> http://news.gmane.org/find-root.php?group=gmane.linux.kernel.wireless.general&article=770

Yeah exactly like that, you're way ahead of me.  I will study these 
tomorrow.  Thanks for the pointer and the boost with these patches.

> This requires a bit of kernel side support to queue up frames on the client 
> side to maintain the illusion that nothing happened. (except for a brief 
> latency jump) However, it does seem to work for the wireless cards I've 

That's very encouraging!

> tested. Doing scanning like this in userspace will require some sort of 
> interface to stop/restart the TX for the appropriate network interfaces, but 
> will probably make your multichannel association idea possible.

I didn't catch what you meant in the last bit, "some sort of interface 
to stop/restart the TX"?  You mean for associated interfaces that are 
currently "sleeping" they need to use the netdev-level interface start 
and stop stuff?

> As for how long the AP will hold your frames.. 802.11 defines a minimum time, 
> but the maximum depends on the AP.

I guess an important thing is that in the degenerate case where there is 
only one logical interface up and associated, powersave mode doesn't get 
used at all, it goes on like it does now.

Then for associated interfaces when fake powersave mode is in use, it's 
important that any queued packets at the AP are taken to keep the count 
of packets held there low.  Packets queued in the driver for TX should 
be dealt with to try to keep the count of packets queued there low too, 
but it's less critical I guess.  So when associated interfaces are busy, 
they hog all the time between them.

Then last in the priority is Monitor interface time.  So when associated 
interfaces are relatively idle, you can spend large blocks of time 
monitoring on other channels.

-Andy
