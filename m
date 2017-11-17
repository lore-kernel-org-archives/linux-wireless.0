Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42842 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964925AbdKQWak (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 17:30:40 -0500
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: bug in commit: mac80211: Fix possible sband related NULL pointer
 de-reference
Message-ID: <238cb9e7-c78f-66e4-01ed-5fead4f35820@candelatech.com> (sfid-20171117_233043_806273_CF512555)
Date: Fri, 17 Nov 2017 14:30:37 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Author: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Date:   Thu Apr 27 12:45:38 2017 +0530

     mac80211: Fix possible sband related NULL pointer de-reference

     Existing API 'ieee80211_get_sdata_band' returns default 2 GHz band even
     if the channel context configuration is NULL. This crashes for chipsets
     which support 5 Ghz alone when it tries to access members of 'sband'.
     Channel context configuration can be NULL in multivif case and when
     channel switch is in progress (or) when it fails. Fix this by replacing
     the API 'ieee80211_get_sdata_band' with  'ieee80211_get_sband' which
     returns a NULL pointer for sband when the channel configuration is NULL.

...

This commit appears to break  sta_set_rate_info_tx on drivers that are not using chantx,
because it calls ieee80211_get_sband, which does a WARN_ON when there is no chantx.

Any idea how to make this work for chandef drivers?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
