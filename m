Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40357 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0FKJEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 05:04:53 -0400
Subject: Re: [PATCH] mac80211: Use a separate CCMP PN receive counter for
 management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100611024625.GB3985@jm.kir.nu>
References: <20100611024625.GB3985@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 11:04:47 +0200
Message-ID: <1276247087.3640.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-06-10 at 19:46 -0700, Jouni Malinen wrote:
> When management frame protection (IEEE 802.11w) is used, we must use a
> separate counter for tracking received CCMP packet number for the
> management frames. The previously used NUM_RX_DATA_QUEUESth queue was
> shared with data frames when QoS was not used and that can cause
> problems in detecting replays incorrectly for robust management frames.
> Add a new counter just for robust management frames to avoid this issue.

Hmm, could you add a comment to the change in the header file that says
right there it's used for mgmt frames?

johannes

