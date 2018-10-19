Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B489ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:18:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD77D2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 08:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD77D2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbeJSQXJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 12:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726790AbeJSQXJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 12:23:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC56A30001E8;
        Fri, 19 Oct 2018 08:18:08 +0000 (UTC)
Received: from localhost (unknown [10.43.2.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99AAF61148;
        Fri, 19 Oct 2018 08:18:05 +0000 (UTC)
Date:   Fri, 19 Oct 2018 10:17:58 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH 1/2] mt76: mt76x0: reduce duplication in setting rf
 bandwidth parameters
Message-ID: <20181019081757.GA17167@redhat.com>
References: <20181018141645.31484-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181018141645.31484-1-nbd@nbd.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 19 Oct 2018 08:18:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 18, 2018 at 04:16:44PM +0200, Felix Fietkau wrote:
> Remove initval table with duplicated registers and driver specific flags
> in favor of a function that sets the registers directly

There are few problems with this patch: MT_RF(7, 77) is missing and
band is not taken directly from chandef but overwriteen in
'rf_band = mt76x0_frequency_plan[i].band' . But even after fixing that
I can not make MT7610U associate with AP on 5GHz. So please drop this
patch.

Thanks
Stanislaw

