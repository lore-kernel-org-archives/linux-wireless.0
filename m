Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mhub5.vim.at ([92.43.99.6]:57009 "EHLO mail.vim.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756140Ab0BAUcb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 15:32:31 -0500
Subject: Re: ath9k/PCI 168C:002C
From: Bernhard Reiter <ockham@raz.or.at>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100201113620.52ahuc39ws8scow4-cebfxv@webmail.spamcop.net>
References: <1265039522.3610.55.camel@razor>
	 <20100201113620.52ahuc39ws8scow4-cebfxv@webmail.spamcop.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 21:32:27 +0100
Message-ID: <1265056347.3610.100.camel@razor>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

thanks for your hints! unfortunately, as you expected, simply adding the
PCI id doesn't do the trick. seems like a couple of people tried it
already:
http://forum.ubuntuusers.de/topic/atheros-ar5b95-geht-unter-unr-9-10-nicht/
(in German).

i haven't tried madwifi yet, though.

regards,
bernhard

Am Montag, den 01.02.2010, 11:36 -0500 schrieb Pavel Roskin:
> Quoting Bernhard Reiter <ockham@raz.or.at>:
> 
> > hi,
> >
> > i'm currently setting up karmic (64bit) an asus eeepc 1005p, and i've
> > found the following in the debian wiki:
> > http://wiki.debian.org/DebianEeePC/Model/1005P
> > i'm giving this laptop to another person on wednesday, but until then, i
> > might try to compile the ath9k module with the suggested addition of
> > that PCI id.
> 
> You can add the ID at the runtime:
> 
> echo "168c 002c" > /sys/bus/pci/drivers/ath9k/new_id
> 
> > unfortunately, i haven't really found anything on how to do this (in a
> > least-invasive fashion). i've looked
> > into /usr/src/linux-headers-2.6.31-17/drivers/net/wireless/ath/ath9k,
> > but there's only a Kconfig and a Makefile, but no sources.
> 
> You should be able to compile compat-wireless on Ubuntu.  Then you can  
> modify ath9k in the compat-wireless sources.  But I'm not optimistic.   
> The wiki link suggests that further changes to the driver are needed.
> 
> You can also try MadWifi trunk to support the device.  It should  
> compile out-of-box.  You can use the same trick to add the ID, just  
> replace "ath9k" with "ath_pci".
> 


