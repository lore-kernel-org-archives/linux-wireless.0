Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.exactcode.de ([144.76.154.42]:49936 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751040AbdLELfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 06:35:05 -0500
To: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?Q?Ren=c3=a9_Rebe?= <rene@exactcode.com>
Subject: MWIFIEX still unstable after two years on MS Surface Pro 3
Message-ID: <d776bc3d-7712-8430-93e2-72e4b6bbf23c@exactcode.com> (sfid-20171205_123509_522039_7473D07C)
Date: Tue, 5 Dec 2017 12:06:38 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I write to start a discussion about the state of the mwifiex driver.
For over two years many other and me wait that the driver finally 
becomes "stable". However, even with kernel 4.14.2 it still fails after 
some minutes, or latest after some hours. With various stray errors in 
the system log:

Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: 
MWIFIEX VERSION: mwifiex 1.0 (15.68.7.p119)
Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: 
driver_version = mwifiex 1.0 (15.68.7.p119)

Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: trying 
to associate to 'XXX' bssid xx:xx:xx:xx:xx:xx
Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: 
associated to bssid xx:xx:xx:xx:xx:xx successfully
...
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: Firmware 
wakeup failed
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: FW 
in reset state
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: 
card is removed
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the 
crypto keys
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: 
card is removed
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the 
crypto keys
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: 
card is removed
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the 
crypto keys
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: PREP_CMD: 
card is removed
Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: deleting the 
crypto keys

Also, rmmod usually then hangs, and even if it eventually force unloads 
and such re-loading the module does not even get it back into some 
working state. Not even with echoing 1 into the pci reset file.

If this firmware and driver is already for years not working very 
stable, can this not at least recover more gracefully?

Any suggestions how to finally address and solve these issues are welcome.

If someone needs more logs and debug fluff let me know to generate it as 
necessary.

For what it is worth, at least the USB attached mwifi chip in the 
Surface 2 appears to work more reliable with the Linux driver.

Best regards,
	René Rebe

-- 
   René Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10117 Berlin
   http://exactcode.com | http://t2-project.org | http://rene.rebe.de
