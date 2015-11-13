Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:34852 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbKMX4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 18:56:16 -0500
Received: by oige206 with SMTP id e206so58526468oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 15:56:15 -0800 (PST)
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Nov 2015 15:55:55 -0800
Message-ID: <CALCETrWLyoQSo=oxSJjwf4POWZOCQbA+gV75drp4=ndKssp2sg@mail.gmail.com> (sfid-20151114_005620_231892_09F4F76E)
Subject: BCM4350 doesn't resume correctly
To: Linux Wireless List <linux-wireless@vger.kernel.org>
Cc: brcm80211-dev-list@broadcom.com,
	Hante Meuleman <meuleman@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a BCM4350: 3a:00.0 Network controller: Broadcom Corporation
Device 43a3 (rev 08).  It's a Dell M.2 wireless card.  This card is
supported in wireless-testing but not in 4.3.

On resume, my wireless doesn't come up.  When I manually turn on the
link (by telling NetworkManager to turn it on), it works.  After
suspend/resume, the same thing happens: it's down on resume.

I'm running:

commit b7da5ccdf418f418504e1c923e954ec8ff1a690c
Merge: 588e8c7e5828 6a13feb9c828
Author: John W. Linville <linville@tuxdriver.com>
Date:   Sun Nov 1 22:54:21 2015 -0500

    Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

On startup, I see:

[   12.372523] brcmfmac 0000:3a:00.0: Direct firmware load for
brcm/brcmfmac4350-pcie.txt failed with error -2
[   12.773308] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
wl0: Oct 22 2015 06:16:26 version 7.35.180.119 (r594535)
FWID 01-e791c176
[   12.824257] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code
[   12.841957] brcmfmac 0000:3a:00.0 wlp58s0: renamed from wlan0
[   12.934565] cfg80211: Regulatory domain changed to country: US
[   12.934574] cfg80211:  DFS Master region: FCC
[   12.934578] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   12.934584] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 3000 mBm), (N/A)
[   12.934589] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (N/A)
[   12.934594] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz,
160000 KHz AUTO), (N/A, 2300 mBm), (0 s)
[   12.934598] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz),
(N/A, 2300 mBm), (0 s)
[   12.934602] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 3000 mBm), (N/A)
[   12.934606] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 4000 mBm), (N/A)

On suspend, I see:

[  287.918251] PM: Suspending system (mem)
[  287.918289] Suspending console(s) (use no_console_suspend to debug)
[  287.971508] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[  288.072876] Trying to free nonexistent resource
<000000000000e000-000000000000e0ff>
[  288.073213] PM: suspend of devices complete after 154.508 msecs
[  288.090623] PM: late suspend of devices complete after 17.382 msecs

On resume, I see:

[  393.420929] Restarting tasks ... done.
[  393.429976] brcmfmac 0000:3a:00.0: Direct firmware load for
brcm/brcmfmac4350-pcie.txt failed with error -2
[  393.437524] Bluetooth: hci0: BCM: chip id 110
[  393.453610] Bluetooth: hci0: BCM4350C5
[  393.454702] Bluetooth: hci0: BCM (003.006.007) build 0000
[  393.454747] bluetooth hci0: Direct firmware load for
brcm/BCM-0a5c-6412.hcd failed with error -2
[  393.454749] Bluetooth: hci0: BCM: Patch brcm/BCM-0a5c-6412.hcd not found
[  393.843353] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
wl0: Oct 22 2015 06:16:26 version 7.35.180.119 (r594535) FWID
01-e791c176
[  393.977421] brcmfmac 0000:3a:00.0 wlp58s0: renamed from wlan0
[  393.992239] IPv6: ADDRCONF(NETDEV_UP): wlp58s0: link is not ready
[  394.028531] [drm] RC6 on
[  394.058332] psmouse serio1: synaptics: queried max coordinates: x
[..5666], y [..4734]
[  394.090839] psmouse serio1: synaptics: queried min coordinates: x
[1276..], y [1118..]
[  394.154720] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[  394.165695] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[  394.176704] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[  394.187710] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[  394.198716] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[  394.198768] [drm:intel_dp_aux_ch [i915]] *ERROR* dp_aux_ch not done
status 0xad40001f
[  394.232446] ACPI Error: Cannot release Mutex [PATM], not acquired
(20150818/exmutex-376)
[  394.232470] ACPI Error: Method parse/execution failed
[\_SB.PCI0.LPCB.ECDV._Q66] (Node ffff8802b80e40c8),
AE_AML_MUTEX_NOT_ACQUIRED (20150818/psparse-542)
[  395.353559] [drm:intel_dp_start_link_train [i915]] *ERROR* failed
to enable link training
[  395.545714] [drm:intel_dp_complete_link_train [i915]] *ERROR*
failed to start channel equalization
[  402.469923] ACPI Error: Thread 3073727168 cannot release Mutex
[PATM] acquired by thread 789184512 (20150818/exmutex-399)
[  402.469947] ACPI Error: Method parse/execution failed
[\_SB.PCI0.LPCB.ECDV._Q66] (Node ffff8802b80e40c8), AE_AML_NOT_OWNER
(20150818/psparse-542)
[  402.497264] ACPI Error: Thread 3063757952 cannot release Mutex
[PATM] acquired by thread 789184512 (20150818/exmutex-399)
[  402.497287] ACPI Error: Method parse/execution failed
[\_SB.PCI0.LPCB.ECDV._Q66] (Node ffff8802b80e40c8), AE_AML_NOT_OWNER
(20150818/psparse-542)
[  404.415817] ACPI Error: Cannot release Mutex [PATM], not acquired
(20150818/exmutex-376)
[  404.415839] ACPI Error: Method parse/execution failed
[\_SB.PCI0.LPCB.ECDV._Q66] (Node ffff8802b80e40c8),
AE_AML_MUTEX_NOT_ACQUIRED (20150818/psparse-542)
[  416.993953] brcmfmac: brcmf_add_if: ERROR: netdev:wlp58s0 already exists
[  416.993970] brcmfmac: brcmf_add_if: ignore IF event
[  417.000685] IPv6: ADDRCONF(NETDEV_UP): wlp58s0: link is not ready
[  417.041802] brcmfmac: brcmf_add_if: ERROR: netdev:wlp58s0 already exists
[  417.041807] brcmfmac: brcmf_add_if: ignore IF event
[  417.062367] IPv6: ADDRCONF(NETDEV_UP): wlp58s0: link is not ready
[  423.052617] IPv6: ADDRCONF(NETDEV_CHANGE): wlp58s0: link becomes ready
[  428.864400] Adjusting tsc more than 11% (8039090 vs 7759456)
[ 1198.826626] dell_wmi: Unknown key 152 pressed
[ 1199.828947] dell_wmi: Unknown key 152 pressed
[ 1200.642196] dell_wmi: Unknown key 152 pressed
[ 1441.395793] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]
has bogus alignment
[ 1441.919989] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[ 1441.930976] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[ 1441.941990] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[ 1441.952995] [drm:intel_dp_aux_ch [i915]] *ERROR* dp aux hw did not
signal timeout (has irq: 1)!
[ 1441.958506] brcmfmac: brcmf_cfg80211_reg_notifier: not a ISO3166 code


I assume that's what's causing the problem.

Thanks,
Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
