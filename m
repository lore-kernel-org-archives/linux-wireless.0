Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37926 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754450AbXGHQW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 12:22:28 -0400
Message-ID: <46910F3F.8010201@warmcat.com>
Date: Sun, 08 Jul 2007 17:22:23 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: Arrested Development
References: <468DE699.9040708@warmcat.com> <468E48AF.10109@gentoo.org> <468E5C33.2000102@warmcat.com> <20070708140054.GA28113@deine-taler.de>
In-Reply-To: <20070708140054.GA28113@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulrich Kunitz wrote:
> On 07-07-06 16:13 Andy Green wrote:
> 
>> Daniel Drake wrote:
>>> Andy Green wrote:
>>>> Second is a small patch for zd1211rw-mac80211 that fixes rate reporting
>>>> on radiotap rx, last sent here 11 June.
>>>>
>>>> http://www.spinics.net/lists/linux-wireless/msg02897.html
>> ...
>>> Are we really sure we need another rate conversion function? there are
>>> already a couple in the mac80211 driver, and one or 2 extra (for RTS/CTS
>>> rate programming) in the softmac driver.
> 
> I have created a commit (24b5500dc) in my Git tree that
> implements Andy's patch. I didn't introduce a new rate conversion
> function, but changed only zd_rx_rate(). The function is only used
> for filling the ieee80211_rx_status structure.

Thank Uli.

I tested current wireless-dev git + my radiotap injection try#13 set +
your zd1211rw.git-24b5500dc4b7fce0ff59e722376e920d7a1e2f7e.patch which
implements the radiotap rate fix.

I was able to see beacons reported as 1Mbps, but as usual with Monitor
mode for me for some reason it didn't really seem to show what was
actually on the air very well.  This is with tcpdump.

I rebooted into the new kernel and did this only

# iwconfig wlan0 mode monitor
# ifconfig wlan0 up
# iwconfig wlan0 channel 6
# tcpdump -i wlan0

But all I could see were beacons, this is despite I am ssh-d into that
box over the same channel 6 network with WPA and should surely be seeing
the encrypted packets?

I tried also

# ifconfig wlan0 promisc

but it didn't really help.  Then I decided to start wpa_supplicant (this
is an FC6 box so it was service wpa_supplicant start) and I got this oops:

Oops: 0000 [#1]
SMP
CPU:    0
EIP:    0060:[<d81f3ff7>]    Not tainted VLI
EFLAGS: 00010246   (2.6.22-rc7 #1)
EIP is at zd_mac_config_interface+0xc/0x35 [zd1211rw_mac80211]
eax: 00000000   ebx: d5bf10c0   ecx: d10b5d88   edx: 00000000
esi: d4b63000   edi: d10b5da8   ebp: d10b5d78   esp: d10b5d74
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process wpa_supplicant (pid: 2678, ti=d10b5000 task=d17f88b0
task.ti=d10b5000)
Stack: d81f7140 d10b5db4 d81cc9ab 00000000 d5bf02e0 00000004 00000000
00000000
       00000000 00000000 00000000 00000000 00000000 d5bf02e0 d5bf0b10
00000000
       d10b5dbc d81cc9c3 d10b5de4 d81da82b d7127140 d77cf960 00000000
00000000
Call Trace:
 [<c0405e6a>] show_trace_log_lvl+0x1a/0x2f
 [<c0405f1a>] show_stack_log_lvl+0x9b/0xa3
 [<c04060da>] show_registers+0x1b8/0x289
 [<c04062bc>] die+0x111/0x226
 [<c0614a87>] do_page_fault+0x438/0x504
 [<c06133fa>] error_code+0x72/0x78
 [<d81cc9ab>] __ieee80211_if_config+0xf2/0xfe [mac80211]
 [<d81cc9c3>] ieee80211_if_config+0xc/0xe [mac80211]
 [<d81da82b>] ieee80211_sta_start_scan+0x169/0x19f [mac80211]
 [<d81da8a7>] ieee80211_sta_req_scan+0x46/0x85 [mac80211]
 [<d81d6045>] ieee80211_ioctl_siwscan+0x7a/0x83 [mac80211]
 [<c060d148>] ioctl_standard_call+0x1f9/0x2c5
 [<c060d2c0>] wext_handle_ioctl+0xac/0x375
 [<c05b1416>] dev_ioctl+0x41a/0x439
 [<c05a5c79>] sock_ioctl+0x1be/0x1c9
 [<c048782f>] do_ioctl+0x23/0xa3
 [<c0487af8>] vfs_ioctl+0x249/0x25c
 [<c0487b54>] sys_ioctl+0x49/0x61
 [<c0404e26>] sysenter_past_esp+0x5f/0x99
 =======================
Code: 5c 89 e5 c7 80 a4 27 00 00 01 00 00 00 5d c3 55 0f b6 12 8b 40 5c
89 e5 e8 e5 f3 ff ff 5d c3 55 89 e5 53 8b 51 04 8b 58 5c 31 c0 <8a> 0a
f6 c1 01 75 17 8a 42 02 0a 42 01 09 c8 0a 42 03 0a 42 04
EIP: [<d81f3ff7>] zd_mac_config_interface+0xc/0x35 [zd1211rw_mac80211]
SS:ESP 0068:d10b5d74

Well I think the oops in generally interesting but actually I have never
really seen the kind of view from Monitor mode that I think I should
see, there should be a lot more going on under these circumstances than

# tcpdump -i wlan0 -v
tcpdump: WARNING: wlan0: no IPv4 address assigned
tcpdump: listening on wlan0, link-type IEEE802_11_RADIO (802.11 plus BSD
radio information header), capture size 96 bytes
17:06:50.455961 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:50.558905 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:50.660889 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:50.763876 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:50.865863 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:50.967852 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:51.070857 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]
17:06:51.172858 1.0 Mb/s 2437 MHz (0x0480) 100dB signal 0us Beacon[|802.11]

when I am seeing that actual output over ssh on the same channel?  Is it
something to do with having no IP address on that (monitor mode) interface?

-Andy
