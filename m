Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41163 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbZKYP1V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:27:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: RTL8187 warnings on suspend
Date: Wed, 25 Nov 2009 16:26:15 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911251626.15959.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



[   76.758422] queueing ieee80211 work while going to suspend
[   76.758768] ------------[ cut here ]------------
[   76.758927] Badness at net/mac80211/util.c:524
[   76.759080] NIP: f244c71c LR: f244c71c CTR: 00000000
[   76.759249] REGS: ee95bbb0 TRAP: 0700   Not tainted  (2.6.32-rc8-wl-wltest)
[   76.759476] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 22082444  XER: 00000000
[   76.759856] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
[   76.760052] GPR00: f244c71c ee95bc60 efb46000 00000041 00000001 c0041078 00000000 00000002 
[   76.760490] GPR08: 00000000 00000000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
[   76.760927] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
[   76.761364] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 eebccc20 ed520800 eebcc300 
[   76.761858] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.762093] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.762318] Call Trace:
[   76.762415] [ee95bc60] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
[   76.762738] [ee95bc70] [f26370f8] rtl8187_leds_exit+0x28/0x64 [rtl8187]
[   76.762972] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
[   76.763211] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
[   76.763436] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
[   76.763658] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
[   76.763875] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
[   76.764110] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
[   76.764329] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
[   76.764532] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
[   76.764764] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
[   76.764957] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
[   76.765160] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
[   76.765339] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
[   76.765555] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
[   76.765784] [ee95be50] [c0087304] enter_state+0xe4/0xf4
[   76.765978] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
[   76.766167] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
[   76.766352] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
[   76.766547] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
[   76.766734] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
[   76.766935] --- Exception: c01 at 0xfaab878
[   76.766937]     LR = 0xfaab7dc
[   76.767183] Instruction dump:
[   76.767305] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
[   76.767707] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
[   76.768225] queueing ieee80211 work while going to suspend
[   76.768458] ------------[ cut here ]------------
[   76.768615] Badness at net/mac80211/util.c:524
[   76.768766] NIP: f244c71c LR: f244c71c CTR: 00000000
[   76.768934] REGS: ee95bb60 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
[   76.769185] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42082444  XER: 00000000
[   76.769554] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
[   76.769749] GPR00: f244c71c ee95bc10 efb46000 00000041 00000001 c0041078 00000000 00000002 
[   76.770190] GPR08: 00000000 ee95a000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
[   76.770631] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
[   76.771072] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 00009032 eebccc20 eebcc300 
[   76.772462] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.773622] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.774769] Call Trace:
[   76.775784] [ee95bc10] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
[   76.777026] [ee95bc20] [f26370ac] rtl8187_led_brightness_set+0x54/0x78 [rtl8187]
[   76.778221] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
[   76.779362] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
[   76.780527] [ee95bc70] [f2637100] rtl8187_leds_exit+0x30/0x64 [rtl8187]
[   76.781706] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
[   76.782877] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
[   76.784016] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
[   76.785130] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
[   76.786229] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
[   76.787329] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
[   76.788419] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
[   76.789486] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
[   76.790579] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
[   76.791630] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
[   76.792691] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
[   76.793729] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
[   76.794811] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
[   76.795907] [ee95be50] [c0087304] enter_state+0xe4/0xf4
[   76.796965] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
[   76.798009] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
[   76.799057] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
[   76.800118] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
[   76.801161] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
[   76.802227] --- Exception: c01 at 0xfaab878
[   76.802229]     LR = 0xfaab7dc
[   76.804203] Instruction dump:
[   76.805180] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
[   76.806438] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
[   76.807821] queueing ieee80211 work while going to suspend
[   76.808949] ------------[ cut here ]------------
[   76.809998] Badness at net/mac80211/util.c:524
[   76.811032] NIP: f244c71c LR: f244c71c CTR: 00000000
[   76.812082] REGS: ee95bb60 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
[   76.813220] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42082444  XER: 00000000
[   76.814480] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
[   76.814673] GPR00: f244c71c ee95bc10 efb46000 00000041 00000001 c0041078 00000000 00000002 
[   76.815997] GPR08: 00000000 ee95a000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
[   76.817323] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
[   76.818653] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 00009032 eebccc20 eebcc300 
[   76.820935] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.822113] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.823294] Call Trace:
[   76.824336] [ee95bc10] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
[   76.825599] [ee95bc20] [f26370bc] rtl8187_led_brightness_set+0x64/0x78 [rtl8187]
[   76.826802] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
[   76.827952] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
[   76.829102] [ee95bc70] [f2637100] rtl8187_leds_exit+0x30/0x64 [rtl8187]
[   76.830253] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
[   76.831391] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
[   76.832512] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
[   76.833632] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
[   76.834737] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
[   76.835859] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
[   76.836963] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
[   76.838038] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
[   76.839142] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
[   76.840198] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
[   76.841263] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
[   76.842314] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
[   76.843405] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
[   76.844505] [ee95be50] [c0087304] enter_state+0xe4/0xf4
[   76.845563] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
[   76.846633] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
[   76.847688] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
[   76.848748] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
[   76.849805] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
[   76.850875] --- Exception: c01 at 0xfaab878
[   76.850877]     LR = 0xfaab7dc
[   76.852862] Instruction dump:
[   76.853850] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
[   76.855130] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
[   76.856785] queueing ieee80211 work while going to suspend
[   76.857926] ------------[ cut here ]------------
[   76.858980] Badness at net/mac80211/util.c:524
[   76.860012] NIP: f244c71c LR: f244c71c CTR: 00000000
[   76.861062] REGS: ee95bb60 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
[   76.862201] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42082444  XER: 00000000
[   76.863463] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
[   76.863656] GPR00: f244c71c ee95bc10 efb46000 00000041 00000001 c0041078 00000000 00000002 
[   76.864980] GPR08: 00000000 ee95a000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
[   76.866306] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
[   76.867639] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 00009032 eebccc20 eebcc300 
[   76.869924] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.871111] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.872286] Call Trace:
[   76.873334] [ee95bc10] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
[   76.874603] [ee95bc20] [f26370ac] rtl8187_led_brightness_set+0x54/0x78 [rtl8187]
[   76.875811] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
[   76.876961] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
[   76.878111] [ee95bc70] [f263710c] rtl8187_leds_exit+0x3c/0x64 [rtl8187]
[   76.879260] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
[   76.880398] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
[   76.881504] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
[   76.882619] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
[   76.883720] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
[   76.884838] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
[   76.885937] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
[   76.887019] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
[   76.888125] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
[   76.889193] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
[   76.890268] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
[   76.891328] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
[   76.892421] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
[   76.893523] [ee95be50] [c0087304] enter_state+0xe4/0xf4
[   76.894586] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
[   76.895645] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
[   76.896705] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
[   76.897771] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
[   76.898833] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
[   76.899905] --- Exception: c01 at 0xfaab878
[   76.899907]     LR = 0xfaab7dc
[   76.901921] Instruction dump:
[   76.902910] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
[   76.904199] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 
[   76.905582] queueing ieee80211 work while going to suspend
[   76.906707] ------------[ cut here ]------------
[   76.907764] Badness at net/mac80211/util.c:524
[   76.908817] NIP: f244c71c LR: f244c71c CTR: 00000000
[   76.909879] REGS: ee95bb60 TRAP: 0700   Tainted: G        W   (2.6.32-rc8-wl-wltest)
[   76.911025] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42082444  XER: 00000000
[   76.912300] TASK = efb46000[2479] 'pbbuttonsd' THREAD: ee95a000
[   76.912493] GPR00: f244c71c ee95bc10 efb46000 00000041 00000001 c0041078 00000000 00000002 
[   76.913826] GPR08: 00000000 ee95a000 efb46000 00009032 22082444 100351d0 bff9c428 bff9c42c 
[   76.915154] GPR16: 0fc6fb2c 0fc6fa88 c0811598 c0983594 c0aa0000 00000002 00000004 00000001 
[   76.916486] GPR24: ee95bdd8 00000005 c0aa2b74 eebcd114 00000000 00009032 eebccc20 eebcc300 
[   76.918770] NIP [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.919961] LR [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211]
[   76.921137] Call Trace:
[   76.922186] [ee95bc10] [f244c71c] ieee80211_queue_delayed_work+0x48/0x5c [mac80211] (unreliable)
[   76.923457] [ee95bc20] [f26370bc] rtl8187_led_brightness_set+0x64/0x78 [rtl8187]
[   76.924665] [ee95bc30] [c05306f8] led_trigger_set+0xf4/0xf8
[   76.925817] [ee95bc50] [c05301fc] led_classdev_unregister+0x64/0xa8
[   76.926969] [ee95bc70] [f263710c] rtl8187_leds_exit+0x3c/0x64 [rtl8187]
[   76.928136] [ee95bc90] [f2637b84] rtl8187_disconnect+0x28/0x74 [rtl8187]
[   76.929264] [ee95bcb0] [c04aa084] usb_unbind_interface+0x170/0x1bc
[   76.930383] [ee95bcd0] [c0417a14] __device_release_driver+0x84/0xe4
[   76.931503] [ee95bcf0] [c0417b68] device_release_driver+0x28/0x44
[   76.932606] [ee95bd10] [c04aa308] usb_driver_release_interface+0x90/0x94
[   76.933731] [ee95bd30] [c04aa3c4] usb_forced_unbind_intf+0x24/0x48
[   76.934845] [ee95bd50] [c04aa4c0] do_unbind_rebind+0xd8/0xe0
[   76.935935] [ee95bd70] [c04aa5f0] usb_external_suspend_device+0x24/0x74
[   76.937046] [ee95bda0] [c04aa6b0] usb_suspend+0x70/0x9c
[   76.938116] [ee95bdb0] [c049ced8] usb_dev_suspend+0x1c/0x2c
[   76.939190] [ee95bdc0] [c041c8ec] pm_op+0x19c/0x1f8
[   76.940249] [ee95bdd0] [c041d1ec] dpm_suspend_start+0x384/0x4e8
[   76.941343] [ee95be30] [c00870b0] suspend_devices_and_enter+0x5c/0x1cc
[   76.942449] [ee95be50] [c0087304] enter_state+0xe4/0xf4
[   76.943528] [ee95be70] [c0424e54] pmu_ioctl+0x84/0x1e0
[   76.944592] [ee95be80] [c00fc8dc] vfs_ioctl+0xb8/0xc4
[   76.945656] [ee95bea0] [c00fcab8] do_vfs_ioctl+0x84/0x7ec
[   76.946725] [ee95bf10] [c00fd260] sys_ioctl+0x40/0x88
[   76.947785] [ee95bf40] [c0017334] ret_from_syscall+0x0/0x38
[   76.948872] --- Exception: c01 at 0xfaab878
[   76.948873]     LR = 0xfaab7dc
[   76.950883] Instruction dump:
[   76.951877] 880300de 2f800000 419e001c 80630048 4800914d 80010014 38210010 7c0803a6 
[   76.953154] 4e800020 3c60f246 38638bb0 48008bb1 <0fe00000> 80010014 38210010 7c0803a6 

-- 
Greetings, Michael.
