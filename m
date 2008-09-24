Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jcdc-m02.simsmm.com ([65.165.161.15]:20520 "EHLO
	mail.ap.simsmm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYIXFMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 01:12:21 -0400
From: Ron Daniel <Ron.Daniel@simsmm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 24 Sep 2008 15:12:16 +1000
Subject: Q. How do I get Ubuntu to do WIreless Networking on my IBM laptop
 with Netgear WG511V2
Message-ID: <5BEFFDFA85231C4294591C394F810CA31FC46519@JC0365.AsiaPacific.pangaea.lcl> (sfid-20080924_071225_879266_41DBC32A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am writing to ask for help to get my wireless network card working on my IBM Thinkpad T30


Here is what I have so far



IBM Thinkpad T30

Netgear PCMCIA WG511 V2 wireless card

UBUNTU version 2.6.27-3-generic (aka Intrepid Ibex)



I have not been able to  find any straightforward instructions that I can follow that will establish wireless connection for my home laptop.



I started by doing this from the the http://www.linuxforums.org/forum/linux-tutorials-howtos-reference-material/13199-netgear-wg511-wireless-card-yoper-v2.html



TUTORIAL: INSTALLING THE NETGEAR WG511

1)Open up Mozilla, Konqueror, Internet Explorer(yikes!) or whatever your favorite browser is
2)Go to http://prism54.org <http://prism54.org/>
3)Download the Latest Tarball
4)Extract the patch:


Code:
 tar xvfj tarball.tar.bz2


This worked OK



5)

Code:
cd tarball


Now's where you can't just go by the README anymore! You need some information first! To patch the kernel to support Prism54 Wireless (well, actually, to patch the kernel anytime), you need to have the kernel source installed! If you don't have it, then:
6)(a)1.

apt-get install kernel-source

or if you have Red Hat:
2. Code:
yum install kernel-source


or for Gentoo:
3. Code:
emerge kernel-source

or something similar, replacing "kernel-source" with the appropriate name for the kernel source package.
(b)After you have the kernel source installed, you need to find out where it is installed to. Once you have this information, proceed to Step 7.

7)(a)Make sure that you are logged in as root. If you are not, then:


Code:
su -


I did not do any of this as I believe I  already have the source its in /usr/src/linux-headers-2.6.27-3-generic



(b)In the directory where the tarball was extracted to, enter the following into the command shell:


Code:
make KDIR=/path/to/kernel/source/here clean modules


I became root and then I went to the place where I untarred the tar ball to and put in

Make KDIR=/usr/src/linux-headers-2.6.27-3-generic clean modules


This is where it started to go wrong. I get a warning message that I am running a later version of the kernel and that I should enable the 80211 thing in CONFIG_NETDEVICES-MULTIQUEUE for 802.11[ne] support"

Q. Where /how is this enabling activity achieved. ? What do I run ? What command ? What GUI ? Where ?


Then I looked at http://wireless/kernel.org/en/users/Drivers/p54#mailinglist

It told me that I have to enable mac80211 :

Networking --->

   Wireless --->

        <M> Improved wireless configuration API

        <M> Generic IEEE 802.11 Networking Stack (Mac80211)

I can't find where or how to do this.

Now I am stuck. Seems like I don't have to do much more to get this to work.



Any help would be appreciated hugely.


Kind Regards

Ron Daniel

















