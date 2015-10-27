Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932395AbbJ0PLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2015 11:11:38 -0400
Message-ID: <1445958696.22230.8.camel@redhat.com> (sfid-20151027_161142_114689_26FCC419)
Subject: Re: mwifiex problem: incompatible network settings
From: Dan Williams <dcbw@redhat.com>
To: Julien Cubizolles <j.cubizolles@free.fr>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Oct 2015 10:11:36 -0500
In-Reply-To: <87twpd8fk4.fsf@free.fr>
References: <87wpu9632c.fsf@free.fr> <1445875814.31216.18.camel@redhat.com>
	 <87twpd8fk4.fsf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-10-26 at 22:50 +0100, Julien Cubizolles wrote:
> Dan Williams <dcbw@redhat.com> writes:
> 
> > On Mon, 2015-10-26 at 16:51 +0100, Julien Cubizolles wrote:
> >> I can't connect anymore to my home wifi since upgrading my machine from
> >> Ubuntu 15.04 to Ubuntuy 15.10. I was previously running kernel 4.3.0-rc2
> >> from kernel.org without any problem. After the upgrade, and with the
> >> same kernel, I couldn't connect anymore. I built 4.3.0-rc7, and the
> >> problem remains. However, I can connect to the wifi access point from my
> >> Android phone.
> >> 
> >> Here are the relevant lines from syslog. Let me know if you need more
> >> information.
> >
> > The AP uses WPA, but the driver has been told that WPA is disabled.  Are
> > you using wpa_supplicant (or NetworkManager, or something else?) to
> > control the WiFi, and if so what version is it?
> 
> Yes, I'm using NetworkManager, version 1.0.4-ubuntu5, and I'm guessing
> it's using wpa_supplicant. I deleted the configuration for this network
> and created it again. The network is configured for WPA in
> NetworkManager but I still get the same error message.

Ok, I think it's a problem with the driver not correctly handling the
wpa_supplicant configuration requests.  Clearly wpa_supplicant is
sending WPA-enabled configuration, but the driver isn't interpreting it
correctly.  I'll leave it up to the mwifiex maintainers to figure that
out though.

Dan

