Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41394 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbbBXUrt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 15:47:49 -0500
Message-ID: <1424810867.2192.60.camel@sipsolutions.net> (sfid-20150224_214752_281898_0CFADFAC)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Feb 2015 21:47:47 +0100
In-Reply-To: <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com> (sfid-20150224_213325_720148_1E90D9CE)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 <1424772587.2192.14.camel@sipsolutions.net>
	 <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
	 <1424774105.2192.29.camel@sipsolutions.net>
	 <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
	 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com>
	 (sfid-20150224_213325_720148_1E90D9CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-02-25 at 02:03 +0530, Krishna Chaitanya wrote:

> Use case2: When changing from HT40-VHT80, the connection goes through
> but it still connected as HT40 (vht_ie from cfg80211 is returned
> null).
> 
> Can you think of any reason why the bss_list is not updated cfg80211?
> Note: iwconfig and wpa_supplicant both show same behavior.

Well, there's no flushing, only overwriting by new results - but if you
previuosly got both beacons and probe responses each one will stick
around until you get them again.

This sounds synthetic - just run your test scripts with "iw wlan0 scan
flush".

johannes

