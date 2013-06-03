Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:42673 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FCI7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 04:59:55 -0400
Received: from mac.home (mnch-5d85f17c.pool.mediaWays.net [93.133.241.124])
	by eazy.amigager.de (Postfix) with ESMTPA id 8980DC8C041
	for <linux-wireless@vger.kernel.org>; Mon,  3 Jun 2013 10:52:46 +0200 (CEST)
Date: Mon, 3 Jun 2013 10:52:39 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20130603085239.GA26920@mac.home> (sfid-20130603_105958_612469_2C37B71E)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130107110759.GC6931@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 07, 2013 at 12:08:00 +0100, Stanislaw Gruszka wrote:

[...]

> I posted patch here
> http://marc.info/?l=linux-wireless&m=135601033021616&w=2
> 
> But I did not review code regarding power save to catch possible
> problems. Testing are bug reporting are welcome ...

Hi,

the patch is surprisingly small. To me it looks like it only contains
the code to make "iwconfig wlan0 power on" work, the actual power
management is missing.

I just did some tests using powertop to see if I'm right. With the old
pre-iwlegacy driver, the difference between "iwconfig wlan0 power on"
and "...  power off" is more then 0,8W, which is ~10% of the total idle
power usage of my X61s with dimmed screen.  With a current kernel and
your patch, I can't measure a difference between "iwconfig wlan0 power
on" and "...  power off".  To me it seems that the patch is pretty
useless, at least on 4965AGN hardware.

It would be really nice to have proper power management in a current
kernel, as the laptop gets noticeably hotter with the current iwlegacy
driver.  That's why I still use a 3.1.10 kernel with an old
forward-ported iwlagn driver.

Regards,
Tino
