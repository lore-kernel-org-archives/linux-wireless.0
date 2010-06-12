Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:2676 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0FLReb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:34:31 -0400
Subject: Re: [PATCH v2] mac80211: Use a separate CCMP PN receive counter
 for management frames
From: Pavel Roskin <proski@gnu.org>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100611172733.GA21347@jm.kir.nu>
References: <20100611024625.GB3985@jm.kir.nu>
	 <20100611172733.GA21347@jm.kir.nu>
Content-Type: text/plain
Date: Sat, 12 Jun 2010 13:34:27 -0400
Message-Id: <1276364067.2625.12.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-11 at 10:27 -0700, Jouni Malinen wrote:

> -		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
> +		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {

Perhaps we could have a define for NUM_RX_DATA_QUEUES + 1, e.g.
NUM_RX_ALL_QUEUES

> +			int queue = ieee80211_is_mgmt(fc) ?
> +				NUM_RX_DATA_QUEUES : rx->queue;

Again, it would be nice to add a define for readability, e.g.
#define NUM_RX_MGMT_QUEUE NUM_RX_DATA_QUEUES

-- 
Regards,
Pavel Roskin
