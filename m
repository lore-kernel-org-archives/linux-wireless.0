Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab2K1O3q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:29:46 -0500
Message-ID: <1354113010.9345.27.camel@jlt4.sipsolutions.net> (sfid-20121128_152950_402566_2561197C)
Subject: Re: iwlwifi hibernate / suspend issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Kapitza <j.kapitza@schwarze-allianz.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 15:30:10 +0100
In-Reply-To: <50B61C71.6060007@schwarze-allianz.de> (sfid-20121128_152227_935873_AFE02FFF)
References: <50B61C71.6060007@schwarze-allianz.de>
	 (sfid-20121128_152227_935873_AFE02FFF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 15:15 +0100, Jens Kapitza wrote:

> after suspend phy0: tells Hard blocked: yes
> 
> but there is no switch on the laptop.
> (just a Fn-F2 key) softblocking the antenna [after reboot all works again]
> 
> any starting points?  i've looked at the main.c of iwlwifi there is an 
> wakup call but
> can someone tell me how the driver works?
> 
> which call is done after suspend and why can i unload the driver and 
> reload it again
> root@jens-S4216:/home/jens# modprobe -r iwlwifi
> root@jens-S4216:/home/jens# modprobe  iwlwifi
> and everythink works?
> 
> is it a firmware issue (is it possible to force a firmware reload after 
> suspend)

No, the firmware is stopped anyway during suspend, the card is powered
off. Can you please post message output? We should read the rfkill state
during resume, maybe there's a race. Also, what kernel version?

johannes

