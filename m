Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0C8C65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:37:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5D1920875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5D1920875
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbeJEPfg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:35:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbeJEPfg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:35:36 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABEB8308213E;
        Fri,  5 Oct 2018 08:37:55 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21B8D5C1B4;
        Fri,  5 Oct 2018 08:37:54 +0000 (UTC)
Date:   Fri, 5 Oct 2018 10:37:49 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: crash in ieee80211_wake_txqs
Message-ID: <20181005083748.GD1931@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 05 Oct 2018 08:37:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

I have crash in ieee80211_wake_txqs:
https://imgur.com/a/VIrU9yK
when starting mt76x0u driver. Not sure if this is beacuse the driver
do not initalize sta->txq properly, but reverting the

commit 21a5d4c3a45ca608477a083096cfbce76e449a0c
Author: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Date:   Wed Jul 11 00:12:53 2018 +0530

    mac80211: add stop/start logic for software TXQs

make crash gone.

gdb pointed at 'if (ac != txq->ac)' line in the code:

               for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
                       struct ieee80211_txq *txq = sta->sta.txq[i];

                       txqi = to_txq_info(txq);

                       if (ac != txq->ac)
                               continue;

Looks txq is NULL and referencing txq->ac crashes.

Thanks
Stanislaw
