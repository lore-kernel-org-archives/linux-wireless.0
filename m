Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:37879
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXCSUIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 16:08:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: Faking powersave for fun and realtime channel muxing
Date: Mon, 19 Mar 2007 21:08:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <45FEEB34.1000403@warmcat.com>
In-Reply-To: <45FEEB34.1000403@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703192108.43892.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 March 2007 20:57, Andy Green wrote:
> Hi folks -
> 
> If you could generate and manage powersave protocol frames to an AP from 
> the mac80211 stack, without actually putting the radio to sleep, you 
> could do some interesting things.
> 
> For example you could allow any logical network interface to have a 
> different channel.  In this case, during the time that the channel you 
> are associated on has been told you have gone into powersave mode, you 
> can actually spend time on that other channel, before switching the 
> channel back to check in with the AP.  So you could for example run 
> monitor mode on channel 11 while being associated on channel 2, given 
> the limitation that sometimes you aren't listening because you are 

And what's it good for to have a monitor device that randomly misses
half of the packets? I mean... rather useless, no?

> Depending on the limitations of the time you can arrange to "sleep" with 
> the AP, using this technique you could even associate multiple logical 
> interfaces to APs on different channels despite they are sharing one 
> physical radio.  That could be cool for dealing with realtime selection 
> of the best channel/AP when the guy is mobile, for example.
> 
> Is there something like firmware constraints or the detail of the 
> powersaving protocol that kill this dead or is it possible to consider?

For software MAC devices this might work. But I think performance would suck.
But it sounds like it's worth an experiment. So if you want to.. :)

-- 
Greetings Michael.
