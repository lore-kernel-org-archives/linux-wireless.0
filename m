Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.3]:15996 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab2ATRW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 12:22:59 -0500
Message-ID: <1327080177.3285.26.camel@milan> (sfid-20120120_182325_594609_A9A9E7B8)
Subject: Re: BCM4313 doesn't work after suspend (brcmsmac on
 compat-wireless-next)
From: Milan Bouchet-Valat <nalimilan@club.fr>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 20 Jan 2012 18:22:57 +0100
In-Reply-To: <4F199EAC.3050602@broadcom.com>
References: <1327067694.2590.6.camel@milan> <4F199EAC.3050602@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi and thanks for the reply!

Le vendredi 20 janvier 2012 à 18:04 +0100, Arend van Spriel a écrit :
> I am not sure when compat-wireless-next was generated, but several
> patches were made for suspend/resume.
It was generated on January 17th, with sources from the 16th. Is that
recent enough?

(Packages are from
http://people.redhat.com/sgruszka/compat-wireless-next/F-16/)

> You also need bcma patches. Is
> bcma included in the compat-wireless package.
I'm not sure I understand. The bcma module is indeed installed from
compat-wireless-next and loaded:
$ lsmod|grep bcma
bcma                   23804  2 brcmsmac,b43

$ uname -r
3.1.9-1.fc16.x86_64

$ find /lib/modules/3.1.9-1.fc16.x86_64 -name bcma
/lib/modules/3.1.9-1.fc16.x86_64/updates/drivers/bcma
/lib/modules/3.1.9-1.fc16.x86_64/backports/drivers/bcma

(updates/ is from compat-wireless-next, and takes precedence over
backports/ as per /etc/depmod.d/dist.conf)

So should I apply more patches?


Regards

