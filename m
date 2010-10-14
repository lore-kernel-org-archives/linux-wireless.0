Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:24986 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab0JNU5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 16:57:36 -0400
Received: from wpaz24.hot.corp.google.com (wpaz24.hot.corp.google.com [172.24.198.88])
	by smtp-out.google.com with ESMTP id o9EKvZLK005945
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:57:35 -0700
Received: from iwn39 (iwn39.prod.google.com [10.241.68.103])
	by wpaz24.hot.corp.google.com with ESMTP id o9EKvInH006265
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:57:34 -0700
Received: by iwn39 with SMTP id 39so28822iwn.12
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 13:57:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287089496.4641.443.camel@jlt3.sipsolutions.net>
References: <20101013224851.9C46820418@glenhelen.mtv.corp.google.com>
	<1287040404.4641.5.camel@jlt3.sipsolutions.net>
	<AANLkTincG_-s4pWx+m=keMSfhzWfTQeCCGMQzHYk-WTA@mail.gmail.com>
	<1287089496.4641.443.camel@jlt3.sipsolutions.net>
Date: Thu, 14 Oct 2010 13:57:33 -0700
Message-ID: <AANLkTimF4ds7y681qKx6UWUUGtuO5_5Y_kzybuMSPd89@mail.gmail.com>
Subject: Re: [PATCH 2/6] Ad cfg80211 call for threshold notifications
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 1:51 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-14 at 13:43 -0700, Paul Stewart wrote:
>> I documented that this value in ieee80211_i.h.  Other parameters in
>> this file are left undocumented in this module (rssi_hyst, for
>> example, is documented in mac80211.h and nl80211.h (in fact, my docs
>> in nl80211.h look a little sparse -- I'll fix that up).  I don't
>> object to doing it -- I'm just trying to wrap my head around the
>> correct conventions.
>
> Anywhere is fine I guess (nl80211.h should work) but I didn't see any
> actual units? It would seem to be in Mbps but you're also using the
> ".bitrate" field from a channel, which is in units of 1/2 Mbps?


I'm using units of Kbps.  I think for a u32, that gives me enough room
to grow for a little while.  Good catch -- I'm using .bitrate wrong!

--
Paul
