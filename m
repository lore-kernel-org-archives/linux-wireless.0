Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:39961 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZDBV75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 17:59:57 -0400
Message-ID: <49D5352D.2030108@lwfinger.net> (sfid-20090403_000000_873375_35B3B30A)
Date: Thu, 02 Apr 2009 16:59:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: How does rfkill work?
References: <49D44635.80306@lwfinger.net>	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>	 <1238689637.24708.41.camel@johannes.local> <49D5018E.6050001@lwfinger.net>	 <1238696967.6137.5.camel@johannes.local> <49D506FE.5070405@lwfinger.net>	 <1238698084.7630.3.camel@johannes.local>	 (sfid-20090402_204842_882765_82560824) <1238698667.7630.7.camel@johannes.local>	 <49D521BF.2080301@lwfinger.net> <1238705420.8363.14.camel@johannes.local>	 <49D52D27.4010607@lwfinger.net> <1238708385.22126.4.camel@johannes.local>
In-Reply-To: <1238708385.22126.4.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2009-04-02 at 16:24 -0500, Larry Finger wrote:
> 
>>> Actually. Are you positive it works without my patch? The confusing this
>>> is that this code never seems to call led_trigger_event() outside of
>>> rfkill_led_trigger_activate() which is only called once... Can you try
>>> this patch please?
>> No, it hasn't worked for some time, but until you rationalized the rfkill code,
>> I didn't want to mess with it. :)
> 
> Ah, ok :) And I thought I broke it.
> 
>> This patch does the trick. Not only is the set brightness callback routine being
>> called, but the LED is going on/off as expected. 
> 
> Wohoo!
> 
>> It even ends up in the off
>> state when the module is loaded with the switch off. 
> 
> Yeah I'd fixed that earlier by calling the right thing.
> 
>> It toggles on/off in that
>> case, but I'm not going to complain as long as it ends up off. That part broke
>> first, then everything broke later..
> 
> Hm, don't see a good way to fix that really. Nor am I sure why it
> happens, but if it just flashes once doesn't really matter I guess.
> 
> I'll roll this into my rework patch.

The whole thing gets a Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
