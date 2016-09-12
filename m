Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58185 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756551AbcILMpD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:45:03 -0400
Message-ID: <1473684288.29016.38.camel@sipsolutions.net> (sfid-20160912_144507_093996_D4E5F1F7)
Subject: Re: [PATCH] mac80211: allow driver to handle packet-loss mechanism
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, rmanohar@codeaurora.org
Date: Mon, 12 Sep 2016 14:44:48 +0200
In-Reply-To: <20160906065624.4062-1-rmanohar@qti.qualcomm.com>
References: <20160906065624.4062-1-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-09-06 at 12:26 +0530, Rajkumar Manoharan wrote:
> mac80211 keeps track of missing acks and triggers CQM packet-loss
> mechanism whenever consecutive msdu failure reaches threshold limit
> (STA_LOST_PKT_THRESHOLD). Drivers like ath10k offlaoded rate countrol
> and aggregation to firmware. Such drivers have its own connection
> monitoring algorithm that is offloaded to firmware for triggering
> station kickout due to excessive tries. In VHT mode, single PPDU can
> have
> more than 50 msdus at higher rates. Under noisy environment, single
> ppdu
> failure can cause station kickout by current mac80211 lost_packet
> mechanism
> while firmware is trying to adapt its rate table. This is causing
> frequent
> connect and disconnect iteration when station is roaming around.
> 
> In such scenario, driver (or firmware) is not given enough chance to
> tune its rate control. So for devices that report low ack events, add
> a
> hardware flag to rely on their mechnism.
> 

The way you describe this it sounds like somehow you'll be reporting
the indication to userspace from the driver; but you do not, and cannot
do that. The description seems thus misleading?

johannes
