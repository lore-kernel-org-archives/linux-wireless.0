Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:1539 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYDEHnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2008 03:43:43 -0400
Received: by wa-out-1112.google.com with SMTP id v27so362466wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2008 00:43:42 -0700 (PDT)
Message-ID: <1ba2fa240804050043v247e1485x7a8af55e55cc40b2@mail.gmail.com> (sfid-20080405_084416_600696_78C62964)
Date: Sat, 5 Apr 2008 10:43:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: mac80211: ieee80211_ops.bss_info_changed question
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <D936D925018D154694D8A362EEB08920041CCC73@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <D936D925018D154694D8A362EEB08920041CC3C6@orsmsx416.amr.corp.intel.com>
	 <1207320205.19189.25.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB08920041CCC73@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 5, 2008 at 2:11 AM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
>
> On Friday, April 04, 2008 7:43 AM, Johannes Berg  wrote:
>
>  > Reinette,
>  >
>  >> In the comments about bss_info_changed it is said that the callback
>  >> has to be atomic. I was looking at it and could only find that it is
>  >> called either from the workqueue or an ioctl. It thus seems that we
>  >> may be able to sleep in there. I likely missed the spot where it
>  >> needs to be atomic ... could you please direct me to it?
>  >
>  > I think you may be right, I can't find any spots either. I was likely
>  > mislead when writing that by the fact that much of the code in
>  > ieee80211_sta.c uses GFP_ATOMIC while it actually runs from a
>  > workqueue, which is actually confusing me still.
>
>  My mistake ... it can be called from tasklet during scanning
>  (ieee80211_sta_rx_scan). The comment that requires it to be atomic is
>  correct.
>
Haven't look at the code but IMHO this function should not be called
from scanning, Only beacons from
connected AP should affect the driver behavior. These beacons are
received even without scanning.

Tomas

>
>  Reinette
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
