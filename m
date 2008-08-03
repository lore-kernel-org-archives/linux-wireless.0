Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns1.siteground211.com ([209.62.36.12]:32943 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYHCA50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:57:26 -0400
Date: Sun, 3 Aug 2008 03:57:16 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: me@felipebalbi.com, Eugeniy Meshcheryakov <eugen@debian.org>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080803005715.GD23361@frodo> (sfid-20080803_025749_458905_5F5F99A0)
Reply-To: me@felipebalbi.com
References: <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc> <20080731224357.GA9741@localhost.localdomain> <48939C97.5030608@imap.cc> <20080802082851.GB8213@frodo> <4894D86A.6030108@imap.cc> <20080802231201.GB23361@frodo> <4894FF97.7040600@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4894FF97.7040600@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Aug 03, 2008 at 02:45:11AM +0200, Tilman Schmidt wrote:
> Next step would be running wpa_supplicant, because my WLAN uses WPA, but:
> 
> # wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf
>
> rapidly floods my console with messages
> 
> ioctl[SIOCSIWENCODEEXT]: Operation not supported
> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
> 
> and the syslog with
> 
> Aug  3 01:55:47 compaq kernel: get_mask 0x00000000, set_mask 0x00040000
> Aug  3 01:55:47 compaq kernel: important setting has been changed. Need to update packet templates, too
> Aug  3 01:55:47 compaq kernel: updating packet templates
> Aug  3 01:55:47 compaq kernel: updating WEP key settings
> Aug  3 01:55:47 compaq kernel: setting WEP key 0 as default
> Aug  3 01:55:47 compaq kernel: acx_set_status(1):SCANNING
> Aug  3 01:55:47 compaq kernel: start_scan: seems like previous scan is still running. Not starting anew. Please report
> Aug  3 01:55:47 compaq kernel: get_mask 0x00000000, set_mask 0x00000000 - after update

I'm wondering if that driver already supports wpa. If you have any time,
please try out with a WEP and open networks to see what happens.

> # dhclient wlan0
> 
> just repeats
> 
> DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 5
> 
> a couple of times with increasing interval values and finally tells me
> 
> No DHCPOFFERS received.
> No working leases in persistent database - sleeping.

Yeah, it couldn't associate with the access point.

> > It's probably affected by timing as well. That driver sure needs some
> > rework.
> 
> Yeah, looks like it. I posted a report to the project's Sourceforge
> "ACX100 USB" forum, too.

Maybe that driver could be sent to -stagging tree from been cleaned up
and later integrated.

-- 
balbi
