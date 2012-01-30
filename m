Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44127 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2A3ToB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:44:01 -0500
Received: by wgbed3 with SMTP id ed3so5052091wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 11:44:00 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 30 Jan 2012 20:43:59 +0100
Message-ID: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com> (sfid-20120130_204406_002643_05C8E7B9)
Subject: 
From: Laurent Bonnans <bonnans.l@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
some APs on my laptop with an AR9285 Wireless card.

dhcp works fine on an open wifi network but receives no response on a
wep network I use. I haven't been able to test it on a third network
for now.
Reverting to 3.2.1 solved the issue which is still there in the latest
git revision as of today.

DHCPDISCOVER requests are still sent but no ACK is received (nothing
in Wireshark).

dhcp failure may be one particular instance of the problem but I
haven't been able to connect with a static ip (my ap doesn't like it)
so this is the
only result I know.


ver_linux output (latest git kernel) :

Linux litbox 3.3.0-rc1-hack-00383-g0a96265 #1 SMP PREEMPT Mon Jan 30
02:22:54 CET 2012 x86_64 Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
GenuineIntel GNU/Linux

Gnu C                  4.6.2
Gnu make               3.82
binutils               2.22.0.20111227
util-linux             2.20.1
mount                  support
module-init-tools      4
e2fsprogs              1.42
jfsutils               1.1.15
reiserfsprogs          3.6.21
xfsprogs               3.1.7
pcmciautils            018
PPP                    2.4.5
Linux C Library        2.15
Dynamic linker (ldd)   2.15
Linux C++ Library      so.6.0
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15.3
Sh-utils               8.15
wireless-tools         29
Modules Loaded         ipv6 cpufreq_ondemand fuse xts gf128mul
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
v4l2_compat_ioctl32 media arc4 ath9k ath9k_common ath9k_hw nouveau
ehci_hcd usbcore i915 snd_hda_codec_hdmi snd_hda_codec_realtek joydev
ath ttm intel_ips mac80211 cfg80211 asus_laptop sparse_keymap rfkill
drm_kms_helper drm snd_hda_intel snd_hda_codec snd_hwdep mxm_wmi
psmouse i2c_algo_bit serio_raw i2c_core pcspkr input_polldev mei
iTCO_wdt usb_common evdev intel_agp iTCO_vendor_support intel_gtt
atl1c wmi video snd_pcm snd_page_alloc snd_timer snd soundcore thermal
battery ac button tun kvm_intel kvm aes_x86_64 aes_generic
acpi_cpufreq mperf processor freq_table ext4 crc16 jbd2 mbcache
dm_crypt dm_mod sd_mod ahci libahci libata scsi_mod
