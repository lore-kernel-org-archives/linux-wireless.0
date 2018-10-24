Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449DFC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6312064A
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:58:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bIuMNaTn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VpWbratJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC6312064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbeJXV0X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 17:26:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54356 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbeJXV0X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 17:26:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D42C60C48; Wed, 24 Oct 2018 12:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540385902;
        bh=j4n6cPF00OmrpEQweEt3Vomq1BGqDVGepMaH+ly5Sus=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bIuMNaTnHxd21s4fcpR8c6mqlHpwz3+WUdeqOwPDCk9IIGkRBNNoWkNy1y3jHOp67
         wUBiFZipnlNV3lCUhkwRBOASKsIF0I6tRw9Ao5Cs2k0XrJnyz5Z+V7pufMOE9GalRd
         VdqRkvglwdQKTrxdzFdioBOLPrvNbmNIMpu63/Jw=
Received: from x230.qca.qualcomm.com (37-33-153-140.bb.dnainternet.fi [37.33.153.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 39B5E6028B;
        Wed, 24 Oct 2018 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540385901;
        bh=j4n6cPF00OmrpEQweEt3Vomq1BGqDVGepMaH+ly5Sus=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VpWbratJr6I6FBk5nK2LA/oY/GkhAtlegTWwjtFipmyXofrLf6IUSROZOGUWqSlZF
         PWPMsUVcx2PzVl9z9QDUJwFcDC9/C9iUruYQurcLOp3LfeQPU+g6IzvFK3hDf11eGi
         a5upYy2dH5CTcIvI3HRxxlD60R0srqP+fpen11pU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 39B5E6028B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix a locking bug in ath9k_add_interface()
References: <20181019200842.7qclbjs547sm7mbn@kili.mountain>
        <87tvlbuc3n.fsf@codeaurora.org>
        <20181024125630.pqs6uae3owjvfdhr@mwanda>
Date:   Wed, 24 Oct 2018 15:58:17 +0300
In-Reply-To: <20181024125630.pqs6uae3owjvfdhr@mwanda> (Dan Carpenter's message
        of "Wed, 24 Oct 2018 15:56:30 +0300")
Message-ID: <87woq7qz6e.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:

> On Wed, Oct 24, 2018 at 08:50:52AM +0300, Kalle Valo wrote:
>> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> 
>> > We tried to revert commit d9c52fd17cb4 ("ath9k: fix tx99 with monitor
>> > mode interface") but accidentally missed part of the locking change.
>> >
>> > The lock has to be held earlier so that we're holding it when we do
>> > "sc->tx99_vif = vif;" and also there in the current code there is a
>> > stray unlock before we have taken the lock.
>> >
>> > Fixes: 6df0580be8bc ("ath9k: add back support for using active
>> > monitor interfaces for tx99")
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> 
>> commit 6df0580be8bc is on it's way to v4.20 so should I also queue this
>> to v4.20?
>
> Yeah.  Obviously this is a static checker thing and I haven't tested it.
>
> I don't know if add_interface() is ever called in parallel, but I can
> imagine that it might be.  In that case the race condition is something
> that would affect real life.
>
> Anyway, it's a small obvious fix.

Ok, I'll then queue this to v4.20. But I would appreciate if others
could test or review this.

-- 
Kalle Valo
