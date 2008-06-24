Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26457 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYFXDxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 23:53:04 -0400
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
From: Zhu Yi <yi.zhu@intel.com>
To: =?UTF-8?Q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <200806240537.08888.Michal.Kudla@gmail.com>
References: <200806060039.48488.m1k0@wp.pl>
	 <200806232103.31283.Michal.Kudla@gmail.com>
	 <1214275275.14590.194.camel@debian.sh.intel.com>
	 <200806240537.08888.Michal.Kudla@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Jun 2008 11:51:53 +0800
Message-Id: <1214279513.14590.198.camel@debian.sh.intel.com> (sfid-20080624_055309_338243_CA5FA6C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-06-24 at 05:37 +0200, Micha=C5=82 Kud=C5=82a wrote:
> laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
> \:rfkill1/state
> 0
> laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04
> \:00.0/rfkill\:rfkill1/state
> laptok ~ # iwconfig wlan0 txpower on
> laptok ~ # /etc/init.d/net.wlan0 restart
>  * Service net.wlan0 starting
>  Failed to configure wireless for wlan0
> [ !! ] * ERROR:  net.wlan0 failed to start

Looks like the wireless config scripts in your distro did something
(probably txpower off) to disable the SW radio. Can you try the
following commands after wlan0 restart?

$ cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/state
$ echo 1 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
\:rfkill1/state
$ ifconfig wlan0 up

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
