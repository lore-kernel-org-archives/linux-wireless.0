Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2CNIO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 04:14:57 -0400
Date: Wed, 14 Mar 2012 09:14:25 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
Message-ID: <20120314081424.GC2788@redhat.com> (sfid-20120314_091503_253426_04882ABB)
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
 <20120314062549.GA2788@redhat.com>
 <1331708304.3376.0.camel@jlt3.sipsolutions.net>
 <20120314070748.GB2788@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120314070748.GB2788@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 14, 2012 at 08:07:48AM +0100, Stanislaw Gruszka wrote:
> I'll update and recheck again.

On updated tree (head 035364916f75151b4b91ea53968c6beba7545317) devices
stop working here on any forced reset during TX as well. There are
messages like below in dmesg:

wlan3: dropped data frame to not associated station 00:00:00:00:00:00

And one time crash happened too, in:

(gdb) l *(iwl_remove_dynamic_key+0x1f0)
0x15e20 is in iwl_remove_dynamic_key (drivers/net/wireless/iwlwifi/iwl-agn-sta.c:1105).
1100		/*
1101		 * The device expects GTKs for station interfaces to be
1102		 * installed as GTKs for the AP station. If we have no
1103		 * station ID, then use the ap_sta_id in that case.
1104		 */
1105		if (vif->type == NL80211_IFTYPE_STATION && vif_priv->ctx)
1106			return vif_priv->ctx->ap_sta_id;
1107	
1108		return IWL_INVALID_STATION;
1109	}

To reproduce problems, I'm doing "ping -f 192.168.1.1" on one console
and run script [1] on other console.

Stanislaw

[1]

#!/bin/bash

mount -t debugfs debugfs /sys/kernel/debug
cd /sys/kernel/debug/ieee80211

while true; do 

sleep 20
for i in `ls -X ` ; do echo 1 > $i/iwlwifi/debug/force_reset ; done

done
