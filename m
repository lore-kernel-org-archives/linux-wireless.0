Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sig21.net ([80.244.240.74]:59518 "EHLO mail.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbbJYWWh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 18:22:37 -0400
Date: Sun, 25 Oct 2015 22:39:04 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Jes.Sorensen@redhat.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH v3 0/1] rtl8xxxu (mac80211) driver for
 rtl8188[cr]u/rtl8192cu/rtl8723au
Message-ID: <20151025213903.GA2956@sig21.net> (sfid-20151025_232241_400729_E0030333)
References: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes and Larry,

On Wed, Oct 14, 2015 at 08:44:50PM -0400, Jes.Sorensen@redhat.com wrote:
> Per default only devices I have actually tested will be enabled. If
> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
> test results back to me.

I have one 
7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]

The rtlwifi/rtl8192cu driver turned out to be flaky for this device,
usually it stalls after a few minutes.  Searching the web it seems
this is well known and everyone uses a patched vendor driver
(https://github.com/pvaret/rtl8192cu-fixes.git).

The rtl8xxxu driver ssems to work stable (I tested
the git branch rtl8xxxu-nextgen, commit 2e23469d74d7).
However, thoughput is less than one half compared
to the vendor driver.  FWIW, rtlwifi seems to be a bit
faster when it works, but thoughput fluctuates a lot
and eventually it stalls.  (Tested with iperf TCP in both
directions.)

>From dmesg:
[21725.096068] usb 1-2.1: RTL8188CU rev A (TSMC) 1T1R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
[21725.096072] usb 1-2.1: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[21725.096179] usb 1-2.1: Firmware revision 80.0 (signature 0x88c1)


Thanks,
Johannes
