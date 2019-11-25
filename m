Return-Path: <SRS0=Ysg0=ZR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570B7C432C0
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 13:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BE932084D
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Nov 2019 13:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KM+M5NTm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKYNE7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:04:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31636 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727300AbfKYNE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Nov 2019 08:04:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574687098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FFq4MNuSrHKgSlBgZEZu49xbv73APsawokO3+OOYvNM=;
        b=KM+M5NTmwnLpe3IgGA5/PPItJ54sHvRsvraD9EL2T3djsqHUPsV9gS3mPHGx4C5OlbWYH/
        MXObZj2CMcwo/oQ7OT5XozhP6BfJZO5ccGvs1jjyta88AcJHnyTXzFcFI5cs4bUh8XFWaP
        Er8dZ6XIwQwmBzoyMNUU8zRdnJ3sG6I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-IVHwgZdZP56yOH2eCdtNSQ-1; Mon, 25 Nov 2019 08:04:55 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB29110054BB;
        Mon, 25 Nov 2019 13:04:53 +0000 (UTC)
Received: from localhost (unknown [10.43.2.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4D201001925;
        Mon, 25 Nov 2019 13:04:50 +0000 (UTC)
Date:   Mon, 25 Nov 2019 14:04:50 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v8 6/6] mt76: mt76x02: add channel switch support for usb
 interfaces
Message-ID: <20191125130449.GC28102@redhat.com>
References: <20191121180001.22451-1-markus.theil@tu-ilmenau.de>
 <20191121180001.22451-7-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
In-Reply-To: <20191121180001.22451-7-markus.theil@tu-ilmenau.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: IVHwgZdZP56yOH2eCdtNSQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 21, 2019 at 07:00:01PM +0100, Markus Theil wrote:
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/driv=
ers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> index 90c024f12302..b9bd6bfb2a9d 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
> @@ -210,6 +210,12 @@ static void mt76x02u_pre_tbtt_work(struct work_struc=
t *work)
> =20
>  =09mt76x02_mac_set_beacon_prepare(dev);
> =20
> +=09mt76_csa_check(&dev->mt76);
> +=09if (dev->mt76.csa_complete) {
> +=09=09mt76_csa_finish(&dev->mt76);
> +=09=09goto out;
> +=09}

mmio counterpart setup beacons on CSA, but do not sent buffered
PS frames. Perhaps here we should do the same. However not sending
beacons on one TBTT looks ok to me as well.

Stanislaw

