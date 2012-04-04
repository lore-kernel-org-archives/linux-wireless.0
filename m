Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:16687 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2DDM4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 08:56:03 -0400
Date: Wed, 4 Apr 2012 15:58:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?5L+e5pmT56OK?= <elioxia@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: possible rtl8192 driver bug: rtl8192ce:rtl92ce_hw_init():<0-0>
 Init MAC failed
Message-ID: <20120404125808.GJ3231@mwanda> (sfid-20120404_145608_007083_CB190B71)
References: <CAPCpjVn88ZjomgF9SbTz_hqNstw7jfD=M9=gEr_qowsVgMefcA@mail.gmail.com>
 <20120404065939.GH3231@mwanda>
 <4F7C0E60.7000409@mva.name>
 <CAPCpjVkUD8qsfC6_0tMZj4AaG7-fzA8R20CQkFzsPTweXRRp0w@mail.gmail.com>
 <CAPCpjVm33s5uyWxtotp-CtD2iTognEmhg7oNAw0zgQa+yHBa1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPCpjVm33s5uyWxtotp-CtD2iTognEmhg7oNAw0zgQa+yHBa1w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 04, 2012 at 07:27:53PM +0800, 俞晓磊 wrote:

[ snipped some unrelated discussion ]

> Back to the wifi issue: I have built the 3.4.0-rc1, and to my surprise
> ubuntu/gnome3 boots without a hiccup, though previous problems still
> exist:
> 1. kernel not detecting wifi device if hard rfkill is enabled;
> workaround by `echo 1 > /sys/bus/pci/rescan`
> 2. rfkill enable/disable does not emit events
> 3. wifi stops to work after toggling rfkill switch;
> 
> I just noticed the line, not sure what it means:
> [  402.542020] rtl8192ce:_rtl92ce_read_adapter_info():<0-0> RTL819X
> Not boot from eeprom, check it !!
> 

Thanks for retesting this on the latest kernel.  This driver has
actually graduated into the stock kernel.  I've added the
wireless people and the maintainers to the CC list.

So rfkill disable and enable cycling, has never worked on this chip?
Which chip is it?  Perhaps do an lspci -vv and a dmesg and attach
them to a reply email.

regards,
dan carpenter

> Best Regards,
> Yu Xiaolei
> 
> 
> uname -a:
> Linux Yu-X370 3.4.0-rc1 #1 SMP Wed Apr 4 18:01:11 CST 2012 x86_64
> x86_64 x86_64 GNU/Linux
> 
> dmesg after rmmod/modprobe:
> [  402.541886] rtl8192ce 0000:03:00.0: enabling device (0000 -> 0003)
> [  402.542020] rtl8192ce:_rtl92ce_read_adapter_info():<0-0> RTL819X
> Not boot from eeprom, check it !!
> [  402.542039] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
> [  402.542292] cfg80211: Updating information on frequency 2412 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542298] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542302] cfg80211: Updating information on frequency 2417 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542306] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542310] cfg80211: Updating information on frequency 2422 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542315] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542318] cfg80211: Updating information on frequency 2427 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542323] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542326] cfg80211: Updating information on frequency 2432 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542331] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542334] cfg80211: Updating information on frequency 2437 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542338] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542342] cfg80211: Updating information on frequency 2442 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542346] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542350] cfg80211: Updating information on frequency 2447 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542354] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542358] cfg80211: Updating information on frequency 2452 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542362] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542366] cfg80211: Updating information on frequency 2457 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542370] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542374] cfg80211: Updating information on frequency 2462 MHz
> for a 20 MHz width channel with regulatory rule:
> [  402.542378] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A
> mBi, 2000 mBm)
> [  402.542382] cfg80211: Disabling freq 2467 MHz as custom regd has no
> rule that fits a 20 MHz wide channel
> [  402.542386] cfg80211: Disabling freq 2472 MHz as custom regd has no
> rule that fits a 20 MHz wide channel
> [  402.542390] cfg80211: Disabling freq 2484 MHz as custom regd has no
> rule that fits a 20 MHz wide channel
> [  402.550461] cfg80211: Ignoring regulatory request Set by core since
> the driver uses its own custom regulatory domain
> [  402.550813] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
> [  402.552431] rtlwifi: wireless switch is on
> [  402.651682] udevd[1630]: renamed network interface wlan0 to wlan7
> [  402.756230] rtl8192ce:_rtl92ce_llt_write():<0-0> Failed to polling
> write LLT done at address 0!
> [  402.756244] rtl8192ce:rtl92ce_hw_init():<0-0> Init MAC failed
> [  402.892957] rtl8192ce:_rtl92ce_llt_write():<0-0> Failed to polling
> write LLT done at address 0!
> [  402.892972] rtl8192ce:rtl92ce_hw_init():<0-0> Init MAC failed
> [  402.995207] rtl8192ce:_rtl92ce_llt_write():<0-0> Failed to polling
> write LLT done at address 0!
> [  402.995222] rtl8192ce:rtl92ce_hw_init():<0-0> Init MAC failed
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
