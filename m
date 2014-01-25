Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYIkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 03:40:14 -0500
Message-ID: <1390639211.4131.1.camel@jlt4.sipsolutions.net> (sfid-20140125_094019_694053_6AAAED68)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: "Mani, Raja" <rmani@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 25 Jan 2014 09:40:11 +0100
In-Reply-To: <BD8355E3EE4C424D96D29100D45098AB42C43A80@aphydexd01a.ap.qualcomm.com>
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	 <BD8355E3EE4C424D96D29100D45098AB42C43A80@aphydexd01a.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-01-25 at 05:46 +0000, Mani, Raja wrote:
> >@@ -5669,15 +5708,28 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
> >                                       nla_data(ssid), nla_len(ssid));
> >                                request->match_sets[i].ssid.ssid_len =
> >                                        nla_len(ssid);
> >+                               /* special attribute - old implemenation w/a */
> >+                               request->match_sets[i].rssi_thold =
> >+                                       default_match_rssi;
> 
> How about this case where RSSI is disabled for SSID1 and and SSID 4
> and only SSID2 and SSID3 needs RSSI filter.
> 
>    SSID1, SSID2, RSSI, SSID3, RSSI, SSID4
> 
> Wouldn't this change set RSSI of SSID3 to SSID1 and SSID4 ?
> Did i miss to understand anything ?

It's not a case that was previously supported. Previously, all you could
do was

{ SSID1 | SSID2 | SSID3 } + RSSI

Now, you can do

{ (SSID1, RSSI1) | (SSID2, RSSI2) | (SSID3, RSSI3) }

IOW, it wouldn't change anything - note how the RSSI value before used
to set request->rssi_thold, and not request->matchsets[i].rssi_thold.

johannes

