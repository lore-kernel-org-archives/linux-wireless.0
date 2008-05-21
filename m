Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:37848 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962AbYEUKrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 06:47:04 -0400
Received: by wa-out-1112.google.com with SMTP id j37so2884820waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 03:47:04 -0700 (PDT)
Message-ID: <1ba2fa240805210347w375b571djc922f814fa9f521f@mail.gmail.com> (sfid-20080521_124747_596272_ABECD5FA)
Date: Wed, 21 May 2008 13:47:04 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Helmut Schaa" <hschaa@suse.de>
Subject: Re: [PATCHv5] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Cc: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	"Bruno Randolf" <bruno@thinktube.com>
In-Reply-To: <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de>
	 <1ba2fa240805200554w9354d14v9abc70f676540b9b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 20, 2008 at 3:54 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, May 20, 2008 at 10:56 AM, Helmut Schaa <hschaa@suse.de> wrote:
>> Fix a possible NULL pointer dereference in ieee80211_compatible_rates
>> introduced in the patch "mac80211: fix association with some APs". If no bss
>> is available just use all supported rates in the association request.
>>
>> Signed-off-by: Helmut Schaa <hschaa@suse.de>
>> ---
>>
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 76ad4ed..3f7f92a 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -721,7 +721,17 @@ static void ieee80211_send_assoc(struct net_device
>> *dev,
>>                        capab |= WLAN_CAPABILITY_PRIVACY;
>>                if (bss->wmm_ie)
>>                        wmm = 1;
>> +
>> +               /* get all rates supported by the device and the AP as
>> +                * some APs don't like getting a superset of their rates
>> +                * in the association request (e.g. D-Link DAP 1353 in
>> +                * b-only mode) */
>> +               rates_len = ieee80211_compatible_rates(bss, sband, &rates);
>> +
>>                ieee80211_rx_bss_put(dev, bss);
>> +       } else {
>> +               rates = ~0;
>> +               rates_len = sband->n_bitrates;
>>        }
>>
>>        mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
>> @@ -752,10 +762,7 @@ static void ieee80211_send_assoc(struct net_device
>> *dev,
>>        *pos++ = ifsta->ssid_len;
>>        memcpy(pos, ifsta->ssid, ifsta->ssid_len);
>>
>> -       /* all supported rates should be added here but some APs
>> -        * (e.g. D-Link DAP 1353 in b-only mode) don't like that
>> -        * Therefore only add rates the AP supports */
>> -       rates_len = ieee80211_compatible_rates(bss, sband, &rates);
>> +       /* add all rates which were marked to be used above */
>>        supp_rates_len = rates_len;
>>        if (supp_rates_len > 8)
>>                supp_rates_len = 8;
>>
>>
>
> I found one  ieee80211_rx_bss_{get,put} imbalance   in
> ieee80211_sta_join_ibss function
> That may cause this problem yet it doesn't look like this is the case.
> ieee80211_sta_join_ibss
> calls ieee80211_rx_bss_put on 'bss' that it receives as an argument

The patch below introduced  _get/_put imbalance. ieee80211_rx_bss_info
_put bss back at the end. Other callers of the ieee80211_sta_join_ibss
function don't use put.
I will post a patch that takes out the _put out of
ieee80211_rx_bss_info, I think it's more readable.

commit 9d9bf77d16ba527f6f63846ca18cf20ae6e8d697
Author: Bruno Randolf <bruno@thinktube.com>
Date:   Mon Feb 18 11:21:36 2008 +0900

    mac80211: enable IBSS merging

Tomas
