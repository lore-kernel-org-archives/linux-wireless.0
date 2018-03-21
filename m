Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:37032 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbeCUP1V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:27:21 -0400
Received: by mail-pl0-f65.google.com with SMTP id w12-v6so3318342plp.4
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 08:27:20 -0700 (PDT)
Subject: Re: [RFC v5 4/9] cfg80211: Support all iftypes in autodisconnect_wk
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180313215942.29176-1-denkenz@gmail.com>
 <20180313215942.29176-5-denkenz@gmail.com>
 <1521618365.2645.0.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <1fb6a106-2c9d-7ef4-c154-fa7c69602062@gmail.com> (sfid-20180321_162730_921441_2725204B)
Date: Wed, 21 Mar 2018 10:27:18 -0500
MIME-Version: 1.0
In-Reply-To: <1521618365.2645.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 03/21/2018 02:46 AM, Johannes Berg wrote:
> On Tue, 2018-03-13 at 16:59 -0500, Denis Kenzior wrote:
>> Currently autodisconnect_wk assumes that only interface types of
>> P2P_CLIENT and STATION use conn_owner_nlportid.  Change this so all
>> interface types are supported.
> 
> Hmm. This sort of duplicates cfg80211_leave() for the most part, apart
> from the special case with cfg80211_mlme_deauth(). I wonder why we need
> that, and if we could use cfg80211_leave()?

cfg80211_leave also messes with scans and autodisconnect_wk didn't.  So 
I played it safe as I didn't want to introduce any silent semantic changes.

Also, cfg80211_leave uses stop_ap/leave_ibss with notify argument being 
true, while I thought it made more sense to use false (as there's 
arguably nobody left to pay attention to it) and to be consistent with 
nl80211_stop_ap and nl80211_leave_ibss which also use false.

I don't see an issue with using cfg80211_leave though.  Just tell me 
which way you prefer.

Regards,
-Denis
