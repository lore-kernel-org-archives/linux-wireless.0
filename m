Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:47114 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3KQNN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 08:13:27 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so1511249wes.29
        for <linux-wireless@vger.kernel.org>; Sun, 17 Nov 2013 05:13:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384679792.14795.9.camel@jlt4.sipsolutions.net>
References: <CABPxzYJAct6KtwqZY-DOgjf1wueSmeOU=iLku+gGeZ6ZVE6n9Q@mail.gmail.com>
 <1384679792.14795.9.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sun, 17 Nov 2013 18:43:06 +0530
Message-ID: <CABPxzY+XHXCFpKxU1NPZzb4eXP7x8i0-89eE+7uxWqGKnNsePw@mail.gmail.com> (sfid-20131117_142604_913940_4A169748)
Subject: Re: [Query] Update mac80211 BSS info from cfg8011_bss_inform_frame
 when hw_scan is enabled
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 17, 2013 at 2:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sat, 2013-11-16 at 01:19 +0530, Krishna Chaitanya wrote:
>
>> In those scenarios, the rate control module minstrel_ht called from
>> prep_connection throws a warning (in rate_control_send_low)
>> because "supp_rates" is not set, since scan results are updated
>>  through "cfg8011_bss_inform_frame" which doesn't call
>> "ieee80211_bss_info_update'.
>>
>> How do we handle such scenarios? Does the cfg80211 need to
>> update the bss information in mac80211?
>
> No. What are you smoking?
>
> You're not supposed to even call cfg80211_bss_inform_frame() from a
> mac80211-based driver. Just report the RX frame properly.
>
Ours is a partial Full MAC driver which still uses mac80211 but mostly with
offloads to HW.

With mac80211 + hw_scan if we just report the RX frames, then we are just
eliminating the SCAN SM from mac80211, is this just to reduce the host
cycles? (apart from speeding up the channel switch)
