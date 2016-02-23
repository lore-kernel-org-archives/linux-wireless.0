Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.fing.edu.uy ([164.73.32.175]:60896 "EHLO smtp.fing.edu.uy"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbcBWQk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 11:40:57 -0500
Date: Tue, 23 Feb 2016 16:27:03 +0001
From: Matias Richart <mrichart@fing.edu.uy>
Subject: mac80211: Possible bug in minstrel_ht when enabling RTS/CTS
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Message-Id: <1456244763.30962.0@smtp.fing.edu.uy> (sfid-20160223_174100_454145_90CECA61)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

I think there might be a bug in the following code of minstrel_ht when 
deciding if RTS/CTS should be enabled:

    /* enable RTS/CTS if needed:
     * - if station is in dynamic SMPS (and streams > 1)
     * - for fallback rates, to increase chances of getting through
     */
    if (offset > 0 &&
        (mi->sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
         group->streams > 1)) {
        ratetbl->rate[offset].count = ratetbl->rate[offset].count_rts;
        flags |= IEEE80211_TX_RC_USE_RTS_CTS;
    }

The code does not match what it is said in the comment. RTS/CTS is not 
enabled for fallback rates when not in dynamic SMPS.

Regards.

Matías

