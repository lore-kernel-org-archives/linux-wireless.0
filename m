Return-Path: <SRS0=9ImR=NH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF770C46475
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 15:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 992902085B
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 15:04:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 992902085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbeJ0XpW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Oct 2018 19:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbeJ0XpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Oct 2018 19:45:22 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51B717F3F1;
        Sat, 27 Oct 2018 15:04:05 +0000 (UTC)
Received: from localhost (ovpn-204-73.brq.redhat.com [10.40.204.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42EED5D73F;
        Sat, 27 Oct 2018 15:04:01 +0000 (UTC)
Date:   Sat, 27 Oct 2018 17:04:01 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH 4/4] mt76: add support for reporting tx status with skb
Message-ID: <20181027150400.GA11469@redhat.com>
References: <20181025165541.84815-1-nbd@nbd.name>
 <20181025165541.84815-4-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025165541.84815-4-nbd@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sat, 27 Oct 2018 15:04:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 25, 2018 at 06:55:41PM +0200, Felix Fietkau wrote:
> +	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
> +	u8 done = MT_TX_CB_DMA_DONE | MT_TX_CB_TXS_DONE;
can be "const u8 done = ..."

> +mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
> +		       struct sk_buff *skb)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct mt76_tx_cb *cb = mt76_tx_skb_cb(skb);
> +	int pid;
> +
> +	if (!wcid || !wcid->sta)
> +		return 0;

Due to !wcid->sta check I can not associate with AP on MT7610U,
because we use pid = 0 for assoc frames which are marked
IEEE80211_TX_CTL_REQ_TX_STATUS .
After removing it and leave just !wcid check, things work ok.

Thanks
Stanislaw
