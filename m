Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:39830 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbYGGTsc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 15:48:32 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KFwhK-0000us-So
	for linux-wireless@vger.kernel.org; Mon, 07 Jul 2008 19:48:30 +0000
Received: from alille-153-1-39-218.w83-198.abo.wanadoo.fr ([83.198.118.218])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 19:48:30 +0000
Received: from fabien by alille-153-1-39-218.w83-198.abo.wanadoo.fr with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 19:48:30 +0000
To: linux-wireless@vger.kernel.org
From: Fabien Crespel <fabien@crespel.net>
Subject: Re: Question on rfkill double block
Date: Mon, 07 Jul 2008 21:48:23 +0200
Message-ID: <48727307.6070507@crespel.net> (sfid-20080707_214838_507453_A5A757F1)
References: <1214982208.14590.473.camel@debian.sh.intel.com>	 <1215018189.29117.32.camel@localhost.localdomain>	 <20080704195543.GB27898@khazad-dum.debian.net> <1215450664.17128.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Henrique de Moraes Holschuh
	<public-hmh-N3TV7GIv+o9fyO9Q7EP/yw@ciao.gmane.org>,
	Zhu Yi <public-yi.zhu-ral2JQCrhuEAvxtiuMwx3w@ciao.gmane.org>
In-Reply-To: <1215450664.17128.64.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> But if the HW block is on, NM doesn't care about softblock because you
> can't use the radio anyway.  If the HW switch is unblocked, NM will
> un-SW-block the radio anyway, since HW-unblock is definitely a
> user-initiated option and signals user intent to unblock the radio
> irregardless of SW block state from something else.

Removing the SW switch after the user unblocks the HW switch seems wrong to me: 
HW-unblock doesn't necessarily mean the user wants to unblock WLAN if it was 
SW-blocked before (which is most likely the user's choice).

Consider the following situation:
- the computer has a WLAN device and Bluetooth device
- both devices can be HW-blocked with a single physical switch
- each device can be toggled with a key

With the following scenario:
- I (the user) don't want to use WLAN for whatever reason (like using a wired 
network, or to save energy)
- I want to have Bluetooth enabled for my wireless mouse
- I temporarily enable the HW switch (because I don't need the mouse anymore, or 
to let someone else use it on his/her own computer)
- A bit later, I want to use Bluetooth again and disable the HW switch
- Both Bluetooth and WLAN would now be enabled

This can be annoying, especially if NM connects to a wireless network 
automatically. It would consume energy needlessly, or break the network config if 
both the wired and wireless connections are configured for the same IP.

So generally, I would say that assuming to know what the user wants is dangerous, 
as it can result in doing something against his will. If the user wants to enable 
WLAN, there is a key for it.

Also note that this would still happen without NM but with rfkill-input, since 
currently it doesn't restore the previous state when the HW switch is disabled. 
It just unblocks the device (Andy posted about it half an hour ago).
Any news on this, Henrique? I think you talked about it some time ago, and with 
the new double block enum, it should be easier to know the previous state.

- Fabien.

