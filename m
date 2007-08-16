Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galaxy.systems.pipex.net ([62.241.162.31]:60387 "EHLO
	galaxy.systems.pipex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbXHPVnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 17:43:09 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
Date: Thu, 16 Aug 2007 22:43:05 +0100
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
References: <200708082324.17186.linux@baker-net.org.uk> <200708161625.44057.linux@baker-net.org.uk> <1187278509.23489.24.camel@johannes.berg>
In-Reply-To: <1187278509.23489.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708162243.05809.linux@baker-net.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > I've added some printk's as you suggested, the log is attached. I
> > haven't yet
> > managed to capture this on the serial port so I can't yet guarantee
> > that there
> > aren't any calls that didn't get logged just as it crashed - I'll keep
> > trying.
>
> Ok. I'll look through.

Having now managed to capture a small relevant area it looks like there were a couple of seconds missing from the end of that log file.

>
> > Aug 16 15:53:34 gromit kernel: [  633.972956] wmaster0: Entering
> > ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746 Aug 16 15:53:34 gromit
> > kernel: [  633.972960] Leaving ieee80211_tx_h_multicast_ps_buf
>
> Hm. I thought it crashed in there. Could you put printk's into the two
> functions called from this, and then switch to a console and tell me
> which one shows up last? Elevate the printk priority to something like
> KERN_ERR or change your console to show all messages.
>
My problem is that I'm using a console that can't keep up with logging at
the necessary data rate so I get gaps in the log. I'll try to get the necessary
cables to try a different solution. I think I got the bit we want this time though.

Trying to make sense of this I just noticed that I missed the exit printk on the
TXRX_QUEUED exit from ieee80211_tx_h_multicast_ps_buf but I think I get
a hint of what might be going wrong. The remote device is being added as a
new IBSS station even though it hasn't associated, only probed. Could
something be assuming there is more info recorded for that device than there
really is?

It may be relevant at this point to mention that the remote device is a Nokia
n800 so likely to have fairly aggressive power save settings.

MISSING DATA
[16694.835829] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16694.938310] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16695.040666] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16695.143039] phy7 -> rt2x00usb_interrupt_rxdone
MISSING DATA
[16695.843860] Entering ieee80211_master_start_xmit()
[16695.849097] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[16695.857083] Leaving ieee80211_tx_h_multicast_ps_buf
[16695.862383] Leaving ieee80211_master_start_xmit() ret=0
MISSING DATA
[16696.883214] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16696.952071] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16696.958640] wmaster0: Adding new IBSS station 00:19:4f:9e:b8:ba (dev=wlan1)
[16696.966386] wmaster0: Added STA 00:
MISSING DATA
[16697.804543] phy7 -> rt2x00usb_interrupt_rxdone: Debug - Size 128
[16697.851272] Entering ieee80211_master_start_xmit()
[16697.856499] wmaster0: Entering ieee80211_tx_h_multicast_ps_buf(), hw.flags 1746
[16697.864492] INFO: trying to register non-stat
MISSING DATA
16703.045044] BUG: NMI Watchdog detected LOCKUP on CPU0, eip c022d7fa, registers:
[16703.052642] Modules linked in: nls_cp437 isofs udf rfcomm l2cap bluetooth binfmt_misc cpufreq_powersave cpufreq_stats cpufreq_userspace cpufre
q_ondemand cpufreq_conservative freq_table video output battery container sbs fan dock ac ipv6 nfs lockd sunrpc asb100 hwmon_vid lp pl2303 rt2500
usb arc4 ecb blkcipher rc80211_simple usbserial rt73usb rt2x00usb rt2x00lib input_polldev crc_itu_t mac80211 af_packet tsdev snd_ens1371 gameport
 snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm serio_raw snd_timer parport_pc evdev parport psmouse i2c_vi
apro 8139too i2c_core snd ehci_hcd pcspkr floppy via_ircc uhci_hcd irda 8139cp soundcore snd_page_alloc mii crc_ccitt usbcore shpchp via_agp pci_
hotplug agpgart thermal button processor
[16703.123282] CPU:    0
[16703.123283] EIP:    0060:[<c022d7fa>]    Not tainted VLI
[16703.123285] EFLAGS: 00000046   (2.6.23-rc3 #11)
[16703.135782] EIP is at _raw_spin_lock+0xaa/0x150
[16703.140450] eax: 00000000   ebx: c4f5791c   ecx: 1ec4817c   edx: 665fa417
[16703.147506] esi: 0dd5135f   edi: 00000000   ebp: 6b8ab748   esp: c0453ad8
[16703.154598] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[16703.160664] Process swapper (pid: 0, ti=c0452000 task=c041a3c0 task.ti=c0452000)

