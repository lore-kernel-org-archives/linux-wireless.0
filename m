Return-Path: <SRS0=FBzj=5M=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AEE7C43331
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Mar 2020 15:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2824220578
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Mar 2020 15:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgC0Pcf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:32:35 -0400
Received: from mx.sdf.org ([205.166.94.20]:56080 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbgC0Pcf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Mar 2020 11:32:35 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02RFWNXL004912
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Fri, 27 Mar 2020 15:32:23 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02RFWMrD014027;
        Fri, 27 Mar 2020 15:32:22 GMT
Date:   Fri, 27 Mar 2020 15:32:22 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Ajay.Kathat@microchip.com
Cc:     gregkh@linuxfoundation.org, Adham.Abozaeid@microchip.com,
        linux-wireless@vger.kernel.org, lkml@sdf.org
Subject: Re: [PATCH v2] wilc1000: Use crc7 in lib/ rather than a private copy
Message-ID: <20200327153222.GA19653@SDF.ORG>
References: <20200326192836.GB15115@SDF.ORG>
 <820cc7dd-b19e-fdb4-feec-c8595e6029ce@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <820cc7dd-b19e-fdb4-feec-c8595e6029ce@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 27, 2020 at 07:03:28AM +0000, Ajay.Kathat@microchip.com wrote:
> Currently, wilc1000 driver is present in staging so while submitting
> patches please mark 'devel@driverdev.osuosl.org' mail-id also.

Aah, my error was to *only* check the staging/wilc1000/ entry in
MAINTAINERS, and not include the overall staging/ entries, which
scripts/get_maintainer.pl pulled out.

Sorry about that.
