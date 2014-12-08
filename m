Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40641 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaLHKHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2014 05:07:44 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so4199298wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2014 02:07:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418023628.2001.0.camel@sipsolutions.net>
References: <1417947627-2329-1-git-send-email-vadim4j@gmail.com>
	<1418023628.2001.0.camel@sipsolutions.net>
Date: Mon, 8 Dec 2014 12:07:42 +0200
Message-ID: <CAMw6YJ+8JpgTG4AbJo71JuOW8jpEo5HxFX=bDDPcpd4L_b6drA@mail.gmail.com> (sfid-20141208_110808_108273_B2308FCC)
Subject: Re: [PATCH v2] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You meant here ?

net/wireless/core.c : static int cfg80211_netdev_notifier_call(struct
notifier_block *nb,
                                          unsigned long state, void *ptr)
{

    ...
    switch (state) {
             case NETDEV_POST_INIT:
                     SET_NETDEV_DEVTYPE(dev, &wiphy_type);
                     break;
             case NETDEV_REGISTER:
                     ...
                     dev->rtnl_link_ops = &wireless_link_ops;
                     ...
    }
    ...
}

Regards,

On Mon, Dec 8, 2014 at 9:27 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2014-12-07 at 12:20 +0200, Vadim Kochan wrote:
>
>> +++ b/net/mac80211/iface.c
>
>> @@ -1624,6 +1625,10 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
>>       mutex_unlock(&local->iflist_mtx);
>>  }
>>
>> +static struct rtnl_link_ops wireless_link_ops __read_mostly = {
>> +     .kind = "wlan",
>> +};
>
> I think it would make sense to set it - if not already set - in the
> netdev notifier in cfg80211.
>
> johannes
>
