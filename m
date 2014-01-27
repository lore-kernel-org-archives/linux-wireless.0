Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:52531 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaA0Gy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 01:54:26 -0500
Date: Mon, 27 Jan 2014 17:54:12 +1100
From: James Cameron <quozl@laptop.org>
To: Olivier Langlois <olivier@trillion01.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
Message-ID: <20140127065412.GA25313@us.netrek.org> (sfid-20140127_075434_674091_D6B7F78C)
References: <1389767820.2436.45.camel@Wailaba2>
 <52D6BEEF.5050705@lwfinger.net>
 <1390804323.2436.172.camel@Wailaba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1390804323.2436.172.camel@Wailaba2>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 01:32:03AM -0500, Olivier Langlois wrote:
> Here is the sequence of events that I have traced that seem to cause my
> audio playback underrun.
> 
> 1. wpa_supplicant send a start_scan request to the nl80211 driver
> 2. mac80211 module call rtl_op_config with IEEE80211_CONF_CHANGE_IDLE
> 3.   rtl_ips_nic_on is called which disable local irqs
> 4.     rtl92c_phy_set_rf_power_state() is called
> 5.       rtl_ps_enable_nic() is called and enable interrupts on the
> device
> 6.   as soon as local irqs are reenabled before exiting rtl_ips_nic_on,
> a RX interrupt is handled and _rtl_pci_interrupt appears to be taking
> about 340 ms to process the interrupt.

Good data.  This discovery now points more firmly at the wireless
driver as a contributing cause.

You might further diagnose this by tracing the timing of the interrupt
handler, to see if it is something the handler calls that causes the
delay, or if it is device access that does it.

-- 
James Cameron
http://quozl.linux.org.au/
