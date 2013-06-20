Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab3FTPXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 11:23:55 -0400
Message-ID: <1371741886.10995.3.camel@dcbw.foobar.com> (sfid-20130620_172359_118751_6F5CB170)
Subject: Re: BCM4331 deauthenticates every five minutes
From: Dan Williams <dcbw@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Chris Adams <cma@cmadams.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	b43-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 20 Jun 2013 10:24:46 -0500
In-Reply-To: <51C2BE54.20509@broadcom.com>
References: <20130619160911.GB4784@cmadams.net>
	 <51C1DDEB.3090701@lwfinger.net> <20130619164227.GC4784@cmadams.net>
	 <CACna6rzbTHnyqs5SzTuYL7r_SW3iCNh0qqbnvfsF7Wspyhp1WA@mail.gmail.com>
	 <20130619175850.GD4784@cmadams.net> <51C21B7C.2030005@broadcom.com>
	 <20130619211108.GG4784@cmadams.net> <51C2BE54.20509@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-20 at 10:33 +0200, Arend van Spriel wrote:
> On 06/19/2013 11:11 PM, Chris Adams wrote:
> > Once upon a time, Arend van Spriel <arend@broadcom.com> said:
> >> Can you make a capture using a wireless sniffer (using your thinkpad maybe)?
> >
> > How would I go about doing that?  I've done lots of network debugging
> > with tcpdump and such, but not much wireless stuff.
> >
> 
> I use wireshark these days. If you install that you can use the steps 
> below and select the wireless interface in wireshark to capture. I use 
> wlan0 as interface name, but it may be different for you.
> 
> 1. disable network-manager so it won't interfere.

It should be enough run "nmcli nm wifi off" and then un-rfkill the
interface, and NM will leave it alone until you turn wifi back on.  It
will also remove the interface from wpa_supplicant.

Dan

> 2. bring the interface down
> $ sudo ifconfig wlan0 down
> 3. change interface type to monitor
> $ sudo iw dev wlan0 set type monitor
> 4. bring up the interface
> $ sudo ifconfig wlan0 up
> 5. start wireshark and select wlan0
> $ gksudo wireshark
> 
> It will complain that running wireshark as root is not secure. If you 
> care about that, you should read [1].
> 
> Regards,
> Arend
> 
> [1] 
> http://wiki.wireshark.org/Security#Administrator.2Froot_account_not_required.21
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


