Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:14331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab0JNUnx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 16:43:53 -0400
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id o9EKhqUF013289
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:43:52 -0700
Received: from iwn10 (iwn10.prod.google.com [10.241.68.74])
	by wpaz17.hot.corp.google.com with ESMTP id o9EKhjdZ027813
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:43:51 -0700
Received: by iwn10 with SMTP id 10so7458iwn.31
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:43:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287040404.4641.5.camel@jlt3.sipsolutions.net>
References: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
	<1287040404.4641.5.camel@jlt3.sipsolutions.net>
Date: Thu, 14 Oct 2010 13:43:50 -0700
Message-ID: <AANLkTincG_-s4pWx+m=keMSfhzWfTQeCCGMQzHYk-WTA@mail.gmail.com>
Subject: Re: [PATCH 2/6] Ad cfg80211 call for threshold notifications
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I documented that this value in ieee80211_i.h.  Other parameters in
this file are left undocumented in this module (rssi_hyst, for
example, is documented in mac80211.h and nl80211.h (in fact, my docs
in nl80211.h look a little sparse -- I'll fix that up).  I don't
object to doing it -- I'm just trying to wrap my head around the
correct conventions.

--
Paul

On Thu, Oct 14, 2010 at 12:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-10-13 at 15:10 -0700, Paul Stewart wrote:
>> Similar to its rssi counterpart, provide a cfg80211 call for sending
>> bitrate change updates.
>>
>
>> +     int     (*set_cqm_bitrate_config)(struct wiphy *wiphy,
>> +                                       struct net_device *dev,
>> +                                       u32 bitrate_thold);
>> +
>
> Need to document units here ... Also, when you start looking at that,
> things get really awkward HT -- you don't really want to have to
> determine the bitrate for HT packets for every single one, I think.
>
> johannes
>
>
