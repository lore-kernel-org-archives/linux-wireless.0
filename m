Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38266 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbbBXKfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 05:35:09 -0500
Message-ID: <1424774105.2192.29.camel@sipsolutions.net> (sfid-20150224_113513_770720_CB049C9B)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 24 Feb 2015 11:35:05 +0100
In-Reply-To: <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com> (sfid-20150224_112828_368221_B3751798)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 <1424772587.2192.14.camel@sipsolutions.net>
	 <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
	 (sfid-20150224_112828_368221_B3751798)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-24 at 15:58 +0530, Krishna Chaitanya wrote:

> STA (mac80211) connects to AP in VHT-80.
> AP is reconfigured to 11n40 (stops beaconing for about 30secs and then
> starts again).
> STA loses connection (HW_CONN_TRACK), iee80211_connection_loss is called.
> STA see's AP again and tries to connect,

But this goes through the supplicant, right? You actually get a full
connection loss (which I certainly would expect after 30 seconds)

>  but due to BW tracking in
> mac80211 it doesn't connect.
> 
> So i guess we are not resetting the tracking after losing connection.

Right, some flag is not getting reset correctly I suppose. I thought we
had pretty robust code for this, but I guess not.

Easiest might be to print the flags and other state for during all
connection attempts, and then compare
 * VHT connection
 * subsequent HT connection
 * HT connection after reloading the driver

johannes

