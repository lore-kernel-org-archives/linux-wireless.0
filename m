Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaweb11.services.sfr.fr ([93.17.128.28]:61715 "EHLO
	smtp11.services.sfr.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752243Ab2AaNgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 08:36:48 -0500
Date: Tue, 31 Jan 2012 14:36:46 +0100 (CET)
From: Milan Bouchet-Valat <nalimilan@club-internet.fr>
Reply-To: Milan Bouchet-Valat <nalimilan@club-internet.fr>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <32081421.179347.1328017006287.JavaMail.www@wsfrf1118> (sfid-20120131_143651_977788_6D93E252)
In-Reply-To: <1327660003.21888.14.camel@milan>
References: <22905678.140637.1327401110095.JavaMail.www@wsfrf1232>
 <4F227784.10309@broadcom.com> <1327660003.21888.14.camel@milan>
Subject: Re: Re: BCM4313 keeps disconnecting with brcmsmac and multiple APs
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 27 janvier 2012 à 12:37 +0100, Arend van Spriel a écrit :
On 01/27/2012 11:26 AM, Milan Bouchet-Valat wrote:
> > Le vendredi 27 janvier 2012 à 11:08 +0100, Arend van Spriel a écrit :
> >> Another thing to consider. I notice that you have a bluetooth device in
> >> there as well. Can you disable that (if possible) and try again.
> > I'll try that, but sadly not before Tuesday as I'm not in the right
> > place ATM.
> 
> Ok. To disable bluetooth you could use the rfkill utility:
> 
> $ rfkill block bluetooth
> Yes, I did that, but it doesn't fix the problem.

>> Does your AP have DFS enabled?
> > I'll ask my IT staff about that. Or is there a way to get this
> > information from the logs or iwconfig?
> > 
> 
> I actually did mean whether the AP has automatic channel selection. I am
> not sure whether it is advertised in the beacons.
> I think you found the origin of the problem. I ran iwlist scan after the bug happened, and my network's APs are visible on 3 different channels (1, 6 and 11). When everything was fine, it was only on channel 11. The most surprising thing is that the precise AP I'm associated with is now visible on two channels (1 and 11).

Another weird fact is that after reloading brcmsmac (I had to do it twice to be able to reconnect), I still see my APs on these different 3 channels, and still it works fine. But maybe the channel change is what triggers the bug.

As you see, this is a very crowded place, with other networks using the same channels. This is probably not an ideal setup, but it's great to stress-test the drivers. ;-)


Regards
