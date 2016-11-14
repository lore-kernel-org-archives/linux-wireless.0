Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58330 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932305AbcKNMoo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 07:44:44 -0500
Date: Mon, 14 Nov 2016 13:43:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 05/10] rt2800: make ba_size depend on ampdu_factor
Message-ID: <20161114124323.GA31857@redhat.com> (sfid-20161114_134447_767997_4BAAF23A)
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-6-git-send-email-sgruszka@redhat.com>
 <ebc4779b-a68b-f3b3-c8fc-87db9401a603@kresin.me>
 <20161114084536.GB12372@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161114084536.GB12372@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 14, 2016 at 09:45:36AM +0100, Stanislaw Gruszka wrote:
> Could you check below patch and see if it helps? If it does not,
> could you printk sta->ht_cap.ampdu_density and ba_size values
> and provide them here.

Actually please print parameters from below patch. I think ba_size
should be based on per TID buf_size instead of ampdu_factor, in case
STA has buf size different for some TIDs.

Also adding Felix to cc since my orginal patch:
http://marc.info/?l=linux-wireless&m=147809595316289&w=2
was shamelessly stolen from mt76 driver. Perhaps Felix could provide
us some expertise.

Thanks
Stanislaw

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2515702..35bc38c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7950,6 +7950,8 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct rt2x00_sta *sta_priv = (struct rt2x00_sta *)sta->drv_priv;
 	int ret = 0;
 
+	printk("action %d sta %pM tid %u buf_size %u ampdu_factor %u\n", params->action, sta->addr, params->tid, params->buf_size, sta->ht_cap.ampdu_factor);
+
 	/*
 	 * Don't allow aggregation for stations the hardware isn't aware
 	 * of because tx status reports for frames to an unknown station
