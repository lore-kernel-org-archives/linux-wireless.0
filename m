Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:44979 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3JVPck (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 11:32:40 -0400
Received: by mail-oa0-f42.google.com with SMTP id k14so6749494oag.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 08:32:39 -0700 (PDT)
Message-ID: <52669A94.3070600@lwfinger.net> (sfid-20131022_173243_683897_58EB6332)
Date: Tue, 22 Oct 2013 10:32:36 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alexandre Oliva <oliva@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: RTL8187B is racy
References: <or61sq3q4e.fsf@livre.home>
In-Reply-To: <or61sq3q4e.fsf@livre.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2013 11:07 PM, Alexandre Oliva wrote:
> It's been at least a year since I first noticed that, on WiFi-busy
> environments such as airports, hotels and Free Software conferences, my
> Yeeloong laptop with a RTL8187B WiFi card will freeze or oops shortly
> after I enable WiFi.  This problem doesn't seem to happen when I'm at
> home, probably because of the low WiFi traffic.  The problem occurs
> while running 3.11.* and 3.10.* kernels, but not 3.4.* or 3.0.*.
>
> I couldn't find any changes to the rtl8187 module that explain this
> misbehavior, so I suspect it's some new source of parallelism in the
> mac80211 layer that has exposed the lack of synchronization in uses of
> rx_queue and b_tx_status.queue.  Indeed, I found many uses of these
> queues that don't take locks to ensure consistency.  Unfortunately,
> adding spin locks around all uses causes harder freezes and/or complains
> about scheduling in atomic contexts, depending on which race I hit
> first.  Without any changes, the problem I get most often is a crash
> within rtl8187b_status_cb, when skb_unlink attempts to dereference a
> NULL pointer.  Testing skb->prev and skb->next before entering the
> branch where the skb is removed seemed to make the error a little bit
> less frequent, but surely not enough for the machine to remain up for
> very long while WiFi is enabled.
>
> Is this a known problem?  Any suggestions on what I could try next to
> fix the problem?

No, the problem has not previously been reported. From your description of the 
situation where it happens, the problem requires a lot of same channel, same AP 
traffic. I will try to duplicate that condition here. Although I have an 
RTL8187B device, I seldom use it as the case on the USB stick is falling apart. 
I will need to do some repair on it so that it holds together.

After inspecting the code in rtl8187b_status_cb, I did notice that it does a lot 
of things that should be done by mac80211. As you have been testing code 
modifications, I assume that you will be able to test any patches that I generate.

Larry

