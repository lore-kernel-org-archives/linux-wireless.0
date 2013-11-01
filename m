Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21230 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3KAK3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 06:29:39 -0400
Date: Fri, 1 Nov 2013 13:26:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: janusz.dziedzic@tieto.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: re: ath9k: dfs move ath_dfs_pool_stats
Message-ID: <20131101102614.GG29795@longonot.mountain> (sfid-20131101_112942_994132_32D1E26E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Janusz Dziedzic,

This is a semi-automatic email about new static checker warnings.

The patch d265214b614a: "ath9k: dfs move ath_dfs_pool_stats" from Oct 
14, 2013, leads to the following Smatch complaint:

drivers/net/wireless/ath/ath9k/dfs_debug.c:67 read_file_dfs()
	 error: we previously assumed 'sc->dfs_detector' could be null (see line 47)

drivers/net/wireless/ath/ath9k/dfs_debug.c
    46	
    47		if (sc->dfs_detector)
                    ^^^^^^^^^^^^^^^^
Patch introduces a new check.

    48			dfs_pool_stats = sc->dfs_detector->get_stats(sc->dfs_detector);
    49	
    50		len += scnprintf(buf + len, size - len, "DFS support for "
    51				 "macVersion = 0x%x, macRev = 0x%x: %s\n",
    52				 hw_ver->macVersion, hw_ver->macRev,
    53				 (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_DFS) ?
    54						"enabled" : "disabled");
    55		len += scnprintf(buf + len, size - len, "Pulse detector statistics:\n");
    56		ATH9K_DFS_STAT("pulse events reported   ", pulses_total);
    57		ATH9K_DFS_STAT("invalid pulse events    ", pulses_no_dfs);
    58		ATH9K_DFS_STAT("DFS pulses detected     ", pulses_detected);
    59		ATH9K_DFS_STAT("Datalen discards        ", datalen_discards);
    60		ATH9K_DFS_STAT("RSSI discards           ", rssi_discards);
    61		ATH9K_DFS_STAT("BW info discards        ", bwinfo_discards);
    62		ATH9K_DFS_STAT("Primary channel pulses  ", pri_phy_errors);
    63		ATH9K_DFS_STAT("Secondary channel pulses", ext_phy_errors);
    64		ATH9K_DFS_STAT("Dual channel pulses     ", dc_phy_errors);
    65		len += scnprintf(buf + len, size - len, "Radar detector statistics "
    66				 "(current DFS region: %d)\n",
    67				 sc->dfs_detector->region);
                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
Existing unchecked dereference.

    68		ATH9K_DFS_STAT("Pulse events processed  ", pulses_processed);
    69		ATH9K_DFS_STAT("Radars detected         ", radar_detected);

regards,
dan carpenter
