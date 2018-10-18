Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFB6C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11602152C
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 09:53:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D11602152C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbeJRRxv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 13:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbeJRRxv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 13:53:51 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B263730833AF;
        Thu, 18 Oct 2018 09:53:38 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 577195E7C6;
        Thu, 18 Oct 2018 09:53:36 +0000 (UTC)
Date:   Thu, 18 Oct 2018 11:53:34 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: antenna select corrections
Message-ID: <20181018095333.GA6495@redhat.com>
References: <1539850059-11886-1-git-send-email-sgruszka@redhat.com>
 <20181018091335.GB4938@localhost.localdomain>
 <20181018092146.GC2190@redhat.com>
 <20181018092819.GC4938@localhost.localdomain>
 <20181018094055.GA6294@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018094055.GA6294@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 18 Oct 2018 09:53:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 11:40:56AM +0200, Stanislaw Gruszka wrote:
> On GPL realeased driver for MT7610U ( mt7610u_wifi_sta_v3002_dpo_2013091 )
> it's like this:
> 
>         CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2 | BIT1);

<snip>
> Does your SDK do something diffrent ?
Ok I can see:

	CoexCfg3 &= ~(BIT5 | BIT4 | BIT3 | BIT2);

in
https://github.com/i80s/mtk-sources 
which is newer version of the driver, so preasumely BIT1
should not be cleared. Will fix that in the patch.

Thanks
Stanislaw
