Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:54950 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbZDCPgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Apr 2009 11:36:36 -0400
Subject: Re: How does rfkill work?
From: Richard Purdie <rpurdie@rpsys.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238696913.6137.4.camel@johannes.local>
References: <49D44635.80306@lwfinger.net>
	 <1238666206.4141.12.camel@johannes.local>  <49D4CF50.2060100@lwfinger.net>
	 <1238684527.4141.63.camel@johannes.local>  <49D4D833.9070107@lwfinger.net>
	 <1238689637.24708.41.camel@johannes.local>  <49D5018E.6050001@lwfinger.net>
	 <1238696913.6137.4.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 16:15:45 +0100
Message-Id: <1238771745.5347.17.camel@dax.rpnet.com> (sfid-20090403_173640_535285_7FBDDDF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2009-04-02 at 20:28 +0200, Johannes Berg wrote:
> On Thu, 2009-04-02 at 13:18 -0500, Larry Finger wrote:
> 
> > The problem is the statement #define TRIG_NAME_MAX 50 in include/linux/leds.h.
> > When I make it 60, then the trigger file contains "none ide-disk ADP1-online
> > BAT0-charging-or-full BAT0-charging BAT0-full phy0rx phy0tx phy0assoc phy0radio
> > [rfkill0]" as expected.
> 
> Woah, that's strange. Richard? Larry is seeing problems where, oddly
> depending on a patch I have, he's getting garbage for the selected
> trigger when reading the trigger sysfs file.
> 
> The trigger's name, should be
> 	led_trigger.name = <something that is NULL> ? : dev_name(&some_dev)
> 
> Does this make any sense to you?

No, it doesn't make any sense and the 'fix' he posted isn't valid, just
a workaround that happens to help. I suspect there is memory corruption
going on somewhere...

Cheers,

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

