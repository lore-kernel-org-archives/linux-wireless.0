Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37007 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaHGP2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 11:28:39 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so4278411wgh.27
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 08:28:38 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Aug 2014 11:28:38 -0400
Message-ID: <CAMKDnrkHOsLqXz5p8ZjLRL26N14ZByyM5XQ9b=6a0cB5pPmfqw@mail.gmail.com> (sfid-20140807_172843_023079_8AD2B6F4)
Subject: Carl9170fw loading error
From: Chris C <chris.a.cremer@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am working on a project where I need to be able to modify a wireless
adapter's firmware. I'm trying to use the Netgear WN111v2 with the
carl9170 driver and firmware. Depending on the configurations I set
when building the firmware, I get one of two errors when I try using
the device: 1)failed to parse or 2)tainted. See below.

What I did:
I made the toolchain and got the tools and libs. Then ran ./autogen.sh
and selected some configurations. Then copied the new carl9170.fw file
to /lib/firmware and changed its name to carl9170-1.fw. (Followed the
README https://github.com/chunkeey/carl9170fw)

Here are the errors:

1) If I select 'no' to all options during the autogen configuration,
this is the error I get when inserting the device:

[505796.463525] usb 1-1.4: new high-speed USB device number 15 using ehci_hcd
[505796.679353] usb 1-1.4: reset high-speed USB device number 15 using ehci_hcd
[505796.810127] usb 1-1.4: driver   API: 1.9.4 2011-08-15 [1-1]
[505796.810132] usb 1-1.4: firmware API: 1.9.9 2013-10-25
[505796.810135] usb 1-1.4: Unprotected firmware image.
[505796.810138] usb 1-1.4: firmware does support mandatory features.
[505796.810141] usb 1-1.4: failed to parse firmware (-125).


2) If I select 'yes' to all options except the experimental
extensions, this is the error I get when inserting the device:

[504006.523276] ------------[ cut here ]------------
[504006.523286] WARNING: at
/build/buildd/linux-3.2.0/net/wireless/core.c:436
wiphy_verify_combinations+0x213/0x240 [cfg80211]()
[504006.523289] Hardware name: OptiPlex 790
[504006.523291] Modules linked in: arc4 dm_crypt snd_hda_codec_hdmi
snd_hda_codec_realtek carl9170(O) mac80211 ath cfg80211 snd_hda_intel
snd_hda_codec snd_hwdep snd_pcm dcdbas parport_pc snd_seq_midi
snd_rawmidi ppdev snd_seq_midi_event snd_seq joydev snd_timer
snd_seq_device psmouse snd serio_raw soundcore snd_page_alloc mac_hid
mei(C) rfcomm bnep bluetooth lp parport nfsd nfs lockd fscache
auth_rpcgss nfs_acl sunrpc binfmt_misc usbhid hid e1000e radeon ttm
i915 drm_kms_helper drm i2c_algo_bit video
[504006.523338] Pid: 30107, comm: firmware/carl91 Tainted: G        WC
O 3.2.0-67-generic #101-Ubuntu
[504006.523341] Call Trace:
[504006.523349]  [<ffffffff810683af>] warn_slowpath_common+0x7f/0xc0
[504006.523354]  [<ffffffff8106840a>] warn_slowpath_null+0x1a/0x20
[504006.523361]  [<ffffffffa049e233>]
wiphy_verify_combinations+0x213/0x240 [cfg80211]
[504006.523368]  [<ffffffffa049f395>] wiphy_register+0xc5/0x3f0 [cfg80211]
[504006.523380]  [<ffffffffa04d2235>] ?
ieee80211_register_hw+0xb5/0x650 [mac80211]
[504006.523390]  [<ffffffffa04d2449>]
ieee80211_register_hw+0x2c9/0x650 [mac80211]
[504006.523396]  [<ffffffffa0552044>] carl9170_register+0x294/0x5c0 [carl9170]
[504006.523402]  [<ffffffff81408720>] ? _request_firmware+0x270/0x270
[504006.523407]  [<ffffffffa0553d48>]
carl9170_usb_firmware_step2+0x68/0xe0 [carl9170]
[504006.523412]  [<ffffffff81408761>] request_firmware_work_func+0x41/0x80
[504006.523417]  [<ffffffff8108b8cc>] kthread+0x8c/0xa0
[504006.523422]  [<ffffffff8166deb4>] kernel_thread_helper+0x4/0x10
[504006.523427]  [<ffffffff8108b840>] ? flush_kthread_worker+0xa0/0xa0
[504006.523431]  [<ffffffff8166deb0>] ? gs_change+0x13/0x13
[504006.523434] ---[ end trace df0f0cb5a9397534 ]---


Also, the adapter works when I use the firmware from here:
http://wireless.kernel.org/en/users/Drivers/carl9170#Firmware_binary
And this is what it shows when it works:

[506279.791495] usb 1-1.4: new high-speed USB device number 16 using ehci_hcd
[506280.007316] usb 1-1.4: reset high-speed USB device number 16 using ehci_hcd
[506280.137921] usb 1-1.4: driver   API: 1.9.4 2011-08-15 [1-1]
[506280.137926] usb 1-1.4: firmware API: 1.9.9 2013-10-25
[506280.137957] usb 1-1.4: driver does not support all firmware features.
[506280.491337] ath: EEPROM regdomain: 0x0
[506280.491341] ath: EEPROM indicates default country code should be used
[506280.491343] ath: doing EEPROM country->regdmn map search
[506280.491346] ath: country maps to regdmn code: 0x3a
[506280.491348] ath: Country alpha2 being used: US
[506280.491350] ath: Regpair used: 0x3a

More info:
uname -a:
Linux mims 3.2.0-67-generic #101-Ubuntu SMP Tue Jul 15 17:46:11 UTC
2014 x86_64 x86_64 x86_64 GNU/Linux

Please let me know if there is more useful information I should post.

Best regards,
Chris
