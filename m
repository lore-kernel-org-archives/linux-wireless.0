Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34762 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbdKQEvE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 23:51:04 -0500
Received: by mail-wm0-f42.google.com with SMTP id y82so2018429wmg.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Nov 2017 20:51:03 -0800 (PST)
MIME-Version: 1.0
From: John Stultz <john.stultz@linaro.org>
Date: Thu, 16 Nov 2017 20:51:02 -0800
Message-ID: <CALAqxLV953NFSZEg5Rd0N0K6JerBqf9d5AUC52E4AjLH0d6RMQ@mail.gmail.com> (sfid-20171117_055206_003987_50F93066)
Subject: wlcore: wl18xx: Trouble suspending caused by wifi being enabled?
To: Kalle Valo <kvalo@codeaurora.org>,
        Maxim Altshul <maxim.altshul@ti.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Folks,
  So, for awhile recently, I've noticed my HiKey board (which uses the
TI WL1835MOD chip for wifi) has had trouble when it tries to suspend.
Basically it keeps on waking up while suspending, and then
re-suspending over and over until it lucks out in whatever race is
going on and manages to suspend before the wifi wakes it up.

Here's an example suspend-immediate-wake cycle:

[  241.975754] PM: suspend entry (deep)
[  241.979590] PM: Syncing filesystems ... done.
[  241.997363] Freezing user space processes ... (elapsed 0.003 seconds) done.
[  242.007903] OOM killer disabled.
[  242.011157] Freezing remaining freezable tasks ... (elapsed 0.002
seconds) done.
[  242.020715] Suspending console(s) (use no_console_suspend to debug)
[  242.028155] wlan0: deauthenticating from 70:3a:cb:12:90:28 by local
choice (Reason: 3=DEAUTH_LEAVING)
[  242.029797] dwc2 f72c0000.usb: suspending usb gadget configfs-gadget
[  242.029885] dwc2 f72c0000.usb: dwc2_hsotg_ep_disable: called for ep0
[  242.029893] dwc2 f72c0000.usb: dwc2_hsotg_ep_disable: called for ep0
[  242.071475] wlcore: down
[  242.071795] queueing ieee80211 work while going to suspend
[  242.071808] wlcore: down
[  242.072120] queueing ieee80211 work while going to suspend
[  242.073796] PM: Wakeup pending, aborting suspend
[  242.073810] PM: Some devices failed to suspend, or early wake event detected
[  242.091277] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 400000Hz, actual 400000HZ div = 31)
[  242.128593] mmc_host mmc2: Bus speed (slot 0) = 24800000Hz (slot
req 25000000Hz, actual 24800000HZ div = 0)
[  242.129197] dwc2 f72c0000.usb: resuming usb gadget configfs-gadget
[  242.337364] dwc2 f72c0000.usb: new device is high-speed
[  242.413119] dwc2 f72c0000.usb: new device is high-speed
[  242.452173] wlcore: PHY firmware version: Rev 8.2.0.0.237
[  242.484959] dwc2 f72c0000.usb: new address 8
[  242.499012] wlcore: firmware booted (Rev 8.9.0.0.70)
[  242.506240] configfs-gadget gadget: high-speed config #1: b
[  242.627752] OOM killer enabled.
[  242.630899] Restarting tasks ... done.
[  242.647180] PM: suspend exit

Eventually it will luck out and manage to suspend itself, but it can
take close to a minute.  If I disable wifi the system reliably
suspends every time.

This used to not be the case, but its been so long, I'm not really
sure when this issue cropped up.

I wanted to see if anyone else had similar trouble or maybe had ideas
how to chase this down?

thanks
-john
