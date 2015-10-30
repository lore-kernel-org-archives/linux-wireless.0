Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48146 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966062AbbJ3OJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 10:09:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Stezenbach <js@sig21.net>
Cc: Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH v3 0/1] rtl8xxxu (mac80211) driver for rtl8188[cr]u/rtl8192cu/rtl8723au
References: <1444869891-21174-1-git-send-email-Jes.Sorensen@redhat.com>
	<20151025213903.GA2956@sig21.net>
Date: Fri, 30 Oct 2015 16:09:01 +0200
In-Reply-To: <20151025213903.GA2956@sig21.net> (Johannes Stezenbach's message
	of "Sun, 25 Oct 2015 22:39:04 +0100")
Message-ID: <87si4smosi.fsf@kamboji.qca.qualcomm.com> (sfid-20151030_150919_271571_660EC33A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Stezenbach <js@sig21.net> writes:

> Hi Jes and Larry,
>
> On Wed, Oct 14, 2015 at 08:44:50PM -0400, Jes.Sorensen@redhat.com wrote:
>> Per default only devices I have actually tested will be enabled. If
>> you are interested in trying it out with other 8188cu/8188ru/819[12]cu
>> dongles, you need to enable CONFIG_RTL8XXXU_UNTESTED. Please report
>> test results back to me.
>
> I have one 
> 7392:7811 Edimax Technology Co., Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
>
> The rtlwifi/rtl8192cu driver turned out to be flaky for this device,
> usually it stalls after a few minutes.  Searching the web it seems
> this is well known and everyone uses a patched vendor driver
> (https://github.com/pvaret/rtl8192cu-fixes.git).
>
> The rtl8xxxu driver ssems to work stable (I tested
> the git branch rtl8xxxu-nextgen, commit 2e23469d74d7).
> However, thoughput is less than one half compared
> to the vendor driver.  FWIW, rtlwifi seems to be a bit
> faster when it works, but thoughput fluctuates a lot
> and eventually it stalls.  (Tested with iperf TCP in both
> directions.)
>
> From dmesg:
> [21725.096068] usb 1-2.1: RTL8188CU rev A (TSMC) 1T1R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
> [21725.096072] usb 1-2.1: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
> [21725.096179] usb 1-2.1: Firmware revision 80.0 (signature 0x88c1)

Thank you, these kind of reports are valuable. Please keep them coming.

-- 
Kalle Valo
