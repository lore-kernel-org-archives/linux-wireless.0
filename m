Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:15296 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbYDHWCq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 18:02:46 -0400
Received: by ug-out-1314.google.com with SMTP id z38so897317ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2008 15:02:44 -0700 (PDT)
Message-ID: <47FBEB7E.2070109@gmail.com> (sfid-20080408_230253_075253_36E14D59)
Date: Wed, 09 Apr 2008 00:02:38 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in	ieee80211_sta_expire
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com> <1207664966.14253.26.camel@johannes.berg>
In-Reply-To: <1207664966.14253.26.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2008 04:29 PM, Johannes Berg wrote:
>> ieee80211_sta_expire grabs local->sta_lock and calls sta_info_unlink
>> which tries to grab the lock again. (make available) and use
>> __sta_info_unlink variant instead.
> 
> A patch equivalent to this should already be in.

Yeah, it is. I already replied to myself after getting to know about 
wireless-testing, but forgot to click "send". Thanks.
