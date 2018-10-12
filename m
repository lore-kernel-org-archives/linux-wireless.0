Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9436DC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50D1D20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50D1D20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbeJLUFS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 16:05:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbeJLUFS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 16:05:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B7F630B96EE;
        Fri, 12 Oct 2018 12:33:03 +0000 (UTC)
Received: from localhost (unknown [10.40.205.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCF885C26E;
        Fri, 12 Oct 2018 12:33:00 +0000 (UTC)
Date:   Fri, 12 Oct 2018 14:32:59 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/13] mt76x0: pci: introduce mt76x0_phy_calirate routine
Message-ID: <20181012123259.GC2668@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
 <326458a15d0c242e7419e3bfc0033ccdc9083676.1539338611.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <326458a15d0c242e7419e3bfc0033ccdc9083676.1539338611.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 12 Oct 2018 12:33:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 12, 2018 at 12:16:20PM +0200, Lorenzo Bianconi wrote:
> Add mt76x0_phy_calirate routine in order to perform
> phy calibration for mt76x0e devices.
<snip>
> @@ -671,9 +713,14 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
>  	/* Vendor driver don't do it */
>  	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
>  
> -	mt76x0_vco_cal(dev, channel);
> -	if (scan)
> -		mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
> +	if (mt76_is_usb(dev)) {
> +		mt76x0_vco_cal(dev, channel);
> +		if (scan)
> +			mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
> +					      false);
> +	} else {
> +		mt76x0_phy_calibrate(dev, false);
> +	}

Why this should be diffrent for USB and PCI ? RF calibration seems
not to be realted to bus type, so perhaps this should be based on
mt76xx_rev() check?

Thanks
Stanislaw 
