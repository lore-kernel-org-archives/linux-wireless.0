Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3BROBi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:01:38 -0500
Message-ID: <1361196089.8555.12.camel@jlt4.sipsolutions.net> (sfid-20130218_150144_762234_DEA874EE)
Subject: Re: Regression caused by commit df88129
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 18 Feb 2013 15:01:29 +0100
In-Reply-To: <51207925.5040702@lwfinger.net> (sfid-20130217_073124_813060_AAE5AFC8)
References: <51207925.5040702@lwfinger.net>
	 (sfid-20130217_073124_813060_AAE5AFC8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-02-17 at 00:31 -0600, Larry Finger wrote:
> Jouni and Johannes,
> 
> A recent pull of the wireless-testing tree caused my wireless to break. The 
> wireless devices can authenticate and associate as follows:
> 
> wlan0: authenticate with c0:3f:0e:be:2b:44
> wlan0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
> wlan0: send auth to c0:3f:0e:be:2b:44 (try 1/3)
> wlan0: authenticated
> wlan0: associate with c0:3f:0e:be:2b:44 (try 1/3)
> wlan0: RX AssocResp from c0:3f:0e:be:2b:44 (capab=0x411 status=0 aid=3)
> wlan0: associated
> IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
> b43-phy0 debug: Using hardware based encryption for keyidx: 0, mac: 
> c0:3f:0e:be:2b:44
> b43-phy0 debug: Using hardware based encryption for keyidx: 1, mac: 
> ff:ff:ff:ff:ff:ff
> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)
> wlan0: dropped frame to c0:3f:0e:be:2b:44 (unauthorized port)

Yeah, it's obvious that this would happen for drivers not supporting
TDLS -- will send a patch.

johannes

