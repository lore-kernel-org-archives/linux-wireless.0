Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60700 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751721AbeCUHqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 03:46:08 -0400
Message-ID: <1521618365.2645.0.camel@sipsolutions.net> (sfid-20180321_084626_270105_3ECD3900)
Subject: Re: [RFC v5 4/9] cfg80211: Support all iftypes in autodisconnect_wk
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 08:46:05 +0100
In-Reply-To: <20180313215942.29176-5-denkenz@gmail.com> (sfid-20180313_230004_707143_95AC4AC9)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <20180313215942.29176-5-denkenz@gmail.com>
         (sfid-20180313_230004_707143_95AC4AC9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-13 at 16:59 -0500, Denis Kenzior wrote:
> Currently autodisconnect_wk assumes that only interface types of
> P2P_CLIENT and STATION use conn_owner_nlportid.  Change this so all
> interface types are supported.

Hmm. This sort of duplicates cfg80211_leave() for the most part, apart
from the special case with cfg80211_mlme_deauth(). I wonder why we need
that, and if we could use cfg80211_leave()?

johannes
