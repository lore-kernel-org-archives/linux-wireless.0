Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64550 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab2DEDhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 23:37:42 -0400
Received: by iagz16 with SMTP id z16so1197657iag.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 20:37:42 -0700 (PDT)
Message-ID: <4F7D1382.2080708@lwfinger.net> (sfid-20120405_053746_070477_584F52C2)
Date: Wed, 04 Apr 2012 22:37:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Question about setup error in mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.kernel.org/show_bug.cgi?id=43044, driver rtl8192ce is 
getting an oops due to a NULL pointer dereference due to NULL being returned by 
ieee80211_get_tx_rate. For reference, the code in question is

static inline struct ieee80211_rate *
ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
                       const struct ieee80211_tx_info *c)
{
         if (WARN_ON(c->control.rates[0].idx < 0))
                 return NULL;
         return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];
}

Any thoughts regarding what might be causing this? I don't have the full log, 
but I assume that the WARN_ON must have been in the logs.

I can easily protect rtlwifi, but I would like to know the cause.

Thanks,

Larry
