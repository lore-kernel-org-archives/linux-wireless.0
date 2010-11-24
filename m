Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64677 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab0KXTGN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 14:06:13 -0500
Received: by fxm13 with SMTP id 13so67845fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 11:06:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101122024208.GA13377@monopoli.naic.edu>
References: <20101122024208.GA13377@monopoli.naic.edu>
Date: Wed, 24 Nov 2010 19:06:12 +0000
Message-ID: <AANLkTikc9w+w8o=ZQBTnTD1=C0+yDVfq=jSfEFQ16dbm@mail.gmail.com>
Subject: Re: orinoco_cs module and WPA not working
From: Dave Kilroy <kilroyd@gmail.com>
To: Giacomo Comes <comes@naic.edu>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 22, 2010 at 2:42 AM, Giacomo Comes <comes@naic.edu> wrote:
> I'm having trouble with a wireless card using the orinoco driver.
>
> The card is (pccardctl ident output):
>
> Socket 2:
>  product info: "Dell", "TrueMobile 1150 Series PC Card", "Version 01.01", ""
>  manfid: 0x0156, 0x0002
>  function: 6 (network)

This is the same card I used to develop the WPA functionality in orinoco.

> I'm running suse 11.3 with kernel 2.6.34.7

> [   14.498825] orinoco_cs 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, Pavel Roskin <proski@gnu.org>, et al)
> [   14.587767] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> [   14.587897] orinoco_cs 2.0: Station identity  001f:0001:0008:000a
> [   14.587906] orinoco_cs 2.0: Firmware determined as Lucent/Agere 8.10
> [   14.587915] orinoco_cs 2.0: firmware: requesting agere_sta_fw.bin
> [   14.698324] orinoco_cs 2.0: Hardware identity 0005:0004:0005:0000
> [   14.698457] orinoco_cs 2.0: Station identity  001f:0002:0009:0030
> [   14.698466] orinoco_cs 2.0: Firmware determined as Lucent/Agere 9.48
> [   14.698472] orinoco_cs 2.0: Ad-hoc demo mode supported
> [   14.698478] orinoco_cs 2.0: IEEE standard IBSS ad-hoc mode supported
> [   14.698483] orinoco_cs 2.0: WEP supported, 104-bit key
> [   14.698489] orinoco_cs 2.0: WPA-PSK supported

This means the driver should have been setup appropriately.

> [...]
> [   32.967560] ADDRCONF(NETDEV_UP): eth1: link is not ready
>
>
> NetworkManager is not able to connect to an AP and /var/log/messages contains:
>
> Nov 12 18:55:22 rescue kernel: [  388.982388] ------------[ cut here ]------------
> Nov 12 18:55:22 rescue kernel: [  388.982427] WARNING: at /usr/src/packages/BUILD/kernel-desktop-2.6.34.7/linux-2.6.34/net/wireless/core.c:633 wdev_cleanup_work+0xb7/0xe0 [cfg80211]()
> Nov 12 18:55:22 rescue kernel: [  388.982432] Hardware name: Latitude C840
> Nov 12 18:55:22 rescue kernel: [  388.982435] Modules linked in: fuse ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit af_packet snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device edd cpufreq_conservative cpufreq_userspace cpufreq_powersave speedstep_ich speedstep_lib mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state iptable_raw iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables x_tables loop dm_mod michael_mic orinoco_cs orinoco cfg80211 rfkill firewire_ohci firewire_core snd_intel8x0m pcmcia crc_itu_t snd_intel8x0 snd_ac97_codec ppdev ac97_bus iTCO_wdt sr_mod snd_pcm parport_pc ohci1394 yenta_socket rsrc_nonstatic dcdbas pcmcia_core ieee1394 3c59x video parport floppy snd_timer sg cdrom iTCO_vendor_support snd battery ac pcspkr joydev soundcore snd_page_alloc shpchp pci_hotplug ext4 jbd2 crc16 nouveau ttm drm_kms_helper drm i2c_algo_bit button intel_agp fan processor ata_generic thermal thermal_sys
> Nov 12 18:55:22 rescue kernel: [  388.982543] Pid: 707, comm: cfg80211 Not tainted 2.6.34.7-0.5-desktop #1
> Nov 12 18:55:22 rescue kernel: [  388.982546] Call Trace:
> Nov 12 18:55:22 rescue kernel: [  388.982570]  [<c02065c3>] try_stack_unwind+0x173/0x190
> Nov 12 18:55:22 rescue kernel: [  388.982580]  [<c02051cf>] dump_trace+0x3f/0xe0
> Nov 12 18:55:22 rescue kernel: [  388.982589]  [<c020662b>] show_trace_log_lvl+0x4b/0x60
> Nov 12 18:55:22 rescue kernel: [  388.982595]  [<c0206658>] show_trace+0x18/0x20
> Nov 12 18:55:22 rescue kernel: [  388.982607]  [<c064e0b3>] dump_stack+0x6d/0x72
> Nov 12 18:55:22 rescue kernel: [  388.982616]  [<c02443ae>] warn_slowpath_common+0x6e/0xb0
> Nov 12 18:55:22 rescue kernel: [  388.982623]  [<c0244403>] warn_slowpath_null+0x13/0x20
> Nov 12 18:55:22 rescue kernel: [  388.982635]  [<e2db5497>] wdev_cleanup_work+0xb7/0xe0 [cfg80211]
> Nov 12 18:55:22 rescue kernel: [  388.982657]  [<c025cfa9>] run_workqueue+0x79/0x170
> Nov 12 18:55:22 rescue kernel: [  388.982665]  [<c025d123>] worker_thread+0x83/0xe0
> Nov 12 18:55:22 rescue kernel: [  388.982673]  [<c025fef4>] kthread+0x74/0x80
> Nov 12 18:55:22 rescue kernel: [  388.982681]  [<c0203826>] kernel_thread_helper+0x6/0x10
> Nov 12 18:55:22 rescue kernel: [  388.982688] ---[ end trace 3f0348b3b0c6f4ff ]---
> Nov 12 18:55:25 rescue dhcpcd[6700]: eth1: dhcpcd not running

I've never seen this before. It looks like a scan is in progress when
cfg80211 tries to do some cleanup - while bringing the interface down.

> Instead of using NetworkManager, I tryed the wireless connection using
> the traditional method with ifup. This time /var/log/messages contains:

<snip ifdown> This log shows the same.

> Nov 14 21:31:21 rescue ifup:     eth1      device: Dell
> Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
> Nov 14 21:31:21 rescue ifup: Version 01.01
> Nov 14 21:31:21 rescue ifup:     eth1      is controlled by ifplugd
> Nov 14 21:31:21 rescue ifup:     eth1      device: Dell
> Nov 14 21:31:21 rescue ifup: TrueMobile 1150 Series PC Card
> Nov 14 21:31:21 rescue ifup: Version 01.01
> Nov 14 21:31:21 rescue ifup-wireless:     eth1      warning: WPA configured, but is untested
> Nov 14 21:31:21 rescue ifup-wireless:     eth1      warning: with this device
> Nov 14 21:31:21 rescue ifup-wireless:     eth1      starting wpa_supplicant
> Nov 14 21:31:21 rescue kernel: [   39.199513] ADDRCONF(NETDEV_UP): eth1: link is not ready
> Nov 14 21:31:22 rescue ifup-dhcp: Starting DHCP4 client on eth1
> Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: dhcpcd 3.2.3 starting
> Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: hardware address = 00:02:2d:70:31:3b
> Nov 14 21:31:22 rescue dhcpcd[3584]: eth1: broadcasting for a lease
> Nov 14 21:31:22 rescue ifup-dhcp: .

<snip dhcp log> This isn't interesting. If wpa_supplicant hasn't
connected you to an AP, dhcpcd isn't going to find anything.

> It first tryes to connect to an AP using WPA, but it fails.
> Thereafter it connects to a second AP using WEP.

Can you provide wpa_supplicant logs? With a reasonable amount of
debug. -dd should do.

> I have also used the latest compat-wireless tarball configured with
> the options:
> CONFIG_MAC80211_HT_DEBUG=y
> CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
> CONFIG_MAC80211_VERBOSE_DEBUG=y

orinoco does not use mac80211.

> My question is:
> Does orinoco_cs really support WPA or not?

Yes.

> Is the problem really with the orinoco_cs module or with something else
> (may be wpa_supplicant)?

Probably a wpa_supplicant configuration issue.

> Another issue I have with the the orinoco_cs module is the following:
> During suspend and resume there is a two minutes timeout period.

> More precisely, after I start to suspend the laptop the screen
> goes black, the message
>             s2disk: snapshotting the system
> appears and then there is a two minutes period where the screen stays black
> and nothing happens. After the two minutes, the messages snapshot ready
> appears, the snapshot image is saved to the disk and the laptop turns off.
> On resume, the kernel founds the snapshot image, loads it and then
> stays two minutes doing nothing. After the two minutes, the text
>                 s2disk: returned to userspace
> appears on screen, there is some disk activity and then the sistem is back.
>
> If I blacklist the orinoco_cs module, then suspend and resume work properly.
>
> I have no idea if the two problems are related or not. If any of the issues
> has been already discussed, please point me where I can find such discussion.

This is new. Depending on your kernel config, orinoco will either try
to keep a copy of firmware which it re-flashes on resume, or try read
the firmware on suspend, which is freed on resume. Both worked circa
2.6.32.

> If you need more informations or you want me to test some code let me know.

A wpa_supplicant log please. Note that the laptop I used to develop
for (and on) has moved on, so there's only a limited number of things
I can do to debug the issue.


Regards,

Dave.
