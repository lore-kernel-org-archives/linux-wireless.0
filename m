Return-Path: <SRS0=qkCK=NK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91515C2BC61
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 13:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E942081B
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Oct 2018 13:21:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55E942081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbeJ3WOf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Oct 2018 18:14:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727966AbeJ3WOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Oct 2018 18:14:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1FC0288E66;
        Tue, 30 Oct 2018 13:21:10 +0000 (UTC)
Received: from localhost (unknown [10.40.205.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD9B4620D1;
        Tue, 30 Oct 2018 13:21:08 +0000 (UTC)
Date:   Tue, 30 Oct 2018 14:20:59 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: use band parameter for LC calibration
Message-ID: <20181030131854.GA26291@redhat.com>
References: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540484313-9354-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 30 Oct 2018 13:21:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 25, 2018 at 06:18:33PM +0200, Stanislaw Gruszka wrote:
> We use always 1 as band parameter for MCU_CAL_LC, this break 2GHz,
> we should use 0 for this band instead.
> 
> Patch fixes problems happened sometimes when try to associate with 2GHz
> AP and manifest by errors like below:
> 
> [14680.920823] wlan0: authenticate with 18:31:bf:c0:51:b0
> [14681.109506] wlan0: send auth to 18:31:bf:c0:51:b0 (try 1/3)
> [14681.310454] wlan0: send auth to 18:31:bf:c0:51:b0 (try 2/3)
> [14681.518469] wlan0: send auth to 18:31:bf:c0:51:b0 (try 3/3)
> [14681.726499] wlan0: authentication with 18:31:bf:c0:51:b0 timed out
> 
> Fixes: 9aec146d0f6b ("mt76x0: pci: introduce mt76x0_phy_calirate routine")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> This is for 4.20.

Actually it is not needed for 4.20, bacause the new calibrate code is
not use for USB in 4.20. It start to be used since:

commit e868a944c55b1f42303ab2941dc1aaada9a3570c
Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon Oct 15 14:18:05 2018 +0200

    mt76x0: phy: unify calibration between mt76x0u and mt76x0e

Regards
Stanislaw
