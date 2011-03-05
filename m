Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55341 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1CETOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 14:14:10 -0500
Received: by vxi39 with SMTP id 39so2862460vxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Mar 2011 11:14:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299333700.3826.2.camel@jlt3.sipsolutions.net>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
 <1299288252-28314-5-git-send-email-thomas@cozybit.com> <1299333700.3826.2.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 5 Mar 2011 11:13:50 -0800
Message-ID: <AANLkTi=B42wkh2khdPNyyJvy01E2PmtzGunhPtJSNyeD@mail.gmail.com>
Subject: Re: [PATCH 4/4 v2] mac80211: Let userspace create stations when mesh
 security is enabled
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 6:01 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-03-04 at 17:24 -0800, Thomas Pedersen wrote:
>
>> +++ b/net/mac80211/mesh_plink.c
>> @@ -105,7 +105,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
>>       if (!sta)
>>               return NULL;
>>
>> -     sta->flags = WLAN_STA_AUTHORIZED;
>> +     sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
>>       sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
>>       rate_control_rate_init(sta);
>
> This is just for consistency now, right? The AUTH flag isn't tested, but
> stations from userspace will have it set, afaiu?

Right.


-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
