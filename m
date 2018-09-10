Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34724 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726081AbeIJOMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 10:12:09 -0400
Subject: Re: [PATCH 09/22] mt76: remove q->hw_idx
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
 <1536072075-6990-10-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <019f2c32-5a77-625e-cfa6-374501519581@nbd.name> (sfid-20180910_111908_127518_C8F7C06A)
Date: Mon, 10 Sep 2018 11:19:01 +0200
MIME-Version: 1.0
In-Reply-To: <1536072075-6990-10-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-04 16:41, Stanislaw Gruszka wrote:
> We use q->hw_idx in very few places, remove it and provide hwq index
> by diffrent way. This will allow ot unify conf_tx mac80211 callback.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
I think this patch is a step in the wrong direction, especially when it
comes to dealing with extra hardware queues for powersave delivery, or
beacons (on MT7603).
Also, removing q->hw_idx is not really necessary for unifying conf_tx
callbacks either.

- Felix
