Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494A7C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E8AA206B2
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 05:48:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E8AA206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbeJAMYs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 08:24:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728593AbeJAMYs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 08:24:48 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C9C5130E684D;
        Mon,  1 Oct 2018 05:48:46 +0000 (UTC)
Received: from localhost (ovpn-204-71.brq.redhat.com [10.40.204.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E18E60851;
        Mon,  1 Oct 2018 05:48:40 +0000 (UTC)
Date:   Mon, 1 Oct 2018 07:48:39 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [RFC 4/5] mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
Message-ID: <20181001054838.GC22206@redhat.com>
References: <20180929174456.995-5-lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180929174456.995-5-lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 01 Oct 2018 05:48:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Sep 29, 2018 at 07:44:55PM +0200, Lorenzo Bianconi wrote:
> +	spin_lock_bh(&dev->lock);
> +	if (wcid && (rate->idx < 0 || !rate->count)) {
> +		txwi->rate = wcid->tx_rate;
> +		max_txpwr_adj = wcid->max_txpwr_adj;
> +		nss = wcid->tx_rate_nss;
> +	} else {
> +		txwi->rate = mt76x02_mac_tx_rate_val(dev, rate, &nss);
> +		max_txpwr_adj = mt76x02_tx_get_max_txpwr_adj(dev, rate);
> +	}
> +	spin_unlock_bh(&dev->lock);
> +
> +	if (dev->drv->get_tx_txpwr_adj) {
> +		txpwr_adj = dev->drv->get_tx_txpwr_adj(dev, dev->txpower_conf,
> +						       max_txpwr_adj);
> +		txwi->ctl2 = FIELD_PREP(MT_TX_PWR_ADJ, txpwr_adj);
> +	}
> +
> +	if (is_mt76x2(dev) && mt76_rev(dev) >= MT76XX_REV_E4)
> +		txwi->txstream = 0x13;
> +	else if (is_mt76x2(dev) && mt76_rev(dev) >= MT76XX_REV_E3 &&
> +		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
> +		txwi->txstream = 0x93;

All above looks mt76x2 specific, maybe would be beter to place this in 
in setup_txwi() calback i.e:

	if (dev->drv->setup_txwi)
		drv->drv->setup_txwi(...)

or maybe you plan to implement get_tx_txpwr_adj() for mt76x0 as well,
is this feature supported by the MT76x0 chips ?

Thanks
Stanislaw
