Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45706 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab3K0Kh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 05:37:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21141.51790.303263.385517@gargle.gargle.HOWL> (sfid-20131127_113730_651367_D1F4A333)
Date: Wed, 27 Nov 2013 16:02:46 +0530
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: ath9k pending patches
In-Reply-To: <1385547828-4330-1-git-send-email-sujith@msujith.org>
References: <1385547828-4330-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

There are lots of pending patches for ath9k and all of
them are here, rebased over -wl master:

http://msujith.org/dir/patches/wl/Nov-27-2013/

Sujith

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> These two patches update the initvals for
> AR9300 2.2 and AR9580 1.0
> 
> After these patches, there are still a few differences between the
> INI files from the internal driver and ath9k. From verify_checksum:
> 
> ar9003-2p2     96a13663004d71b5ffa4fe9efc6b41dcfaf5a327 fail
> +c8dc777b012068116cd5282aade8eb460f397d20        ar9300_2p2_mac_postamble
> +5542c7d650feeb530de2775003931a00f992c09a        ar9300Modes_high_power_tx_gain_table_2p2
> 
> ar9580-1p0     40e08925d7d8daa4c9841ee807fa25b0fd3f725b fail
> +c8dc777b012068116cd5282aade8eb460f397d20        ar9580_1p0_mac_postamble
> +07f9922af110bf9d72a7534a30eefcf9bacd0d7e        ar9580_1p0_baseband_core
> +8e30343d20745791d5c2e7de968f0e81403761d5        ar9580_1p0_baseband_postamble
> 
> Differences:
> 
> * In both chips, "mac_postamble" needs an update - the "ALWAYS_PERFORM_KEY_SEARCH"
>   bit has to enabled. This is required to address key cache corruption, which
>   needs a bigger change in the driver.
> 
> * The ar9300Modes_high_power_tx_gain_table_2p2 array has been left as such
>   since it is required for certain Buffalo devices.
> 
> * ar9580_1p0_baseband_core and ar9580_1p0_baseband_postamble require updates
>   to handle DFS issues. This will be done in a separate commit.
> 
> All initval tool changes have been pushed to:
> https://github.com/sujith/qca-swiss-army-knife/commits/master
> 
> Sujith
> 
> Sujith Manoharan (2):
>   ath9k: Update initvals for AR9300 v2.2
>   ath9k: Update initvals for AR9580 v1.0
> 
>  .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |  24 +-
>  .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   | 559 ++++++++++++++-------
>  2 files changed, 398 insertions(+), 185 deletions(-)
> 
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
