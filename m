Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9224 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab0BAQgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 11:36:21 -0500
Message-ID: <20100201113620.52ahuc39ws8scow4-cebfxv@webmail.spamcop.net>
Date: Mon, 01 Feb 2010 11:36:20 -0500
From: Pavel Roskin <proski@gnu.org>
To: Bernhard Reiter <ockham@raz.or.at>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k/PCI 168C:002C
References: <1265039522.3610.55.camel@razor>
In-Reply-To: <1265039522.3610.55.camel@razor>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Bernhard Reiter <ockham@raz.or.at>:

> hi,
>
> i'm currently setting up karmic (64bit) an asus eeepc 1005p, and i've
> found the following in the debian wiki:
> http://wiki.debian.org/DebianEeePC/Model/1005P
> i'm giving this laptop to another person on wednesday, but until then, i
> might try to compile the ath9k module with the suggested addition of
> that PCI id.

You can add the ID at the runtime:

echo "168c 002c" > /sys/bus/pci/drivers/ath9k/new_id

> unfortunately, i haven't really found anything on how to do this (in a
> least-invasive fashion). i've looked
> into /usr/src/linux-headers-2.6.31-17/drivers/net/wireless/ath/ath9k,
> but there's only a Kconfig and a Makefile, but no sources.

You should be able to compile compat-wireless on Ubuntu.  Then you can  
modify ath9k in the compat-wireless sources.  But I'm not optimistic.   
The wiki link suggests that further changes to the driver are needed.

You can also try MadWifi trunk to support the device.  It should  
compile out-of-box.  You can use the same trick to add the ID, just  
replace "ath9k" with "ath_pci".

-- 
Regards,
Pavel Roskin
