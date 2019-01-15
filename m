Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B3EAC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455F020866
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 15:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730947AbfAOPfw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 10:35:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729622AbfAOPfw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 10:35:52 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 429805A1F9;
        Tue, 15 Jan 2019 15:35:52 +0000 (UTC)
Received: from localhost (unknown [10.40.205.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97C985CC03;
        Tue, 15 Jan 2019 15:35:47 +0000 (UTC)
Date:   Tue, 15 Jan 2019 16:35:47 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org, rosenp@gmail.com
Subject: Re: [RFC 0/4] do not use sg if not properly supported by usb
 controller
Message-ID: <20190115153546.GA8387@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 15 Jan 2019 15:35:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 15, 2019 at 01:33:41PM +0100, Lorenzo Bianconi wrote:
> Use linear fragment and not a single usb scatter-gather buffer in mt76u
> {tx,rx} datapath if the usb controller has sg data length constraints.
> Moreover add disable_usb_sg module parameter in order to explicitly
> disable scatter-gather. Some users have reported sg issues on AMD IOMMU

Not sure what is the problem , but this patch set look like a workaround
not fix. If this an issue with IOMMU and sg, seems there is something wrong
in sg page mappings eigher on mt76 dirver or IOMMU driver.

If things need to be fixed in mt76 I whould check if page mappings for
sg are correct. Or remove sg usage from mt76_usb completly, mt76 MMIO
version do not use sg for framgments, so most likely USB don't need it
as well.

Thanks
Stanislaw 
