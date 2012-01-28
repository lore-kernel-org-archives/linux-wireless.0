Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm16-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.254]:29628
	"HELO nm16-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751761Ab2A1UXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 15:23:51 -0500
From: Marek Lindner <lindner_marek@yahoo.de>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied rts setting
Date: Sun, 29 Jan 2012 04:23:44 +0800
Cc: Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless@vger.kernel.org
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <201201290358.35433.lindner_marek@yahoo.de> <4F245888.2070202@openwrt.org>
In-Reply-To: <4F245888.2070202@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201201290423.45141.lindner_marek@yahoo.de> (sfid-20120128_212355_294935_966D0193)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, January 29, 2012 04:20:24 you wrote:
> On 2012-01-28 8:58 PM, Marek Lindner wrote:
> >> I'm with Felix: I could see adding an option that means "force never
> >> use RTS/CTS" but I think we're at the right operating point when
> >> interpreting the standard "RTS/CTS threshold" option.
> > 
> > Actually, this option exists already. It's just minstrel_ht overriding
> > it: iw phy <phyname> set rts <rts threshold|off>
> > Put special attention towards the "off" at the end.
> > 
> > If we let the rate algorithm override our rts settings it should at least
> > be communicated. I found no such mention anywhere.
> > 
> > I'd like to further stress the point that no other rate algorithm does
> > this. We create incoherent and hard to debug behavior.
> 
> Which rate algorithms did you check to come to that conclusion? I just
> looked at the ath9k rate control algorithm and it does the same ;)

I checked net/mac80211/rc80211_* since that is where minstrel_ht is living.

Regards,
Marek
