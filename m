Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy19-pub.mail.unifiedlayer.com ([70.40.200.33]:51138 "HELO
	oproxy19-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750895AbaA0GcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 01:32:10 -0500
Message-ID: <1390804323.2436.172.camel@Wailaba2> (sfid-20140127_073213_814442_253C243A)
Subject: Re: [ISSUE] rtl8192ce appears to interfere with ALSA playback
From: Olivier Langlois <olivier@trillion01.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, daniel@zonque.org
Date: Mon, 27 Jan 2014 01:32:03 -0500
In-Reply-To: <52D6BEEF.5050705@lwfinger.net>
References: <1389767820.2436.45.camel@Wailaba2>
	 <52D6BEEF.5050705@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I have not hear back from you since that I provided the information that
you asked me. Did you find something?

I did some investigation on my side and I think that I have narrow down
quite a bit the cause of my problem unless I receive some assistance, I
am not sure that I can advance very much further by myself.

Is this usual for a Wifi device to spend about 340 ms in a irq
handler???

First, something that I have noticed in net/wireless/rtlwifi/core.c,
function rtl_op_config(), there is a call to mdelay(50). I'm pretty much
certain that this delay could be safely replaced with msleep(50). It
should be ok since the function can already sleep by calling
mutex_lock(). Do you agree?

Here is the sequence of events that I have traced that seem to cause my
audio playback underrun.

1. wpa_supplicant send a start_scan request to the nl80211 driver
2. mac80211 module call rtl_op_config with IEEE80211_CONF_CHANGE_IDLE
3.   rtl_ips_nic_on is called which disable local irqs
4.     rtl92c_phy_set_rf_power_state() is called
5.       rtl_ps_enable_nic() is called and enable interrupts on the
device
6.   as soon as local irqs are reenabled before exiting rtl_ips_nic_on,
a RX interrupt is handled and _rtl_pci_interrupt appears to be taking
about 340 ms to process the interrupt.

I have measured that time by placing 2 printks between 

spin_unlock_irqrestore(&rtlpriv->locks.ips_lock, flags);

in rtl_ips_nic_on().

[   69.376012] rtlwifi:rtl_ips_nic_on():<0-1> before
spin_unlock_irqrestore
[   69.711920] rtl_pci:_rtl_pci_interrupt():<10000-1> Rx ok interrupt!
[   69.711948] rtlwifi:rtl_ips_nic_on():<0-0> after
spin_unlock_irqrestore

Also from an exchange that I had with Takashi [1], if my audio buffer
size is 371 msec, the playback is smooth. If it is set to 341 msec, I
have underruns.

notice the proximity of values between the time it takes for rtl8192ce
to service its irq and the audio buffer size causing troubles. I think
that it would be very surprising if it is just a coincidence....

[1]
http://mailman.alsa-project.org/pipermail/alsa-devel/2014-January/071569.html

On Wed, 2014-01-15 at 11:01 -0600, Larry Finger wrote:
> On 01/15/2014 12:37 AM, Olivier Langlois wrote:
> > How to reproduce:
> >
> > 1. Enable Wifi while not connecting to any AP.
> > 2. lano1106@hpmini ~/Music $ aplay -c1 sine.wav
> > underrun!!! (at least 1856093977.967 ms long)
> 
> Olivier,
> 
> I am certain that rtl8192ce does not disable interrupts for 2 sec, but I need 
> some more info from you.
> 
> What is your CPU situation? I suspect x86_64, but please confirm. How many CPUs? 
> What is the maximum CPU speed?
> 
> What distro?
> 
> How do you control the wifi? Is it NetworkManager? This is important because the 
> device driver does not initiate any scans on its own - scans are initiated and 
> controlled by upstream.
> 
> Please provide a URL for the test file sine.wav. If it is part of your distro, 
> then put it in a public repository, or E-mail it to me privately.
> 
> Larry
> 
> 
> 


