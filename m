Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:40902 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbYIVPMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 11:12:12 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1395823fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2008 08:12:06 -0700 (PDT)
Message-ID: <1ba2fa240809220812v2d91bb18k4b78072fffd85e2c@mail.gmail.com> (sfid-20080922_171216_202633_ABD670CA)
Date: Mon, 22 Sep 2008 18:12:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/1] mac80211: fix led behavior in IBSS
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1222095543.3023.83.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222092610-25374-1-git-send-email-tomas.winkler@intel.com>
	 <1222095543.3023.83.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 5:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-09-22 at 17:10 +0300, Tomas Winkler wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch fixes the led behavior in IBSS. After we joined an IBSS cell we
>> need to inform the led that we got associated. Although there is no 802.11
>> association in IBSS mode, the semantic of "There is a link" is relevant.
>> This allows the led to blink in IBSS mode (at least this solves a bug for
>> iwlwifi).
>
> Doesn't it also have to be turned off again at some point? Or is that
> done? Other than that looks fine to me.

I've asked my self the same question  the answer is not clear. We
switch the led off on close/ifdown by radio led trigger.
Note in IBSS is always connected, carrier is always on if I'm not mistaken.
Tomas

>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
>> ---
>>  net/mac80211/mlme.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 2e55208..2bae226 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -1483,6 +1483,8 @@ static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
>>       ifsta->state = IEEE80211_STA_MLME_IBSS_JOINED;
>>       mod_timer(&ifsta->timer, jiffies + IEEE80211_IBSS_MERGE_INTERVAL);
>>
>> +     ieee80211_led_assoc(local, true);
>> +
>>       memset(&wrqu, 0, sizeof(wrqu));
>>       memcpy(wrqu.ap_addr.sa_data, bss->bssid, ETH_ALEN);
>>       wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
>
