Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62844 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GELs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:48:58 -0400
Received: by yenl2 with SMTP id l2so7242145yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 04:48:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341474140.4455.4.camel@jlt3.sipsolutions.net>
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
 <1341417530-9062-4-git-send-email-arik@wizery.com> <1341474140.4455.4.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 5 Jul 2012 14:48:42 +0300
Message-ID: <CA+XVXffsSac_CC5-yh0MAozm+z2P_ge9BfNbsdMWV_YmY7dHiA@mail.gmail.com> (sfid-20120705_134902_007190_F903CAED)
Subject: Re: [RFC 3/4] cfg80211: allow driver to implement HT capabilities per netdev
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 10:42 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-07-04 at 18:58 +0300, Arik Nemtsov wrote:
>
>>       void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
>> +     struct ieee80211_sta_ht_cap *(*get_ht_cap)(struct wiphy *wiphy,
>> +                                                struct net_device *dev,
>> +                                                enum ieee80211_band band);
>
> Ok so ... I really don't like this whole concept to start with, but you
> convinced me it was needed. This is just ugly though. Now you can
> suddenly change the HT caps randomly at runtime? That's ... distressing
> for userspace!
>
> Is there any chance this can just be a pointer inside the wdev struct?
> Then at least we can verify it in NETDEV_UP if you had invalid HT caps
> originally, etc.

Yea I guess it can be confusing. Sure we can make it part of the wdev
and add some verification. Propagate the pointers from the mac80211
vif in ieee80211_do_open().
But does cfg80211 code even have a hook on NETDEV_UP?
