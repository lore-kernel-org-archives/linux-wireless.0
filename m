Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38200 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751714AbeCUPkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:40:46 -0400
Message-ID: <1521646843.2645.35.camel@sipsolutions.net> (sfid-20180321_164119_421013_F202F652)
Subject: Re: [RFC v5 4/9] cfg80211: Support all iftypes in autodisconnect_wk
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 16:40:43 +0100
In-Reply-To: <1fb6a106-2c9d-7ef4-c154-fa7c69602062@gmail.com> (sfid-20180321_162721_819338_BCC29E74)
References: <20180313215942.29176-1-denkenz@gmail.com>
         <20180313215942.29176-5-denkenz@gmail.com>
         <1521618365.2645.0.camel@sipsolutions.net>
         <1fb6a106-2c9d-7ef4-c154-fa7c69602062@gmail.com>
         (sfid-20180321_162721_819338_BCC29E74)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-21 at 10:27 -0500, Denis Kenzior wrote:
> 
> cfg80211_leave also messes with scans and autodisconnect_wk didn't.  So 
> I played it safe as I didn't want to introduce any silent semantic changes.

Makes sense, but we could pass an argument and avoid duplicating the
code?

> Also, cfg80211_leave uses stop_ap/leave_ibss with notify argument being 
> true, while I thought it made more sense to use false (as there's 
> arguably nobody left to pay attention to it) and to be consistent with 
> nl80211_stop_ap and nl80211_leave_ibss which also use false.

Fair enough.

> I don't see an issue with using cfg80211_leave though.  Just tell me 
> which way you prefer.

It just seemed duplicated, ultimately I don't think I care all that
much.

johannes
