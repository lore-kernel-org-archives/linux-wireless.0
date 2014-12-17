Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:56237 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaLQIGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 03:06:42 -0500
Received: by mail-ig0-f174.google.com with SMTP id hn15so8342561igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 00:06:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418759663.1943.7.camel@sipsolutions.net>
References: <1418720165-19810-1-git-send-email-janusz.dziedzic@tieto.com>
	<1418759663.1943.7.camel@sipsolutions.net>
Date: Wed, 17 Dec 2014 09:06:41 +0100
Message-ID: <CALhHN=pmWR4jCeXtTiK4RwC5KP7i+29sO1mtftD2k1qLGg6ytw@mail.gmail.com> (sfid-20141217_090645_710627_D9F5DC65)
Subject: Re: [PATCH] mac80211: notify NSS changed when IBSS and HT
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 December 2014 at 20:54, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-12-16 at 09:56 +0100, Janusz Dziedzic wrote:
>
>>                       drv_sta_rc_update(local, sdata, &sta->sta,
>>                                         IEEE80211_RC_SUPP_RATES_CHANGED);
>> +                     /* Force rx_nss recalculation */
>> +                     sta->sta.rx_nss = 0;
>>                       rate_control_rate_init(sta);
>> +                     if (rx_nss != sta->sta.rx_nss)
>> +                             drv_sta_rc_update(local, sdata, &sta->sta,
>> +                                               IEEE80211_RC_NSS_CHANGED);
>
> Seems to me you should consolidate those two drv_sta_rc_update() calls
> and just make the flags dependent on the NSS change?
>
Will send v2.
