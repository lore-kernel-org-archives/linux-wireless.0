Return-Path: <SRS0=sWjF=YP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108A9CA9EA0
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Oct 2019 07:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8FA621783
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Oct 2019 07:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gk8jo0Hc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BNlzXd0Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbfJVHid (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Oct 2019 03:38:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:46254 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfJVHid (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Oct 2019 03:38:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 37225607B5; Tue, 22 Oct 2019 07:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571729912;
        bh=nBSjRvPIQ1HVHWIjS06X9KHSdNmT6WKvBQzWYHkvrg0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gk8jo0Hcl+a6XbEqUpQvPVgDx0FGwyvz7VgbxEaj7B1ZPit+bye6fMA+BMhzowQhV
         PsML6bGD0RosNuk/19ZWHOfuKCkkD1FV878ZW28XEizu6zxEfELCxtt6fbGglEUOZ9
         30+CbeQS8UbTmdCKQrZEg/S8FipO3JuEVCnTrH9Q=
Received: from tynnyri.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 078256039C;
        Tue, 22 Oct 2019 07:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571729911;
        bh=nBSjRvPIQ1HVHWIjS06X9KHSdNmT6WKvBQzWYHkvrg0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BNlzXd0Z7ID/bXNP9cb0ThOjflPM0Q6ynD6bBAHLK2Zz0Ut2q3Vfb9cNDzMppvRSg
         bXS+DhoMqZDG1tKJCjtv8TdtuutIHyWWHZxbgFGPA/U0A00TZcD949J26NrgebBTMH
         iH+1pkp4DgmVHq5eab3Yw1Fds50C/D9Bz0Cf6Y9k=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 078256039C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ryan Adolf <ryanadolf123@gmail.com>
Cc:     Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org
Subject: Re: Fwd: iw package typo in help command output
References: <CADh-Cm=umBWCkz41-e0-PDnDrbpfQi_PRdT--SePmQLCqj5rwg@mail.gmail.com>
        <CADh-CmnrWe_hrdfs3RqL0mF4ipAxthUgE3=eBSvaiudbEtsQvw@mail.gmail.com>
        <0f33cba3dd5fdcc4697c26e97e8f265c1bb9958c.camel@coelho.fi>
        <CADh-Cm=bG2wV6Ccy3ATx3g=dsoXa6KAvxwBJ+pPxMSscaQ0AXA@mail.gmail.com>
Date:   Tue, 22 Oct 2019 10:38:28 +0300
In-Reply-To: <CADh-Cm=bG2wV6Ccy3ATx3g=dsoXa6KAvxwBJ+pPxMSscaQ0AXA@mail.gmail.com>
        (Ryan Adolf's message of "Tue, 22 Oct 2019 00:21:26 -0700")
Message-ID: <877e4xfcwb.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ryan Adolf <ryanadolf123@gmail.com> writes:

> The patch is attached.
> There's only one modified line in it: correcting the typo of timstamp
> --> timestamp.

The patches need to be submitted in certain format. Please carefully
read the documentation (a link in my signature below) how to submit
patches.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
