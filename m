Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbHRTr3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 15:47:29 -0400
Date: Tue, 18 Aug 2015 22:47:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: lorenzo.bianconi83@gmail.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: add rate mask logic for vht rates
Message-ID: <20150818194720.GB2606@mwanda> (sfid-20150818_214732_693024_077960A3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Lorenzo Bianconi,

The patch b119ad6e726c: "mac80211: add rate mask logic for vht rates"
from Aug 6, 2015, leads to the following static checker warning:

	net/mac80211/cfg.c:2520 ieee80211_set_bitrate_mask()
	error: buffer overflow 'sdata->rc_rateidx_vht_mcs_mask[i]' 8 <= 9

net/mac80211/cfg.c
  2516                  for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++) {
                                        ^^^^^^^^^^^^^^^^^^^^^^^^^
This is 10.

  2517                          if (~sdata->rc_rateidx_mcs_mask[i][j])
  2518                                  sdata->rc_has_mcs_mask[i] = true;
  2519  
  2520                          if (~sdata->rc_rateidx_vht_mcs_mask[i][j])
                                            ^^^^^^^^^^^^^^^^^^^^^^^^^^
This only has 8 elements.

  2521                                  sdata->rc_has_vht_mcs_mask[i] = true;
  2522  
  2523                          if (sdata->rc_has_mcs_mask[i] &&
  2524                              sdata->rc_has_vht_mcs_mask[i])
  2525                                  break;

Maybe we always break out before we get to the last two iterations?

  2526                  }

regards,
dan carpenter
