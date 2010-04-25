Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out30.alice.it ([85.33.2.30]:4365 "EHLO
	smtp-out30.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0DYV2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 17:28:36 -0400
Subject: wl1251_sdio PSM
From: GNUtoo <GNUtoo@no-log.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Apr 2010 23:18:20 +0200
Message-ID: <1272230300.2349.23.camel@gnutoo-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
We are trying to make the htc dream(also known as G1) android phone
usable with a standard GNU(non android) userland.

Inside the htcdream there is a wl1251_sdio chip.

We already use the wl1251_sdio driver with a special module for
initialization.

The problem is that When the wifi is on,the battery last for about an
hour.

So we definitely need power saving features like PSM(I hope I used the
right acronym,I'm looking for the system which makes the access point
buffer frames for the phone and then we request the frames,other power
saving mode are also welcome but as I understood this one is the most
important)

Grepping for psm in the driver show that there is some sort of support
for PSM.

Unfortunately the following method of activation failed:

# ./iw dev wlan0 set power_save on
command failed: Operation not supported (-95)


# iwconfig wlan0 power period 2 
Error for wireless request "Set Power Management" (8B2C) :
    invalid argument "2".

and I didn't find a psm sys node.

I wonder where it has been disabled,and if I can re-enable it.

I was also told that most driver have psm disabled,I don't know the
reason tough(maybe performance,as it has a serious impact on
performance)

our (bad quality)kenrel tree can be found here(we're not yet kernel
hackers):
http://gitorious.org/htc-msm-2-6-32/leviathan-incoming/commits/msm-gnuconform

Denis

