Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3532 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab2FYUwT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 16:52:19 -0400
Message-ID: <4FE8CF77.5080400@broadcom.com> (sfid-20120625_225224_482374_B2F87E74)
Date: Mon, 25 Jun 2012 13:52:07 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: khilman@ti.com, tarun.kanti@ti.com
cc: tony@atomide.com, santosh.shilimkar@ti.com, b-cousson@ti.com,
	grant.likely@secretlab.ca, linux-omap@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Panda ES board hang when using GPIO as interrupt
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin, Tarun,

We are using the expansion connector A on Panda board to mount a SDIO 
WiFi dongle on MMC2 with a level triggered interrupt signal connected to 
GPIO 138. It's been working fine until 3.5 rc1. The board hang randomly 
within 5 mins during a network traffic test. After bisecting we found 
the culprit is "[PATCH 8/8] gpio/omap: fix missing check in 
*_runtime_suspend()" [1].

I noticed Kevin raised some similar cases on other platforms and also 
provided two patches in the patch mail thread. But unfortunately those 
two patches doesn't help in our case. I tested the driver with 3.5-rc3 
mainline kernel and the issue is still there. I can only "fix" the hang 
by either reverting the commit or disabling CONFIG_PM_RUNTIME. Also, the 
hang only happens on Panda ES board. Old Panda with 4430 works good.

Any thoughts and suggestions?

Thanks,
Franky

[1] http://article.gmane.org/gmane.linux.ports.arm.omap/75708/

