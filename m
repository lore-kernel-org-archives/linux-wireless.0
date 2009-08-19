Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:14456 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbZHSVq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 17:46:26 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1585253qwh.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 14:46:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0908191143y6940d664td6cb39b2021e125b@mail.gmail.com>
References: <8f3763990908191119l37c7dff3y8884b1228059cb22@mail.gmail.com>
	 <b6c5339f0908191143y6940d664td6cb39b2021e125b@mail.gmail.com>
Date: Wed, 19 Aug 2009 14:46:27 -0700
Message-ID: <8f3763990908191446idd219cew146b63546f8b7592@mail.gmail.com>
Subject: Re: bug? sme.c:610 __cfg80211_disconnected
From: ASIC Felix <ic.felix@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 11:43 AM, Bob Copeland<me@bobcopeland.com> wrote:
> On Wed, Aug 19, 2009 at 2:19 PM, ASIC Felix<ic.felix@gmail.com> wrote:
>> Hi,
>>
>> update:
>>   occurs during rekeying/reauth on wpa2 office network
>>   still present in master-2009-08-19
>>
>> Aug 19 11:04:02 darkslate klogd: WARNING: at net/wireless/sme.c:613
>> __cfg80211_disconnected+0x1bc/0x210 [cfg80211]()
>
> Please post the entire warning's stack trace inline (i.e.
> not as an attachment).
>
> I looked at your previous email in which you had attached
> the log, and it looked like ath9k was the wireless driver,
> though it could be a bug in {mac,cfg}80211 as well.  It's
> impossible to tell just from this one line though.
>
> --
> Bob Copeland %% www.bobcopeland.com
>

Hi,

I'm afraid gmail will break the lines. Apologies, am not used to
submitting issues.

Best regards,
Felix


Aug 19 12:29:33 darkslate pulseaudio[4195]: alsa-sink.c: Increasing
wakeup watermark to 109.80 ms
Aug 19 12:34:15 darkslate klogd: ------------[ cut here ]------------
Aug 19 12:34:15 darkslate klogd: WARNING: at net/wireless/sme.c:613
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]()
Aug 19 12:34:15 darkslate klogd: Hardware name: 1875DLU
Aug 19 12:34:15 darkslate klogd: deauth failed: -67
Aug 19 12:34:15 darkslate klogd: Modules linked in: aes_i586
aes_generic xt_time xt_connlimit xt_realm iptable_raw xt_comment
ipt_ULOG ipt_REJECT ipt_REDIRECT ipt_NETMAP ipt_MASQUERADE ipt_LOG
ipt_ECN ipt_ecn ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic
nf_nat_sip nf_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323
nf_nat_ftp nf_nat_amanda ts_kmp nf_conntrack_amanda nf_conntrack_tftp
nf_conntrack_sip nf_conntrack_pptp nf_conntrack_proto_gre
nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_recent xt_pkttype
xt_physdev xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport
xt_MARK xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper
xt_hashlimit xt_DSCP xt_dscp xt_dccp xt_conntrack xt_CONNMARK
xt_connmark xt_CLASSIFY xt_tcpudp xt_state iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack iptable_mangle nfnetlink
iptable_filter ip_tables x_tables i915 drm i2c_algo_bit af_packet
bridge stp llc bnep sco ipv6 rfcomm l2cap bluetooth binfmt_
Aug 19 12:34:15 darkslate klogd: isc loop fuse cpufreq_ondemand
cpufreq_conservative cpufreq_powersave acpi_cpufreq freq_table
snd_intel8x0 snd_ac97_codec ac97_bus snd_seq_dummy arc4 snd_seq_oss
snd_seq_midi_event snd_seq tg3 ecb ath9k mac80211 libphy sg i2c_i801
i2c_core iTCO_wdt iTCO_vendor_support rtc_cmos nsc_ircc snd_seq_device
snd_pcm_oss ath cfg80211 sr_mod yenta_socket rsrc_nonstatic
pcmcia_core video thinkpad_acpi ehci_hcd joydev intel_agp agpgart
nvram uhci_hcd snd_pcm snd_timer snd_mixer_oss rfkill led_class irda
pcspkr evdev battery thermal button processor ac output snd soundcore
snd_page_alloc crc_ccitt usbcore ata_generic ide_pci_generic
ide_gd_mod ide_core pata_acpi ata_piix ahci libata sd_mod scsi_mod
crc_t10dif ext3 jbd
Aug 19 12:34:15 darkslate klogd: Pid: 1145, comm: phy0 Tainted: G   M
 W  2.6.31-rc6-wl-mnbStrip-31629-gff03a4c #66
Aug 19 12:34:15 darkslate klogd: Call Trace:
Aug 19 12:34:15 darkslate klogd:  [<f7fc592c>] ?
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<f7fc592c>] ?
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<c013c53c>] warn_slowpath_common+0x6c/0xc0
Aug 19 12:34:15 darkslate klogd:  [<f7fc592c>] ?
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<c013c5d6>] warn_slowpath_fmt+0x26/0x30
Aug 19 12:34:15 darkslate klogd:  [<f7fc592c>]
__cfg80211_disconnected+0x1bc/0x210 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<f7fc1e11>] ?
nl80211_send_deauth+0x21/0x30 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<f7fc3054>]
__cfg80211_send_deauth+0x224/0x270 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<f84592c0>] ?
ieee80211_set_disassoc+0x180/0x1e0 [mac80211]
Aug 19 12:34:15 darkslate klogd:  [<f7fc30fe>]
cfg80211_send_deauth+0x5e/0x70 [cfg80211]
Aug 19 12:34:15 darkslate klogd:  [<f845afeb>]
ieee80211_sta_work+0xa0b/0x1850 [mac80211]
Aug 19 12:34:15 darkslate klogd:  [<c01412d8>] ? tasklet_action+0x58/0xc0
Aug 19 12:34:15 darkslate klogd:  [<c017d988>] ? handle_IRQ_event+0x58/0x140
Aug 19 12:34:15 darkslate klogd:  [<c011bf3e>] ? ack_apic_level+0x7e/0x270
Aug 19 12:34:15 darkslate klogd:  [<c01300c0>] ? rq_online_rt+0x50/0x70
Aug 19 12:34:15 darkslate klogd:  [<c0138745>] ? dequeue_task_fair+0x295/0x2a0
Aug 19 12:34:15 darkslate klogd:  [<c010256a>] ? __switch_to+0xba/0x1a0
Aug 19 12:34:15 darkslate klogd:  [<c0133296>] ? finish_task_switch+0x56/0xc0
Aug 19 12:34:15 darkslate klogd:  [<c03a9af4>] ? schedule+0x4a4/0xa50
Aug 19 12:34:15 darkslate klogd:  [<c01376a4>] ? try_to_wake_up+0xc4/0x2e0
Aug 19 12:34:15 darkslate klogd:  [<f846742b>] ?
__ieee80211_wake_queue+0x4b/0x60 [mac80211]
Aug 19 12:34:15 darkslate klogd:  [<c015377a>] ? prepare_to_wait+0x3a/0x70
Aug 19 12:34:15 darkslate klogd:  [<c014edd1>] worker_thread+0x141/0x210
Aug 19 12:34:15 darkslate klogd:  [<f845a5e0>] ?
ieee80211_sta_work+0x0/0x1850 [mac80211]
Aug 19 12:34:15 darkslate klogd:  [<c0153530>] ?
autoremove_wake_function+0x0/0x50
Aug 19 12:34:15 darkslate klogd:  [<c014ec90>] ? worker_thread+0x0/0x210
Aug 19 12:34:15 darkslate klogd:  [<c01531dc>] kthread+0x7c/0x90
Aug 19 12:34:15 darkslate klogd:  [<c0153160>] ? kthread+0x0/0x90
Aug 19 12:34:15 darkslate klogd:  [<c0104657>] kernel_thread_helper+0x7/0x10
Aug 19 12:34:15 darkslate klogd: ---[ end trace 121a8403468db170 ]---
Aug 19 12:34:16 darkslate ifplugd(wlan0)[2565]: Link beat lost.
