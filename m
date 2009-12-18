Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f211.google.com ([209.85.217.211]:36792 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932420AbZLRSUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 13:20:22 -0500
Received: by gxk3 with SMTP id 3so2287479gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2009 10:20:21 -0800 (PST)
Message-ID: <4B2BC7E3.2050907@lwfinger.net>
Date: Fri, 18 Dec 2009 12:20:19 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Florian Zumbiehl <florz@florz.de>
CC: flamingice@sourmilk.net, andreamrl@tiscali.it,
	herton@mandriva.com.br, htl10@users.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for	low-power
 USB 802.11 adapter?
References: <20091218180205.GD2512@florz.florz.dyndns.org>
In-Reply-To: <20091218180205.GD2512@florz.florz.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2009 12:02 PM, Florian Zumbiehl wrote:
> Hi,
> 
> I'm not really sure whom to write to, so ... I'm writing to all of you, for
> now ;-)
> 
> I just bought a USB wireless stick with an RTL8187B inside. The idea was to
> use it with my laptop. In principle, it works just fine ... if it didn't
> cause the computer to triple its idle power consumption from some
> 7.5 to ~ 22.5 Watts.
> 
> I don't have a clue (yet) where exactly all that power goes to, and how
> much of it is actually being used by the stick itself (it's getting pretty
> warm, too - maybe you have a clue what to expect there?). But apparently,
> quite a bit of that increased power consumption is due to the CPU entering
> ACPI sleep states for a much smaller proportion of time, and not entering
> the highest sleep state at all anymore (which otherwise makes up around
> 98 % of the time) due to some polling/high-frequency interrupt of the
> driver. After all, even the most inefficient voltage regulator can't
> make 15 W from USB's max. 2.5 W (I hope ...).

My RTL8187B does get quite warm. The 'lsusb -v' output says that the
device can draw up to 500 mA or the maximum 2.5 W, but it does seem
warmer than that.

> Now, the obvious question is: Is there anything one could do about that?

AFAIK, the rtl8187 driver is not running any polling loops. It will
interrupt the machine whenever it receives something or whenever data
needs to be transmitted. You could cut the frequency by changing the
beacon interval to 2 s. It is probably now set at 0.1 s.

> And if not, or possibly even if: Any recommendation for a power-efficient
> USB 802.11 adapter - in particular something that does not cause
> CPU wakeups all the time when there is no actual network traffic?

Not all network traffic is data.

Larry
