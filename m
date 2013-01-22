Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52620 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3AVVk6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 16:40:58 -0500
Received: by mail-ob0-f175.google.com with SMTP id tb18so2916012obb.20
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 13:40:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50FF0020.4010607@broadcom.com>
References: <CAG-2HqX=iYXLq9y2+brGP-KtPMh+nKUHttS3DEgPNJKHWVJquw@mail.gmail.com>
 <50FF0020.4010607@broadcom.com>
From: Tom Gundersen <teg@jklm.no>
Date: Tue, 22 Jan 2013 22:40:37 +0100
Message-ID: <CAG-2HqUoVe=P0+JMX=+5QMMbcYu-PvaR4iJ0PTg1g0pAZKzN-A@mail.gmail.com> (sfid-20130122_224103_158155_4A675D7F)
Subject: Re: WARNING: at drivers/net/wireless/brcm80211/brcmsmac/main.c:7539 brcms_c_wait_for_tx_completion
To: Arend van Spriel <arend@broadcom.com>
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

Thanks for the quick reply.

On Tue, Jan 22, 2013 at 10:09 PM, Arend van Spriel <arend@broadcom.com> wrote:
> Always too bad when getting a trace like this. It would be good to have
> a bit more context so could you provide 10-20 lines before and after
> this WARNING.

Nothing interesting happens before the warning. After the warning
occurs my network (as expected?) stops working, I therefore manually
disconnect and reconnect it (in NetworkManager), which you can see in
the log below. It then (mostly?) works as normal.

Cheers,

Tom

-- Logs begin at Tue 2013-01-22 18:57:40 CET, end at Tue 2013-01-22
22:30:45 CET. --
Jan 22 19:07:04 toms-air kernel: ------------[ cut here ]------------
Jan 22 19:07:04 toms-air kernel: WARNING: at
drivers/net/wireless/brcm80211/brcmsmac/main.c:7539
brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]()
Jan 22 19:07:04 toms-air kernel: Hardware name: MacBookAir5,1
Jan 22 19:07:04 toms-air kernel: Modules linked in: efivars
hid_generic mousedev hid_apple usbhid bcm5974 brcmsmac cordic mac80211
snd_hda_codec_hdmi snd_hda_codec_cirrus brcmutil i915 cfg80211
kvm_intel kvm rfkill i2c_algo_bit snd_hda_intel intel_agp intel_gtt
snd_hda_codec drm_kms_helper snd_hwdep aesni_intel aes_x86_64 snd_pcm
xhci_hcd ehci_pci applesmc ehci_hcd input_polldev drm microcode
led_class snd_page_alloc snd_timer usbcore snd bcma agpgart soundcore
usb_common battery acpi_cpufreq mperf ac evdev processor
Jan 22 19:07:04 toms-air kernel: Pid: 84, comm: kworker/u:7 Not
tainted 3.8.0-rc4-TEG #2
Jan 22 19:07:04 toms-air kernel: Call Trace:
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81043e9f>]
warn_slowpath_common+0x7f/0xc0
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81043efa>]
warn_slowpath_null+0x1a/0x20
Jan 22 19:07:04 toms-air kernel:  [<ffffffffa04ca32b>]
brcms_c_wait_for_tx_completion+0xab/0xc0 [brcmsmac]
Jan 22 19:07:04 toms-air kernel:  [<ffffffffa04bd8ab>]
brcms_ops_flush+0x3b/0x60 [brcmsmac]
Jan 22 19:07:04 toms-air kernel:  [<ffffffffa04317b3>]
ieee80211_scan_work+0x1b3/0x630 [mac80211]
Jan 22 19:07:04 toms-air kernel:  [<ffffffff810615d2>]
process_one_work+0x132/0x4f0
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81078cd1>] ? get_parent_ip+0x11/0x50
Jan 22 19:07:04 toms-air kernel:  [<ffffffffa0431600>] ?
ieee80211_run_deferred_scan+0x90/0x90 [mac80211]
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81062cfd>] worker_thread+0x15d/0x450
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81062ba0>] ?
busy_worker_rebind_fn+0x100/0x100
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81068d00>] kthread+0xc0/0xd0
Jan 22 19:07:04 toms-air kernel:  [<ffffffff815f0000>] ? register_cpu+0x4e/0xc5
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81068c40>] ?
kthread_create_on_node+0x130/0x130
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81602d1c>] ret_from_fork+0x7c/0xb0
Jan 22 19:07:04 toms-air kernel:  [<ffffffff81068c40>] ?
kthread_create_on_node+0x130/0x130
Jan 22 19:07:04 toms-air kernel: ---[ end trace 2264c0238d7b0ba5 ]---
Jan 22 19:07:05 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 157
Jan 22 19:07:05 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 157
Jan 22 19:24:59 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 1
Jan 22 19:24:59 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 1
Jan 22 19:24:59 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 1
Jan 22 19:24:59 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 1
Jan 22 19:47:20 toms-air kernel: ALSA sound/pci/hda/hda_intel.c:2300
0000:00:1b.0: Unstable LPIB (131024 >= 8192); disabling LPIB delay
counting
Jan 22 20:31:58 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: activated -> disconnected (reason 'user-requested') [100
30 39]
Jan 22 20:31:58 toms-air NetworkManager[254]: <info> (wlp2s0):
deactivating device (reason 'user-requested') [39]
Jan 22 20:31:58 toms-air NetworkManager[254]: <info> (wlp2s0):
canceled DHCP transaction, DHCP client pid 296
Jan 22 20:31:58 toms-air kernel: wlp2s0: deauthenticating from
f4:ca:e5:d9:f7:e0 by local choice (reason=3)
Jan 22 20:31:58 toms-air kernel: brcmsmac bcma0:0: brcmsmac:
brcms_ops_bss_info_changed: disassociated
Jan 22 20:31:58 toms-air kernel: brcmsmac bcma0:0:
brcms_ops_bss_info_changed: arp filtering: enabled false, count 1
(implement)
Jan 22 20:31:58 toms-air kernel: brcmsmac bcma0:0:
brcms_ops_bss_info_changed: qos enabled: false (implement)
Jan 22 20:31:58 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: completed -> disconnected
Jan 22 20:31:58 toms-air kernel: cfg80211: Calling CRDA to update
world regulatory domain
Jan 22 20:31:58 toms-air dbus-daemon[260]: dbus[260]: [system]
Activating service name='org.freedesktop.nm_dispatcher' (using
servicehelper)
Jan 22 20:31:58 toms-air dbus[260]: [system] Activating service
name='org.freedesktop.nm_dispatcher' (using servicehelper)
Jan 22 20:31:58 toms-air dbus-daemon[260]: dbus[260]: [system]
Successfully activated service 'org.freedesktop.nm_dispatcher'
Jan 22 20:31:58 toms-air dbus[260]: [system] Successfully activated
service 'org.freedesktop.nm_dispatcher'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) starting connection 'tomicko'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: disconnected -> prepare (reason 'none') [30 40 0]
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) scheduled...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) started...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) scheduled...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) complete.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) starting...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: prepare -> config (reason 'none') [40 50 0]
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0/wireless): access point 'tomicko' has security, but secrets
are required.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: config -> need-auth (reason 'none') [50 60 0]
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) complete.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) scheduled...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) started...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: need-auth -> prepare (reason 'none') [60 40 0]
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) scheduled...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 1 of 5 (Device Prepare) complete.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) starting...
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: prepare -> config (reason 'none') [40 50 0]
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0/wireless): connection 'tomicko' has security, and secrets
exist.  No new secrets needed.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: added
'ssid' value 'tomicko'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: added
'scan_ssid' value '1'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: added
'key_mgmt' value 'WPA-PSK'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: added
'auth_alg' value 'OPEN'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: added
'psk' value '<omitted>'
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 2 of 5 (Device Configure) complete.
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> Config: set
interface ap_scan to 1
Jan 22 20:32:00 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: disconnected -> scanning
Jan 22 20:32:04 toms-air kernel: wlp2s0: authenticate with f4:ca:e5:d9:f7:e0
Jan 22 20:32:04 toms-air kernel: wlp2s0: send auth to
f4:ca:e5:d9:f7:e0 (try 1/3)
Jan 22 20:32:04 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: scanning -> authenticating
Jan 22 20:32:04 toms-air kernel: wlp2s0: authenticated
Jan 22 20:32:04 toms-air kernel: wlp2s0: associate with
f4:ca:e5:d9:f7:e0 (try 1/3)
Jan 22 20:32:04 toms-air kernel: wlp2s0: RX AssocResp from
f4:ca:e5:d9:f7:e0 (capab=0x411 status=0 aid=1)
Jan 22 20:32:04 toms-air kernel: brcmsmac bcma0:0: brcmsmac:
brcms_ops_bss_info_changed: associated
Jan 22 20:32:04 toms-air kernel: brcmsmac bcma0:0:
brcms_ops_bss_info_changed: arp filtering: enabled true, count 0
(implement)
Jan 22 20:32:04 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: authenticating -> associating
Jan 22 20:32:04 toms-air kernel: brcmsmac bcma0:0:
brcms_ops_bss_info_changed: qos enabled: true (implement)
Jan 22 20:32:04 toms-air kernel: wlp2s0: associated
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: associating -> 4-way handshake
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: 4-way handshake -> group handshake
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0):
supplicant interface state: group handshake -> completed
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0/wireless) Stage 2 of 5 (Device Configure) successful.
Connected to wireless network 'tomicko'.
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 3 of 5 (IP Configure Start) scheduled.
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 3 of 5 (IP Configure Start) started...
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: config -> ip-config (reason 'none') [50 70 0]
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Beginning DHCPv4 transaction (timeout in 45 seconds)
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> dhclient started
with pid 11660
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Beginning IP6 addrconf.
Jan 22 20:32:05 toms-air avahi-daemon[259]: Withdrawing address record
for fe80::9afe:94ff:fe3f:c618 on wlp2s0.
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 3 of 5 (IP Configure Start) complete.
Jan 22 20:32:05 toms-air dhclient[11660]: Internet Systems Consortium
DHCP Client 4.2.4-P2
Jan 22 20:32:05 toms-air dhclient[11660]: Copyright 2004-2012 Internet
Systems Consortium.
Jan 22 20:32:05 toms-air dhclient[11660]: All rights reserved.
Jan 22 20:32:05 toms-air dhclient[11660]: For info, please visit
https://www.isc.org/software/dhcp/
Jan 22 20:32:05 toms-air dhclient[11660]:
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0): DHCPv4
state changed nbi -> preinit
Jan 22 20:32:05 toms-air dhclient[11660]: Listening on
LPF/wlp2s0/98:fe:94:3f:c6:18
Jan 22 20:32:05 toms-air dhclient[11660]: Sending on
LPF/wlp2s0/98:fe:94:3f:c6:18
Jan 22 20:32:05 toms-air dhclient[11660]: Sending on   Socket/fallback
Jan 22 20:32:05 toms-air dhclient[11660]: DHCPREQUEST on wlp2s0 to
255.255.255.255 port 67
Jan 22 20:32:05 toms-air dhclient[11660]: DHCPACK from 192.168.1.254
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> (wlp2s0): DHCPv4
state changed preinit -> reboot
Jan 22 20:32:05 toms-air NetworkManager[254]: <info>   address 192.168.1.14
Jan 22 20:32:05 toms-air NetworkManager[254]: <info>   prefix 24 (255.255.255.0)
Jan 22 20:32:05 toms-air NetworkManager[254]: <info>   gateway 192.168.1.254
Jan 22 20:32:05 toms-air NetworkManager[254]: <info>   nameserver '8.8.4.4'
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv4 Configure Commit) scheduled...
Jan 22 20:32:05 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv4 Commit) started...
Jan 22 20:32:05 toms-air dhclient[11660]: bound to 192.168.1.14 --
renewal in 20390 seconds.
Jan 22 20:32:05 toms-air kernel: brcmsmac bcma0:0:
brcms_ops_bss_info_changed: arp filtering: enabled true, count 1
(implement)
Jan 22 20:32:06 toms-air NetworkManager[254]: <info> (wlp2s0): device
state change: ip-config -> activated (reason 'none') [70 100 0]
Jan 22 20:32:06 toms-air NetworkManager[254]: <info> Policy set
'tomicko' (wlp2s0) as default for IPv4 routing and DNS.
Jan 22 20:32:06 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) successful, device activated.
Jan 22 20:32:06 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv4 Commit) complete.
Jan 22 20:32:07 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv6 Commit) scheduled...
Jan 22 20:32:07 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv6 Commit) started...
Jan 22 20:32:08 toms-air NetworkManager[254]: <info> Policy set
'tomicko' (wlp2s0) as default for IPv6 routing and DNS.
Jan 22 20:32:08 toms-air NetworkManager[254]: <info> Activation
(wlp2s0) Stage 5 of 5 (IPv6 Commit) complete.
Jan 22 20:37:58 toms-air kernel: brcmsmac bcma0:0:
brcms_c_ampdu_dotxstatus_complete: Pkt tx suppressed, illegal channel
possibly 165
