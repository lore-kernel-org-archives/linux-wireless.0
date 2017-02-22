Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754225AbdBVCKo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 21:10:44 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com
Cc: ming.lei@canonical.com, zajec5@gmail.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v2 0/2] iwlwifi: share opmode start code
Date: Tue, 21 Feb 2017 18:10:37 -0800
Message-Id: <20170222021039.28193-1-mcgrof@kernel.org> (sfid-20170222_031114_331134_CEBE5D09)
In-Reply-To: <20170222001822.GE31264@wotan.suse.de>
References: <20170222001822.GE31264@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This v2 split off the opmode handling sharing code into its
own series, it however depends on the request_module_nowait()
change.

The sharing of the opmode handling makes it easier to share fixes
when dealing with opmode handling on devices. It should also hopefully
make the code easier to grok. Lastly, since we are moving things to
a workqueue naturally the module_init() for iwlmvm is not offloaded,
and so this should reduce the boot time by a bit.

As per the average of systemd-analyze on 5 boots using next-20170221
as base:

next-20170221:
Startup finished in   2.6142s (kernel) +   5.1916s (initrd) +  10.8968s (userspace) =  18.7036s

After these patches:
Startup finished in   2.5468s (kernel) +   4.9536s (initrd) +   10.798s (userspace) =  18.2994s

Luis R. Rodriguez (2):
  iwlwifi: share opmode start work code
  iwlwifi: convert final opmode work into a workqueue

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 93 +++++++++++++++++++---------
 1 file changed, 64 insertions(+), 29 deletions(-)

-- 
2.11.0
