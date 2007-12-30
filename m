Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:17587 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXL3JCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 04:02:05 -0500
Received: by rv-out-0910.google.com with SMTP id k20so4138058rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2007 01:02:04 -0800 (PST)
Message-ID: <c85cb4470712300102i609917f6xd61c7e66d34562fc@mail.gmail.com> (sfid-20071230_090208_934873_C4744066)
Date: Sun, 30 Dec 2007 11:02:04 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/8 v3] mac80211: A-MPDU Rx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198848340.4103.111.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
	 <11985948451654-git-send-email-ron.rindjunsky@intel.com>
	 <1198848340.4103.111.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +     list_for_each_entry(sta, &local->sta_list, list) {
> > +             for (i = 0; i <  STA_TID_NUM; i++)
> > +                     ieee80211_sta_stop_rx_ba_session(sta->dev, sta->addr,
> > +                                             i, WLAN_BACK_RECIPIENT,
> > +                                             WLAN_REASON_QSTA_LEAVE_QBSS);
> > +     }
>
> This needs something like
>
> if (sta->dev == dev)
>
> but I don't really care whether it's in this or a subsequent patch since
> we don't have drivers supporting multi-STA operation.

ok, i'll add this condition in a seperate patch.
thanks
ron

>
> johannes
>
>
