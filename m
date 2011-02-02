Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33296 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1BBKQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 05:16:25 -0500
Subject: Re: [PATCH] wl12xx: declare support for
 IEEE80211_HW_REPORTS_TX_ACK_STATUS
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1296638405-28704-1-git-send-email-eliad@wizery.com>
References: <1296638405-28704-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Feb 2011 11:16:22 +0100
Message-ID: <1296641782.5671.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-02 at 11:20 +0200, Eliad Peller wrote:
> The wl12xx fw supports ack status reporting for tx frames, so
> add the IEEE80211_HW_REPORTS_TX_ACK_STATUS flag to our supported
> features.
> 
> Since we do the rate control in the fw, we'll probably want
> to adjust the STA_LOST_PKT_THRESHOLD heuristics in the future, to
> account for retransmissions as well.

I agree, they're very rough -- they don't even account for
retransmissions now. I also think some timing should be taken into
account as TCP will quickly stop sending packets.

johannes

