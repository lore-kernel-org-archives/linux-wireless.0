Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31708 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab3AKG47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 01:56:59 -0500
Date: Fri, 11 Jan 2013 09:57:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mickflemm@gmail.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: re: ath5k: Extend get_default_sifs/slot_time
Message-ID: <20130111065701.GF13207@elgon.mountain> (sfid-20130111_075702_399621_C639FA1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Nick Kossifidis,

The patch 3017fcab416d: "ath5k: Extend get_default_sifs/slot_time" 
from Nov 23, 2010, leads to the following warning:
drivers/net/wireless/ath/ath5k/pcu.c:223 ath5k_hw_get_default_sifs()
	 warn: missing break? reassigning 'sifs'

   209          switch (ah->ah_bwmode) {
   210          case AR5K_BWMODE_40MHZ:
   211                  sifs = AR5K_INIT_SIFS_TURBO;
   212                  break;
   213          case AR5K_BWMODE_10MHZ:
   214                  sifs = AR5K_INIT_SIFS_HALF_RATE;
   215                  break;
   216          case AR5K_BWMODE_5MHZ:
   217                  sifs = AR5K_INIT_SIFS_QUARTER_RATE;
   218                  break;
   219          case AR5K_BWMODE_DEFAULT:
   220                  sifs = AR5K_INIT_SIFS_DEFAULT_BG;
   221          default:

Was it intentional to fall through to the default case here?  Most of
the intentional fall through sites (80-90%) have a /* fall through */
comment.

   222                  if (channel->band == IEEE80211_BAND_5GHZ)
   223                          sifs = AR5K_INIT_SIFS_DEFAULT_A;
   224                  break;
   225          }

regards,
dan carpenter

