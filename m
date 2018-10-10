Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C562EC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 966C821479
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 09:56:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 966C821479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbeJJRSL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 13:18:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbeJJRSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 13:18:11 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B7EFFC010C14;
        Wed, 10 Oct 2018 09:56:47 +0000 (UTC)
Received: from localhost (unknown [10.43.2.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3372517001;
        Wed, 10 Oct 2018 09:56:44 +0000 (UTC)
Date:   Wed, 10 Oct 2018 11:56:43 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt76x0: phy: fix mt76x0_temp_sensor routine
Message-ID: <20181010095642.GB2856@redhat.com>
References: <cover.1539162246.git.lorenzo.bianconi@redhat.com>
 <81232baeddb434362a3474842890ee9f316bfd67.1539162246.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81232baeddb434362a3474842890ee9f316bfd67.1539162246.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 10 Oct 2018 09:56:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 10, 2018 at 11:14:22AM +0200, Lorenzo Bianconi wrote:
> Fix configuration of register 67 on bank0 during temperature
> reading and use mt76_poll utility routine to poll core34
> register. Moreover temperature compensation need to be disabled
> if the device supports tssi compensation.
> This issue has never been hit since temperature reading is not
> actually used by usb code.
> 
> Fixes: 10de7a8b4ab9 ("mt76x0: phy files")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 43 +++++++++----------
>  1 file changed, 20 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> index 29bc4e4623cd..e9254452c7f5 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -763,48 +763,41 @@ void mt76x0_agc_restore(struct mt76x02_dev *dev)
>  	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
>  }
>  
> -static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
> +static int mt76x0_temp_sensor(struct mt76x02_dev *dev, int *temp)
<snip>

>  static void mt76x0_dynamic_vga_tuning(struct mt76x02_dev *dev)
> @@ -832,7 +825,11 @@ static void mt76x0_phy_calibrate(struct work_struct *work)
>  					       cal_work.work);
>  
>  	mt76x0_dynamic_vga_tuning(dev);
> -	mt76x0_temp_sensor(dev);
> +	if (!mt76x0_tssi_enabled(dev)) {
> +		int temp;
> +
> +		mt76x0_temp_sensor(dev, &temp);

Why this &temp is needed ? Preasumble it will be used in the future,
but maybe you could at least add dev_dbg() to print it's value?

Thanks
Stanislaw
