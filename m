Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbYFIQzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 12:55:18 -0400
Subject: Re: iwl4965 oops in 2.6.26-rc5 x86_64
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Thomas Backlund <tmb@mandriva.org>,
	Ian Schram <ischram@telenet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240806090943s533ae499o35cfc9a9928b3a93@mail.gmail.com>
References: <4848289D.1080205@mandriva.org> <48494EF6.4020506@mandriva.org>
	 <1ba2fa240806060812q28c270c4i12cc08f8665e9cc0@mail.gmail.com>
	 <4849AF9F.9010207@mandriva.org>
	 <1ba2fa240806061659j7672f9d3w107be4509b533f68@mail.gmail.com>
	 <484A8CF5.3060801@mandriva.org>
	 <1ba2fa240806080327gec9b38vf6bb1faa0e5014b8@mail.gmail.com>
	 <484BCECC.4040004@mandriva.org>
	 <1ba2fa240806080831k4fce156an535caec87e374e19@mail.gmail.com>
	 <1213026902.31138.9.camel@localhost.localdomain>
	 <1ba2fa240806090943s533ae499o35cfc9a9928b3a93@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 12:54:56 -0400
Message-Id: <1213030496.31138.23.camel@localhost.localdomain> (sfid-20080609_185527_391435_741C76DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-09 at 19:43 +0300, Tomas Winkler wrote:
> On Mon, Jun 9, 2008 at 6:55 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Sun, 2008-06-08 at 18:31 +0300, Tomas Winkler wrote:
> >> On Sun, Jun 8, 2008 at 3:21 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> >> > Tomas Winkler skrev:
> >> >>
> >> >> I'm not sure what distro are you running I haven't seen this
> >> >> ifcfg-wlan0 config options
> >> >> on my system but can it be that ifcg-wlan0 tries to set wep key which
> >> >> will conflict
> >> >> with wpa_supplicant setting. Can you try to remove this line from that
> >> >> file
> >> >>
> >> >> ifcfg-wlan0 -
> >> >> --- cut ---
> >> >> WIRELESS_ENC_KEY='s:*************************'
> >> >>
> >> >>
> >> >
> >> >
> >> > Nice.
> >> >
> >> > The distro is Mandriva Cooker (development) but we have the same in Mandriva
> >> > 2008.1 Spring.
> >> >
> >> > Now this has not been any problem with kernels older than 2.6.25, so it's a
> >> > regression, isn't it? I mean, shouldn't the module protect itself against
> >> > empty variables?
> >> >
> >> This is not really regression. What happen is that we've enabled hw
> >> crypto acceleration by default so when
> >> you switched back to sw crypto it still worked.
> >> There is bug no question, I believe it's the same bug as Ian Schram
> >> and Joonwoo Park reported (PSK key is longer then 128 WEP Key)
> >
> > I thought that issues was about actual WEP keys larger than 128-bit;
> > some D-Link APs and cards allowed 152-bit WEP keys back before WPA was
> > common.  We decided not to care about those right now, but I didn't
> > think that would impact TKIP at all.  Does the TKIP key material go
> > through the same path in the iwl driver that WEP key material does?
> >
> > Dan
> The problem was that key in ifcfg-wlan0 was used as a WEP key in this
> particular case.  I'm not sure how long it was (only Thomas know) so
> it's just a guess.
> What need to be done that driver should return error if long key is
> assigned and not to crash.

Oh right, definitely.  The driver should be length-checking the keys and
returning EINVAL for WEP key sizes that are not 40 or 104 bit WEP keys.

Dan

> Tomas
> >
> >
> >> > And that config option also exist in Redhat initscripts ifup-wireless...
> >> >
> >> > Anyway, you found the initial problem, as the kernel now booted without an
> >> > oops, and seems to work, but:
> >> >
> >>
> >> Try to disable this one from th config file MAC80211_DEBUG_PACKET_ALIGNMENT
> >>
> >> Thanks
> >> Tomas
> >>
> >> 0: switched to short barker preamble (BSSID=00:19:5b:51:dc:27)
> >> > wlan0 (WE) : Wireless Event too big (320)
> >> > ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> >> > ------------[ cut here ]------------
> >> > WARNING: at net/mac80211/rx.c:319 __ieee80211_rx_handle_packet+0x349/0x794
> >> > [mac80211]()
> >> > Modules linked in: af_packet kvm_intel kvm snd_seq_dummy snd_seq_oss
> >> > snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6
> >> > xt_tcpudp iptable_filter ip_tables x_tables binfmt_misc loop dm_mod
> >> > cpufreq_ondemand cpufreq_conservative cpufreq_powersave acpi_cpufreq
> >> > freq_table tifm_sd tifm_7xx1 tifm_core nvram pcmcia ohci1394 ieee1394
> >> > mmc_block arc4 ecb crypto_blkcipher battery ac video container output
> >> > firewire_ohci firewire_core crc_itu_t sdhci iwl4965 firmware_class mmc_core
> >> > yenta_socket rsrc_nonstatic iwlcore pcmcia_core acer_wmi thermal
> >> > snd_hda_intel rfkill snd_pcsp button nsc_ircc snd_pcm mac80211 led_class
> >> > i2c_i801 irda snd_timer rtc_cmos snd processor rtc_core wmi rtc_lib i2c_core
> >> > soundcore iTCO_wdt iTCO_vendor_support snd_page_alloc tg3 cfg80211 intel_agp
> >> > joydev crc_ccitt sr_mod serio_raw sg evdev cdrom ide_generic piix ide_core
> >> > ata_piix ahci libata dock sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd
> >> > ehci_hcd usbcore [last unloaded: nf_conntrack]
> >> > Pid: 0, comm: swapper Not tainted 2.6.26-0.rc5.1mdvsmp #1
> >> >
> >> > Call Trace:
> >> >  <IRQ>  [<ffffffff802371ff>] warn_on_slowpath+0x58/0x94
> >> >  [<ffffffff8044ad1b>] ? _spin_unlock_irqrestore+0x40/0x57
> >> >  [<ffffffff8023c2f1>] ? __tasklet_schedule+0xae/0xc5
> >> >  [<ffffffffa01eab1e>] ? :mac80211:ieee80211_rx_irqsafe+0x63/0x6a
> >> >  [<ffffffffa0306d32>] ? :iwl4965:iwl4965_handle_data_packet+0x3c3/0x3fd
> >> >  [<ffffffffa01eb1ce>] :mac80211:__ieee80211_rx_handle_packet+0x349/0x794
> >> >  [<ffffffff8025791c>] ? __lock_acquire+0x635/0xd5a
> >> >  [<ffffffffa01eba3c>] ? :mac80211:__ieee80211_rx+0x63/0x538
> >> >  [<ffffffffa01ebe9d>] :mac80211:__ieee80211_rx+0x4c4/0x538
> >> >  [<ffffffffa01dc348>] :mac80211:ieee80211_tasklet_handler+0x75/0x11b
> >> >  [<ffffffff8023c079>] ? tasklet_action+0x4b/0xfb
> >> >  [<ffffffff8023c0be>] tasklet_action+0x90/0xfb
> >> >  [<ffffffff8023cae6>] __do_softirq+0x77/0x101
> >> >  [<ffffffff8020d61c>] call_softirq+0x1c/0x28
> >> >  [<ffffffff8020e92d>] do_softirq+0x4d/0xb0
> >> >  [<ffffffff8023c5ab>] irq_exit+0x4e/0x8f
> >> >  [<ffffffff8020ebc5>] do_IRQ+0xba/0xd8
> >> >  [<ffffffff8020c6f2>] ret_from_intr+0x0/0x1e
> >> >  <EOI>  [<ffffffff8021fe6d>] ? native_irq_enable+0x6/0x7
> >> >  [<ffffffffa018d45a>] ? :processor:acpi_idle_enter_bm+0x2cf/0x35e
> >> >  [<ffffffff803c338a>] ? menu_select+0x6f/0x8f
> >> >  [<ffffffff803c2395>] ? cpuidle_idle_call+0x95/0xc9
> >> >  [<ffffffff803c2300>] ? cpuidle_idle_call+0x0/0xc9
> >> >  [<ffffffff8020b1cc>] ? default_idle+0x0/0x55
> >> >  [<ffffffff8020b184>] ? cpu_idle+0x9c/0xe4
> >> >  [<ffffffff80444e86>] ? start_secondary+0x179/0x17d
> >> >
> >> > ---[ end trace a4f2fe9605e20ed0 ]---
> >> >
> >> >
> >> > --
> >> > Thomas
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >

