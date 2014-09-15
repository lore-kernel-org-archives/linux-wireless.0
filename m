Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45962 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbaIOIPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 04:15:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XTRRB-00042F-1G
	for linux-wireless@vger.kernel.org; Mon, 15 Sep 2014 10:15:05 +0200
Received: from cantest1.felk.cvut.cz ([147.32.86.75])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 10:15:05 +0200
Received: from lisovy by cantest1.felk.cvut.cz with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 10:15:05 +0200
To: linux-wireless@vger.kernel.org
From: Rostislav Lisovy <lisovy@gmail.com>
Subject: Re: Set channel (freq) and bandwidth (BW) using iw command
Date: Mon, 15 Sep 2014 08:09:07 +0000 (UTC)
Message-ID: <loom.20140915T100541-360@post.gmane.org> (sfid-20140915_101515_571807_BBF08CC5)
References: <013176138105415386E2ECF0674E546E@mwnl.snu.ac.kr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Okhwan;

Okhwan Lee <ohlee@...> writes:
> $ modprobe ath10k_pci
> $ iw wlan0 set channel 36 HT20
> command failed: Device or resource busy (-16)
> $ iw wlan0 set freq 5180 40 5190
> command failed: Device or resource busy (-16)
> $ iw wlan0 set freq 5180 80 5210
> command failed: Device or resource busy (-16)

I think that the first step to make this work is that
the interface has to be "up". Another think to consider is
which interface modes do allow manual channel setting.

This works for me:
ip link set wlan0 down
iw dev wlan0 set type monitor
ip link set wlan0 up
iw dev wlan0 set freq 5825

Best regards;
Rostislav


