Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320Ab1A1PlG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 10:41:06 -0500
Date: Fri, 28 Jan 2011 16:41:00 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [BUG] iwlwifi need to correct channels info
Message-ID: <20110128154100.GB2452@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After commit 59eb21a6504731fc16db4cf9463065dd61093e08
"cfg80211: Extend channel to frequency mapping for 802.11j"
5GHz networks are not seen on scan results.

I think above commit is correct, but we have broken channel
information on iwlwifi (freq is 0 on 5GHz channels):

Channel 1 Freq=2412[2.4GHz] valid flag=0x20
Channel 2 Freq=2417[2.4GHz] valid flag=0x20
Channel 3 Freq=2422[2.4GHz] valid flag=0x20
Channel 4 Freq=2427[2.4GHz] valid flag=0x20
Channel 5 Freq=2432[2.4GHz] valid flag=0x0
Channel 6 Freq=2437[2.4GHz] valid flag=0x0
Channel 7 Freq=2442[2.4GHz] valid flag=0x0
Channel 8 Freq=2447[2.4GHz] valid flag=0x10
Channel 9 Freq=2452[2.4GHz] valid flag=0x10
Channel 10 Freq=2457[2.4GHz] valid flag=0x10
Channel 11 Freq=2462[2.4GHz] valid flag=0x10
Channel 12 Freq=2467[2.4GHz] valid flag=0x36
Channel 13 Freq=2472[2.4GHz] valid flag=0x36
Channel 36 Freq=0[5.2GHz] valid flag=0x26
Channel 40 Freq=0[5.2GHz] valid flag=0x16
Channel 44 Freq=0[5.2GHz] valid flag=0x26
Channel 48 Freq=0[5.2GHz] valid flag=0x16
Channel 52 Freq=0[5.2GHz] valid flag=0x2E
Channel 56 Freq=0[5.2GHz] valid flag=0x1E
Channel 60 Freq=0[5.2GHz] valid flag=0x2E
Channel 64 Freq=0[5.2GHz] valid flag=0x1E
Channel 100 Freq=0[5.2GHz] valid flag=0x2E
Channel 104 Freq=0[5.2GHz] valid flag=0x1E
Channel 108 Freq=0[5.2GHz] valid flag=0x2E
Channel 112 Freq=0[5.2GHz] valid flag=0x1E
Channel 116 Freq=0[5.2GHz] valid flag=0x2E
Channel 120 Freq=0[5.2GHz] valid flag=0x1E
Channel 124 Freq=0[5.2GHz] valid flag=0x2E
Channel 128 Freq=0[5.2GHz] valid flag=0x1E
Channel 132 Freq=0[5.2GHz] valid flag=0x2E
Channel 136 Freq=0[5.2GHz] valid flag=0x1E
Channel 140 Freq=0[5.2GHz] valid flag=0x3E
Channel 149 Freq=0[5.2GHz] valid flag=0x26
Channel 153 Freq=0[5.2GHz] valid flag=0x16
Channel 157 Freq=0[5.2GHz] valid flag=0x26
Channel 161 Freq=0[5.2GHz] valid flag=0x16
Channel 165 Freq=0[5.2GHz] valid flag=0x36
