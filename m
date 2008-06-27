Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:5575 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762059AbYF0SBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:35 -0400
Received: by fg-out-1718.google.com with SMTP id 19so290024fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 11:01:31 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 27 Jun 2008 20:01:26 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <200806240537.08888.Michal.Kudla@gmail.com> <1214279513.14590.198.camel@debian.sh.intel.com>
In-Reply-To: <1214279513.14590.198.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806272001.27516.Michal.Kudla@gmail.com> (sfid-20080627_200159_756438_749CA12B)
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
my WiFi still don't wokrk
Now, I have new kernel 2.6.26-rc8.

Should I patch again this kernel?
Is good patch for rc7 for rc8?


W li=C5=9Bcie datowanym na wtorek, 24 czerwca 2008, Zhu Yi pisze:
>ZY On Tue, 2008-06-24 at 05:37 +0200, Micha=C5=82 Kud=C5=82a wrote:
>ZY > laptok ~ # cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY > \:rfkill1/state
>ZY > 0
>ZY > laptok ~ # echo "1"> /sys/bus/pci/drivers/iwl4965/0000\:04
>ZY > \:00.0/rfkill\:rfkill1/state
>ZY > laptok ~ # iwconfig wlan0 txpower on
>ZY > laptok ~ # /etc/init.d/net.wlan0 restart
>ZY >  * Service net.wlan0 starting
>ZY >  Failed to configure wireless for wlan0
>ZY > [ !! ] * ERROR:  net.wlan0 failed to start
>ZY
>ZY Looks like the wireless config scripts in your distro did something
>ZY (probably txpower off) to disable the SW radio. Can you try the
>ZY following commands after wlan0 restart?
>ZY
>ZY $ cat /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill\:rfkill1/s=
tate
>ZY $ echo 1 > /sys/bus/pci/drivers/iwl4965/0000\:04\:00.0/rfkill
>ZY \:rfkill1/state
>ZY $ ifconfig wlan0 up
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
