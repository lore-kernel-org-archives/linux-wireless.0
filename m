Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4268 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1DTGkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 02:40:25 -0400
To: "Greg KH" <greg@kroah.com>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Arnd Bergmann" <arnd@arndb.de>,
	"George Kashperko" <george@znau.edu.ua>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Russell King" <rmk@arm.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Jonas Gorski" <jonas.gorski@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"Andy Botting" <andy@andybotting.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom
 bus?
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <1302892585.30441.12.camel@dev.znau.edu.ua>
 <BANLkTi=16i+D8frz3X2f+JDtp4hbJKLL3A@mail.gmail.com>
 <201104171938.12834.arnd@arndb.de> <op.vt6ufu1n3ri7v4@arend-laptop>
 <20110419140257.GA20456@kroah.com>
Date: Wed, 20 Apr 2011 08:39:59 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vt74sxvp3ri7v4@arend-laptop>
In-Reply-To: <20110419140257.GA20456@kroah.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 19 Apr 2011 16:02:57 +0200, Greg KH <greg@kroah.com> wrote:

> Please don't use a platform device, unless there is no other way for
> your device to work.  For this device, you are connected to the PCI bus,
> so a platform device does not make sense at all.

Hi Greg,

This is only true for a particular usage model. There are two models as  
shown below:

1) PCI(e) card
                       ...........
+----------+          :   x y z :     x, y, and z are cores.
|    uC    |__________:___|_|_| :
|          |  PCI-bus : axi-bus :
+----------+          :.........:
                       bcm chipset

2) SoC
           ...............
           : uC    x y z :
           :  |____|_|_| :
           :    axi-bus  :
           :.............:
             bcm chipset

Your statement is true for 1) but in usage model 2) there is no PCI bus.  
Also you refer to the chipset when you say 'device'. In the axi bus type  
each individual core is registered as a device in the linux device tree.

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

