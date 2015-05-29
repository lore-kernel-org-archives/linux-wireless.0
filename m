Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:35280 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbbE2LeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 07:34:10 -0400
Received: by wicmx19 with SMTP id mx19so14652085wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 04:34:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432897812.2104.7.camel@sipsolutions.net>
References: <1432039021-29666-1-git-send-email-michal.kazior@tieto.com>
	<1432285043-8878-1-git-send-email-michal.kazior@tieto.com>
	<1432285043-8878-2-git-send-email-michal.kazior@tieto.com>
	<1432897812.2104.7.camel@sipsolutions.net>
Date: Fri, 29 May 2015 13:34:07 +0200
Message-ID: <CA+BoTQmkg8KBhFGqSsdt6Sks6JGUDGnM2oSzMSEWtCEz-abwzA@mail.gmail.com> (sfid-20150529_133414_453174_0F64E8F7)
Subject: Re: [PATCH v2 2/2] mac80211: guard against invalid ptr deref
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29 May 2015 at 13:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-05-22 at 10:57 +0200, Michal Kazior wrote:
>> It was possible for mac80211 to be coerced into an
>> unexpected flow causing sdata union to become
>> corrupted. Station pointer was put into
>> sdata->u.vlan.sta memory location while it was
>> really master AP's sdata->u.ap.next_beacon. This
>> led to station entry being later freed as
>> next_beacon before __sta_info_flush() in
>> ieee80211_stop_ap() and a subsequent invalid
>> pointer dereference crash.
>>
>> The problem was that ieee80211_ptr->use_4addr
>> wasn't cleared on interface type changes.
[...]
>> Even though this can and should be fixed in
>> cfg80211 it still makes sense to add a sanity
>> check to mac80211 to prevent future problems.
>
> I'm a bit undecided about this. Is this really the only place that
> assumes use_4addr implies that it's a VLAN, in a context like this?

Hmm.. I guess TDLS could also have use_4addr and still be a
IFTYPE_STATION, right? In which case parent condition should be
modified instead:

 if (vlansdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
     params->vlan->ieee80211_ptr->use_4addr) { ...


Michał
