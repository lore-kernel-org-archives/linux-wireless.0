Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51065 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYGJNJj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 09:09:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix TX sequence numbers
Date: Thu, 10 Jul 2008 15:09:15 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1215681686.3932.12.camel@johannes.berg>
In-Reply-To: <1215681686.3932.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807101509.15833.mb@bu3sch.de> (sfid-20080710_150942_434079_863970AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 July 2008 11:21:26 Johannes Berg wrote:
> This patch makes mac80211 assign proper sequence numbers to
> QoS-data frames. It also removes the old sequence number code
> because we noticed that only the driver or hardware can assign
> sequence numbers to non-QoS-data and especially management
> frames in a race-free manner because beacons aren't passed
> through mac80211's TX path.
> 
> This patch also adds temporary code to the rt2x00 drivers to
> not break them completely, that code will have to be reworked
> for proper sequence numbers on beacons.
> 
> It also moves sequence number assignment down in the TX path
> so no sequence numbers are assigned to frames that are dropped.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---


>  drivers/net/wireless/b43/xmit.c         |    3 -
>  drivers/net/wireless/b43legacy/xmit.c   |    3 -

ACK

-- 
Greetings Michael.
