Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:65385 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYGCR0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 13:26:10 -0400
Received: by yx-out-2324.google.com with SMTP id 8so300739yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2008 10:26:05 -0700 (PDT)
Message-ID: <1ba2fa240807031026k1763f64bu66fd03d0c1b254dc@mail.gmail.com> (sfid-20080703_192617_918907_449786D1)
Date: Thu, 3 Jul 2008 20:26:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: move netif_carrier_on to after ieee80211_bss_info_change_notify
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org, "Guy Cohen" <guy.cohen@intel.com>
In-Reply-To: <1215104870.9975.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215104173-8918-1-git-send-email-tomas.winkler@intel.com>
	 <1215104870.9975.17.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 3, 2008 at 8:07 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> -             netif_carrier_on(dev);
>>               ifsta->flags |= IEEE80211_STA_PREV_BSSID_SET;
>>               memcpy(ifsta->prev_bssid, sdata->u.sta.bssid, ETH_ALEN);
>>               memcpy(wrqu.ap_addr.sa_data, sdata->u.sta.bssid, ETH_ALEN);
>>               ieee80211_sta_send_associnfo(dev, ifsta);
>>       } else {
>> +             netif_carrier_off(dev);
>>               ieee80211_sta_tear_down_BA_sessions(dev, ifsta->bssid);
>>               ifsta->flags &= ~IEEE80211_STA_ASSOCIATED;
>> -             netif_carrier_off(dev);
>
> Maybe it should then be symmetric so that callers of the function have
> to do it in both cases? Other than that, looks good.

The sequence now is
  configure association in the driver  -> carrier_on ..... carrier_off
-> configure disassociation in the driver

So this is already symmetric or I don't understand what  you mean.

Thanks
Tomas
