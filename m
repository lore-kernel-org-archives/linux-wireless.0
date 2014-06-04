Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51903 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbaFDXZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 19:25:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1WsKTo-0008WE-WE
	for linux-wireless@vger.kernel.org; Thu, 05 Jun 2014 01:20:27 +0200
Received: from 89-68-80-14.dynamic.chello.pl ([89.68.80.14])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 01:20:24 +0200
Received: from pitkotko by 89-68-80-14.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jun 2014 01:20:24 +0200
To: linux-wireless@vger.kernel.org
From: piotr <pitkotko@gmail.com>
Subject: Re: [Ilw] Wireless Centrino 2230-N issues
Date: Wed, 4 Jun 2014 22:55:52 +0000 (UTC)
Message-ID: <loom.20140605T005101-221@post.gmane.org> (sfid-20140605_012542_512154_69FB35DC)
References: <536F6620.9030001@gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> <loom.20140530T020912-598@post.gmane.org> <53882EAD.4010609@gmail.com> <53882EF4.4070105@gmail.com> <loom.20140530T111920-677@post.gmane.org> <CANUX_P0JenW+GDT3N0Qj5BPGqMXqUWiBnj=TQ+nMEsjS4HFm1w@mail.gmail.com> <loom.20140603T000209-622@post.gmane.org> <CANUX_P22M85RN_+-GnZ0fEtz7Ch-ei_KbXhjcZ5H7i0Sn30Vhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@...> writes:

> 
> Ok, please do the following:
> 
> modprobe -r iwldvm
> modprobe iwlwifi fw_restart=0 debug=0xffffffff
> 
> then, please send the whole dmesg output.

Please find below the output of the commands:

piotr@pk:~$ sudo modprobe -rv iwldvm
rmmod iwldvm
rmmod mac80211
rmmod iwlwifi
rmmod cfg80211
piotr@pk:~$ sudo modprobe -v iwlwifi fw_restart=0 debug=0xffffffff
insmod /lib/modules/3.13.0-24-generic/kernel/net/wireless/cfg80211.ko 
insmod /lib/modules/3.13.0-24-generic/kernel/drivers
/net/wireless/iwlwifi/iwlwifi.ko fw_restart=0 debug=0xffffffff
piotr@pk:~$ dmesg
[  976.624087] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
[  976.624372] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
[  976.624414] iwlwifi 0000:01:00.0: Unable to initialize device.
[  976.626379] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  976.633440] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
[  976.680112] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
FW Error
[  976.680125] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
[  976.680412] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
[  976.680453] iwlwifi 0000:01:00.0: Unable to initialize device.
[  976.680957] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  976.688020] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
[  976.732150] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
FW Error
[  976.732163] iwlwifi 0000:01:00.0: Could not complete ALIVE transition: -5
[  976.732449] iwlwifi 0000:01:00.0: Failed to run INIT ucode: -5
[  976.732490] iwlwifi 0000:01:00.0: Unable to initialize device.
[  976.734505] iwlwifi 0000:01:00.0: L1 Disabled; Enabling L0S
[  976.741567] iwlwifi 0000:01:00.0: Radio type=0x2-0x0-0x0
[  976.788131] iwlwifi 0000:01:00.0: Command COEX_PRIORITY_TABLE_CMD failed:
FW Error
[... repeats several times ...]

The kernel messages didn't change. Am I doing something wrong?

Piotr

