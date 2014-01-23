Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaAWKuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 05:50:35 -0500
Message-ID: <1390474219.4142.9.camel@jlt4.sipsolutions.net> (sfid-20140123_115038_908367_0B9E6E15)
Subject: Re: [PATCH] nl80211: Count only ssid attr to know number of match
 sets
From: Johannes Berg <johannes@sipsolutions.net>
To: "Mani, Raja" <rmani@qti.qualcomm.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 23 Jan 2014 11:50:19 +0100
In-Reply-To: <BD8355E3EE4C424D96D29100D45098AB42C4027A@aphydexd01a.ap.qualcomm.com>
References: <1390451229-3308-1-git-send-email-rmani@qti.qualcomm.com>
	 <1390465052.4142.0.camel@jlt4.sipsolutions.net>
	 <BD8355E3EE4C424D96D29100D45098AB42C40238@aphydexd01a.ap.qualcomm.com>
	 <1390471178.4142.8.camel@jlt4.sipsolutions.net>
	 <BD8355E3EE4C424D96D29100D45098AB42C4027A@aphydexd01a.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 10:46 +0000, Mani, Raja wrote:
> >> >Err, you failed to explain *why* this is a problem. I'm not even convinced you're right anyway.
> 
> >> To know match set count, nl80211 should count only NL80211_SCHED_*_ATTR_SSID.
> >> Some cases, wpa_supplicant would pass NL80211_SCHED_*_ATTR_RSSI also 
> >> alone with NL80211_SCHED_*_ATTR_SSID.  For example, assume  one 
> >> NL80211_SCHED_*_ATTR_SSID and one NL80211_SCHED_*_ATTR_RSSI passed 
> >> from wpa_supplicant. In this case, nl80211 count 
> >> NL80211_SCHED_*_ATTR_RSSI also one of the profile , Finally match set 
> >> count will be come
> >> 2 in this case. (Ideally, match set count should be 1).  The same 
> >> count value is passed to driver, and driver also would assume there are two SSID available in match set array (request->match_sets).
> >> But only one SSID is valid in request->match_sets array in this case.
> >
> >You still haven't explained *why* you think that a match set should only be considered to be one when it includes an SSID. That doesn't seem to be the definition of the API.
> >
> >Johannes
> 
> Driver iterates match set array (request->match_sets) based on match set count (request->n_match_sets).
> In above example, only request->n_match_sets[0] will have valid SSID and  request->n_match_sets[1]) will have ZERO in its element always.
> By having count being 2 and having invalid SSID in request->n_match_sets[1] is the problem.  
> 
> Memory for request->match_sets is allocated based on match set count in nl80211.  By reducing the count ,  nl80211 don't have 
> To allocate memory for request->n_match_sets[1] and also driver can exactly know valid SSID count available in match set array with my change.

So essentially you're saying the match set API is completely stupid...
yeah that seems to match the code in nl80211_start_sched_scan() where it
looks at the match set...

Anyway, you need a far better commit log.

johannes

