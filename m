Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F577C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:56:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17EE4204FD
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 12:56:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17EE4204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbeKBWD2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 18:03:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbeKBWD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 18:03:28 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A812D3082132;
        Fri,  2 Nov 2018 12:56:23 +0000 (UTC)
Received: from localhost (ovpn-204-43.brq.redhat.com [10.40.204.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08FEE60921;
        Fri,  2 Nov 2018 12:56:20 +0000 (UTC)
Date:   Fri, 2 Nov 2018 13:56:18 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] mt76: remove wait argument from mt76x02_mcu_calibrate
Message-ID: <20181102125613.GA5247@redhat.com>
References: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
 <1540555229-28582-3-git-send-email-sgruszka@redhat.com>
 <962e3461-a7cc-14df-bae5-0de2201e90b3@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962e3461-a7cc-14df-bae5-0de2201e90b3@nbd.name>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 02 Nov 2018 12:56:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Nov 01, 2018 at 06:29:01PM +0100, Felix Fietkau wrote:
> On 2018-10-26 14:00, Stanislaw Gruszka wrote:
> > We always wait for CMD_CALIBRATION_OP mcu message, but wait argument is used
> > for do additioanl MT_MCU_COM_REG0 register operations, which are needed
> > for MMIO devices and we can use mt76_is_mmio() check instead of wait argument.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> With this commit, I hit the WARN_ON on polling the MT_MCU_COM_REG0
> register on mt76x0e. It seems to me that this register polling should be
> moved out of mt76x02 and into a mt76x2 wrapper function.

I think it would be better to just do mt76x2e check like this:

        bool is_mt76x2e = mt76_is_mmio(dev) && is_mt76x2(dev);

        if (is_mt76x2e)
                mt76_rmw(dev, MT_MCU_COM_REG0, BIT(31), 0);

Then we will not have sparate calibration functions for mt76x2e and
mt76x2u, so code could be easier shared between those.

Thanks
Stanislaw



