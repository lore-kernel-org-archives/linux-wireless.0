Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46292 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754363Ab2JBPUP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 11:20:15 -0400
Message-ID: <506B0628.6070201@openwrt.org> (sfid-20121002_172024_939777_2177EECD)
Date: Tue, 02 Oct 2012 17:20:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <20121002133533.GA19403@pandem0nium> <CAJ-VmomddCMRxx6Vh_i8AJsqYMUCyguUwFt_PQHpDY7-+Gs88A@mail.gmail.com> <7670031.sYFb4t8Iqn@bentobox>
In-Reply-To: <7670031.sYFb4t8Iqn@bentobox>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-02 5:02 PM, Sven Eckelmann wrote:
> On Tuesday 02 October 2012 07:06:03 Adrian Chadd wrote:
>> Hm, there are still issues on Hornet?
> 
> Yes, we still have problems with hornet. The issue I am trying to "fix" with 
> this patch is an interrupt storm on AR9330 devices with sta interface(s). 
> Random devices crash after getting a stacktrace reporting __report_bad_irq. 
> The crash either results in a reboot or hang of the device
> 
> [  952.950000] irq 2: nobody cared (try booting with the "irqpoll" option)
> [  952.950000] Call Trace:
> [  952.950000] [<8026ade8>] dump_stack+0x8/0x34
> [  952.950000] [<800a75d0>] __report_bad_irq+0x44/0xf4
> [  952.950000] [<800a78ec>] note_interrupt+0x200/0x2a4
> [  952.950000] [<800a58c8>] handle_irq_event_percpu+0x19c/0x1e0
> [  952.950000] [<800a86cc>] handle_percpu_irq+0x54/0x88
> [  952.950000] [<800a501c>] generic_handle_irq+0x3c/0x4c
> [  952.950000] [<80064748>] do_IRQ+0x1c/0x34
> [  952.950000] [<80062d6c>] ret_from_irq+0x0/0x4
> [  952.950000] [<8007673c>] tasklet_action+0xb8/0xd4
> [  952.950000] [<80076c24>] __do_softirq+0xa0/0x154
> [  952.950000] [<80076e30>] do_softirq+0x48/0x68
> [  952.950000] [<80076f94>] local_bh_enable+0x94/0xb0
> [  952.950000] [<83406d60>] cfg80211_scan_done+0x670/0x6d0 [cfg80211]
> [  952.950000] 
> [  952.950000] handlers:
> [  952.950000] [<83564d48>] ath_isr
> [  952.950000] Disabling IRQ #2
> 
> The test setup is using 30 AR9330 devices running OpenWRT 32727/33559. 32727 
> is using compat-wireless-2012-04-17 (+ many OpenWRT patches) and 33559 is 
> running compat-wireless-2012-09-07 (+many more patches from Felix). 1 device 
> is running an open AP device (standard OpenWRT settings) and 29 devices are 
> trying to connect. Random devices will now fail. To debug this problem, I used 
> one devices with 8 vif devices and restarted the network script again and 
> again to force the recreation of the vif and reconnect.
> 
> The stack trace doesn't seem to be very helpful. Therefore, I checked ath_isr 
> and noticed that the interrupts right before the device crash get the status 0 
> from ar9003_hw_get_isr. Digging a little but further also revealed that the 
> interrupts in the interrupt storm also have async_cause 0 and sync_cause 0x20.
> 
> This sync cause 0x20 isn't handled anywhere and may be the cause of the 
> hang/crash. At least this is the symptom which can be fixed without crashing 
> the system.
I checked the AR933x datasheet, and it says that cause 0x20 is tx
descriptor corruption.

- Felix

