Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:35378 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab3KELm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 06:42:29 -0500
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com [209.85.220.49])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 57E6C88133
	for <linux-wireless@vger.kernel.org>; Tue,  5 Nov 2013 19:42:28 +0800 (CST)
Received: by mail-pa0-f49.google.com with SMTP id lj1so8522674pab.22
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 03:42:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
References: <5276134B.8070808@wzyboy.org> <0BA3FCBA62E2DC44AF3030971E174FB301DE75AE@HASMSX103.ger.corp.intel.com>
 <CALkVjQYh-SUte4S6LdqOc3KSc3_pDU6jz1KXp+Jsd5_RFPXSqA@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE8338@HASMSX103.ger.corp.intel.com>
 <CALkVjQb7fCMFpqhdUs8w-Mx_Y0RtAYYFtKxXkqyrCQ39UFGxKg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DE960E@HASMSX103.ger.corp.intel.com> <CALkVjQbW8FeiEh8pBZ=KQFD9+8AdjgT0G_RG7qJe0MRdBvMD-A@mail.gmail.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Tue, 5 Nov 2013 19:42:12 +0800
Message-ID: <CALkVjQa-tH6HYBwkXNfMdXswuL=-52fQi42fEzA4N0s1ZfYmgA@mail.gmail.com> (sfid-20131105_124233_318068_08E1A8D9)
Subject: Fwd: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry I forgot to "Reply-all" instead of "Reply"... (Bad habit
developed by Google Groups)

-- 
wzyboy



---------- Forwarded message ----------
From: wzyboy <wzyboy@wzyboy.org>
Date: 2013/11/5
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>


2013/11/5 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> Are you sure it is the same phenomenon?
> Same WARNING with same value in register?


Yes I am sure that's the same phenomenon. And here are the comparison
of those "WARNING" lines in recent days' kernel log:

// I bought this laptop on Nov 01 and installed (with wired network)
Arch Linux on the same day so no logs for Nov 01. On Nov 02 I started
to use wireless network, and here came the WARNINGs:

Nov 02 13:01:53 xenien kernel: WARNING: CPU: 2 PID: 790 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 02 13:01:55 xenien kernel: WARNING: CPU: 2 PID: 790 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()
Nov 02 13:02:11 xenien kernel: WARNING: CPU: 1 PID: 4942 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 02 13:02:11 xenien kernel: Timeout waiting for hardware access
(CSR_GP_CNTRL 0xffffffff)
Nov 02 13:09:17 xenien kernel: WARNING: CPU: 1 PID: 5776 at
kernel/watchdog.c:245 watchdog_overflow_callback+0x9c/0xd0()
Nov 02 13:09:17 xenien kernel: Watchdog detected hard LOCKUP on cpu 1

Nov 03 14:13:21 xenien kernel: WARNING: CPU: 3 PID: 454 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 03 14:13:21 xenien kernel: Timeout waiting for hardware access
(CSR_GP_CNTRL 0xffffffff)
Nov 03 14:13:25 xenien kernel: WARNING: CPU: 0 PID: 454 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 03 14:13:27 xenien kernel: WARNING: CPU: 0 PID: 454 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()
Nov 03 14:20:26 xenien kernel: WARNING: CPU: 1 PID: 6955 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 03 16:30:45 xenien kernel: WARNING: CPU: 3 PID: 12926 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 03 16:33:12 xenien kernel: WARNING: CPU: 0 PID: 469 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()

Nov 04 17:00:27 xenien kernel: WARNING: CPU: 3 PID: 10978 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 04 17:00:27 xenien kernel: Timeout waiting for hardware access
(CSR_GP_CNTRL 0xffffffff)
Nov 04 17:00:31 xenien kernel: WARNING: CPU: 3 PID: 10978 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 04 17:00:33 xenien kernel: WARNING: CPU: 0 PID: 10978 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()
Nov 04 22:13:08 xenien kernel: WARNING: CPU: 1 PID: 21506 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 04 22:13:12 xenien kernel: WARNING: CPU: 2 PID: 21506 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 04 22:13:14 xenien kernel: WARNING: CPU: 2 PID: 21506 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()
Nov 04 22:26:13 xenien kernel: WARNING: CPU: 3 PID: 1623 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 04 22:26:17 xenien kernel: WARNING: CPU: 3 PID: 1623 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 04 22:26:19 xenien kernel: WARNING: CPU: 3 PID: 1623 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()
Nov 04 22:31:41 xenien kernel: WARNING: CPU: 3 PID: 872 at
drivers/net/wireless/iwlwifi/pcie/trans.c:883
iwl_trans_pcie_grab_nic_access+0x1d8/0x1f0 [iwlwifi]()
Nov 04 22:31:45 xenien kernel: WARNING: CPU: 3 PID: 872 at
drivers/net/wireless/iwlwifi/mvm/mac80211.c:1047
iwl_mvm_mac_sta_state+0x230/0x290 [iwlmvm]()
Nov 04 22:31:47 xenien kernel: WARNING: CPU: 3 PID: 872 at
net/mac80211/sta_info.c:839 __sta_info_destroy+0x33c/0x380
[mac80211]()

// At the night of Nov 04 I compiled Linux 3.12 and no more WARNINGs
on Nov 05, yet.


These timestamps are of UTC+8. I added "options iwlmvm power_scheme=1"
at about 2013-11-03 17:30 UTC+8...

I've been using Linux 3.12 for one day now, no more bugs about
iwlwifi.ko are encountered... Maybe this is fixed in Linux 3.12?


--
wzyboy
