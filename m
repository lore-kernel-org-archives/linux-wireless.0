Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57373 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab0DORbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 13:31:09 -0400
Received: by mail-ww0-f46.google.com with SMTP id 24so648191wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 10:31:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Thu, 15 Apr 2010 19:31:08 +0200
Message-ID: <p2g2d0a357f1004151031he100c81ai586d4606715b37bc@mail.gmail.com>
Subject: iwl3945: Network dropouts w/ flash-stream in firefox
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have here reproduceable network dropouts with my iwl3945 wlan device
when watching flash10 A/V streams in firefox-3.6.3.

My Linux-kernel is 2.6.34-rc4-git3 enriched with "iwlwifi: work around
bogus active chains detection" patch from wireless-2.6 GIT branch,
so-to-say I am on version as-of master-2010-04-12.

Furthermore, I also did a reboot of my xDSL-router-modem and a
coldstart of my notebook.

Some additional informations:

$ dpkg -l | egrep 'wpa|crda|regdb'
ii  crda
    1.1.1-0~svnr1515.3                    wireless Central Regulatory
Domain Agent
ii  wireless-regdb
    2009.11.25-0+c0.sidux.2               wireless regulatory database
ii  wpagui
    0.7.1-1~dileX+1                       graphical user interface for
wpa_supplicant
ii  wpasupplicant
    0.7.1-1~dileX+1                       client support for WPA and
WPA2 (IEEE 802.11i)


Need more infos?
Any hints? Any ideas?

Kind Regards,
- Sedat -

[dmesg]
...
[  267.204048] No probe response from AP 00:04:0e:e4:00:3d after
500ms, disconnecting.
[  267.704053] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  267.704062] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  268.206048] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  268.206057] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  268.208045] cfg80211: Calling CRDA to update world regulatory domain
[  268.213286] cfg80211: World regulatory domain updated:
[  268.213291]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  268.213298]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  268.213304]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  268.213310]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  268.213316]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  268.213322]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  268.806083] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  268.806091] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  269.306299] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  269.806072] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  270.306060] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  270.806052] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  270.806061] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  271.306074] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  271.306083] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  271.806074] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  275.811047] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  275.811056] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  276.311074] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  276.811068] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  277.311068] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  277.811080] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  277.811089] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  278.311064] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  278.311073] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  278.811074] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  282.814051] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  282.814060] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  283.314067] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  283.814063] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  284.314063] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
time out after 500ms.
[  284.814054] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  284.814063] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  285.314056] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  285.314065] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  285.814074] iwl3945 0000:10:00.0: Error sending
REPLY_TX_PWR_TABLE_CMD: time out after 500ms.
[  287.814202] hda_codec_cleanup_stream: NID=0x3
[  289.814060] iwl3945 0000:10:00.0: Error sending REPLY_RXON: time
out after 500ms.
[  289.814068] iwl3945 0000:10:00.0: Error setting new configuration (-110).
[  289.814107] iwl3945 0000:10:00.0: No space in command queue
[  289.814113] iwl3945 0000:10:00.0: Restarting adapter due to queue full
[  289.814120] iwl3945 0000:10:00.0: Error sending REPLY_SCAN_CMD:
enqueue_hcmd failed: -28
[  298.367489] wlan0: authenticate with 00:04:0e:e4:00:3d (try 1)
[  298.369762] wlan0: authenticated
[  298.369861] wlan0: associate with 00:04:0e:e4:00:3d (try 1)
[  298.374873] wlan0: RX ReassocResp from 00:04:0e:e4:00:3d
(capab=0x411 status=0 aid=1)
[  298.374879] wlan0: associated
...
[/dmesg]
