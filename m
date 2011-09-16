Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46203 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1IPRCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 13:02:25 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so932529eya.19
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 10:02:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316177985.4130.29.camel@jlt3.sipsolutions.net>
References: <1316082334-7664-1-git-send-email-arik@wizery.com>
 <1316082334-7664-3-git-send-email-arik@wizery.com> <1316177985.4130.29.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 16 Sep 2011 19:57:05 +0300
Message-ID: <CA+XVXffEJ5fC+-GmV3rtqXKtts9t=WcurbrmmGOHchezoXs7vg@mail.gmail.com> (sfid-20110916_190228_411237_AA924DFC)
Subject: Re: [RFC 2/5] mac80211: handle TDLS high-level commands and frames
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalyan C Gaddam <chakkal@iit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 15:59, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-09-15 at 13:25 +0300, Arik Nemtsov wrote:
>
>> +     case NL80211_TDLS_ENABLE_LINK:
>> +             rcu_read_lock();
>> +             sta = sta_info_get(sdata, peer);
>> +             if (sta) {
>> +                     set_sta_flags(sta, WLAN_STA_AUTHORIZED);
>> +                     sta->tdls_link_enabled = true;
>> +             }
>> +             rcu_read_unlock();
>> +             break;
>
> This seems to require the station already having been added, but
> couldn't this create the data race you were worried about? Could you not
> simply just create the station once it is authorized?

The station is added only when the link is already authorized (see
wpa_tdls_enable_link() in wpa_s). This whole bit is kind of redundant.
A cleaner solution would be to just automatically authorize tdls
stations in ieee80211_add_station() and use WLAN_STA_TDLS_PEER instead
of tdls_link_enabled. I'll add this to my v2 list. Thanks.

While this creates a race, it's not the one i'm worried about. It will
also be solved automatically when the TDLS locking requirements are
met (as mentioned in a previous email).
But I agree your approach is cleaner.

>
>> +     case NL80211_TDLS_DISABLE_LINK:
>> +             rcu_read_lock();
>> +             sta = sta_info_get(sdata, peer);
>> +             if (sta) {
>> +                     sta->tdls_link_enabled = false;
>> +                     sta_info_destroy_addr(sdata, peer);
>> +             }
>> +             rcu_read_unlock();
>> +             break;
>
> Isn't that equivalent to just deleting the station?

Yep. The whole sta->tdls_link_enabled thing is kind of redundant. v2.

Arik
