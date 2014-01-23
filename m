Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44694 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaAWJ7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:59:51 -0500
Message-ID: <1390471178.4142.8.camel@jlt4.sipsolutions.net> (sfid-20140123_105955_596415_6E05D1B5)
Subject: Re: [PATCH] nl80211: Count only ssid attr to know number of match
 sets
From: Johannes Berg <johannes@sipsolutions.net>
To: "Mani, Raja" <rmani@qti.qualcomm.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 23 Jan 2014 10:59:38 +0100
In-Reply-To: <BD8355E3EE4C424D96D29100D45098AB42C40238@aphydexd01a.ap.qualcomm.com>
References: <1390451229-3308-1-git-send-email-rmani@qti.qualcomm.com>
	 <1390465052.4142.0.camel@jlt4.sipsolutions.net>
	 <BD8355E3EE4C424D96D29100D45098AB42C40238@aphydexd01a.ap.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 09:53 +0000, Mani, Raja wrote:

> >Err, you failed to explain *why* this is a problem. I'm not even convinced you're right anyway.

> To know match set count, nl80211 should count only NL80211_SCHED_*_ATTR_SSID.
> Some cases, wpa_supplicant would pass NL80211_SCHED_*_ATTR_RSSI also alone with
> NL80211_SCHED_*_ATTR_SSID.  For example, assume  one NL80211_SCHED_*_ATTR_SSID and
> one NL80211_SCHED_*_ATTR_RSSI passed from wpa_supplicant. In this case, nl80211 count
> NL80211_SCHED_*_ATTR_RSSI also one of the profile , Finally match set count will be come
> 2 in this case. (Ideally, match set count should be 1).  The same count value is passed to driver,
> and driver also would assume there are two SSID available in match set array (request->match_sets).
> But only one SSID is valid in request->match_sets array in this case.

You still haven't explained *why* you think that a match set should only
be considered to be one when it includes an SSID. That doesn't seem to
be the definition of the API.

johannes

