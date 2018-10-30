Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B485BC6786F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 09:39:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F27E2080A
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 09:39:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F27E2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbeJ3Scj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 14:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbeJ3Scj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 14:32:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E942DC050DFA;
        Tue, 30 Oct 2018 09:39:56 +0000 (UTC)
Received: from localhost (unknown [10.40.205.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9DC361D0B;
        Tue, 30 Oct 2018 09:39:46 +0000 (UTC)
Date:   Tue, 30 Oct 2018 10:39:46 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: run calibration after scanning
Message-ID: <20181030093945.GB26345@redhat.com>
References: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540808213-14442-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 30 Oct 2018 09:39:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 29, 2018 at 11:16:53AM +0100, Stanislaw Gruszka wrote:
> If we are associated and scanning is performed , sw_scan_complete callback
> is done after we get back to operating channel, so we do not perform
> phy calibration and queue cal work. Fix this by run calibration from
> sw_scan_complete().
> 
> Fixes: bbd10586f0df ("mt76x0: phy: do not run calibration during channel switch")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> This is for 4.20
> 
>  drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 19 +++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  2 ++
>  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  2 +-
>  4 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
> index a803a9b6a4c5..896a9d46bb76 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
> @@ -78,3 +78,22 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(mt76x0_config);
> +
> +void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
> +			     struct ieee80211_vif *vif)
> +{
> +	struct mt76x02_dev *dev = hw->priv;
> +
> +	mutex_lock(&dev->mt76.mutex);
> +	if (vif->bss_conf.assoc) {
> +		mt76x0_phy_calibrate(dev, false);
> +		mt76x0_phy_set_txpower(dev);

Actually I don't think this part is needed, it is done after channel
switch just before we associate, and that seems to be sufficient.

> +
> +		ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
> +					     MT_CALIBRATE_INTERVAL);

We just have to schedule this work, and mt76x2 suffer from similar
issue, so this can be done in mt76x02_sw_scan_complete(). Will
post v2.

Thanks
Stanislaw
