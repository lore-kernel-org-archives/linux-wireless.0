Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59128 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaL0TIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 14:08:51 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so16228279wgg.7
        for <linux-wireless@vger.kernel.org>; Sat, 27 Dec 2014 11:08:49 -0800 (PST)
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: emmanuel.grumbach@intel.com, johannes.berg@intel.com,
	ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: Unable to disable WiFi with 3.19-rc1 - iwlwifi 7260
Date: Sat, 27 Dec 2014 20:08:47 +0100
Message-ID: <3095419.huSVmtL0ib@xps13> (sfid-20141227_200855_150197_8F4B0DDC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

since v3.19-rc1 I have problems with WiFi (Intel Corporation Dual Band
Wireless-AC 7260) on my laptop. Trying to disable all the radio devices
(WiFi and BT) with the function key of my laptop, which should hard
block the rfkills, causes the following message to be repeated over and
over until I re-enable them again with the function key:

[  593.746001] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[  593.746468] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[  593.746781] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[  593.747091] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.

Sometimes my laptop hangs when I try to toggle the state of the radio
devices and have to forcefully reboot it.

Reverting 522713c81e ("iwlwifi: pcie: properly reset the device") seems
to fix the problem. I haven't tried anything else since this was the
first thing I tried.

Does anyone know what's the problem with that specific commit?
I will gladly provide any additional information, just tell me what
is needed.

Regards,
Gabriele
