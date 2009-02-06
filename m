Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38180 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbZBFQnK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 11:43:10 -0500
Subject: Re: turning off IBSS (with wext)
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1233928622.4175.9.camel@johannes.local>
References: <1233928622.4175.9.camel@johannes.local>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 11:41:36 -0500
Message-Id: <1233938496.28437.10.camel@localhost> (sfid-20090206_174315_252955_401A01DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-06 at 14:57 +0100, Johannes Berg wrote:
> Hi,
> 
> so I was testing IBSS, and found this strange behaviour:
> 
>  * wpa_supplicant (or NM?) will try to do SIWMLME(disassoc) in IBSS
>    mode, which seems kinda wrong. Why do we accept it? We send out a
>    frame and then do nothing else.
>  * Then I thought "iwconfig wlan1 essid off" - but that fails with
>    -EINVAL due to ieee80211_sta_find_ibss
> 
> It seems to me that either one of those, or both, should actually turn
> off beaconing.

Either one; the supplicant uses SIWMLME(disassoc) at various times (like
when leaving a BSS), and NM will sometimes set a NULL SSID when
deactivating the device.

Dan


