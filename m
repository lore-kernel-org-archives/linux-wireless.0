Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.mail.unifiedlayer.com ([66.147.249.253]:58993 "HELO
	oproxy1-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753005AbaA0HPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 02:15:16 -0500
Message-ID: <1390806512.2436.180.camel@Wailaba2> (sfid-20140127_081520_992981_F385A552)
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
From: Olivier Langlois <olivier@trillion01.com>
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Jan 2014 02:08:32 -0500
In-Reply-To: <20140127065412.GA25313@us.netrek.org>
References: <1389767820.2436.45.camel@Wailaba2>
	 <52D6BEEF.5050705@lwfinger.net> <1390804323.2436.172.camel@Wailaba2>
	 <20140127065412.GA25313@us.netrek.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-27 at 17:54 +1100, James Cameron wrote:
> On Mon, Jan 27, 2014 at 01:32:03AM -0500, Olivier Langlois wrote:
> > Here is the sequence of events that I have traced that seem to cause my
> > audio playback underrun.
> > 
> > 1. wpa_supplicant send a start_scan request to the nl80211 driver
> > 2. mac80211 module call rtl_op_config with IEEE80211_CONF_CHANGE_IDLE
> > 3.   rtl_ips_nic_on is called which disable local irqs
> > 4.     rtl92c_phy_set_rf_power_state() is called
> > 5.       rtl_ps_enable_nic() is called and enable interrupts on the
> > device
> > 6.   as soon as local irqs are reenabled before exiting rtl_ips_nic_on,
> > a RX interrupt is handled and _rtl_pci_interrupt appears to be taking
> > about 340 ms to process the interrupt.
> 
> Good data.  This discovery now points more firmly at the wireless
> driver as a contributing cause.
> 
> You might further diagnose this by tracing the timing of the interrupt
> handler, to see if it is something the handler calls that causes the
> delay, or if it is device access that does it.
> 
Are printk timestamps considered accurate inside irq handlers? I'm a bit
suspicious about that point because I have added a printk immediatly
after entering _rtl_pci_interrupt() (that I have omitted to show in my
previous e-mail) and it has appeared out of order in the dmesg output:

[   69.376012] rtl8192ce:rtl92ce_sw_led_on():<0-1> LedAddr:4E ledpin=1
[   69.711882] rtl_pci:_rtl_pci_interrupt():<10000-1> entering handler
[   69.376012] rtlwifi:rtl_ips_nic_on():<0-1> before
spin_unlock_irqrestore
[   69.711909] rtl_pci:_rtl_pci_interrupt():<10000-1> after
interrupt_recognized
[   69.711920] rtl_pci:_rtl_pci_interrupt():<10000-1> Rx ok interrupt!
[   69.711948] rtlwifi:rtl_ips_nic_on():<0-0> after
spin_unlock_irqrestore

Is there any kernel debug CONFIGs that could be useful to track down irq
issues?


