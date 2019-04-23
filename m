Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF1BC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3855120685
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 08:49:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bc//IqkU";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RfCtHm/Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfDWIt6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 04:49:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWIt6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 04:49:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 336BC615E8; Tue, 23 Apr 2019 08:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556009397;
        bh=NbSDMqi7hIQ95VLwmru5G3ujsOnrkYCVOKDjytvh67g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Bc//IqkUlsqDAzj+v4tsEuVmuM+X965L5jGQxJEB1V57MrP1wat+Txx721feELNO/
         IDc3IOmIOtziyMawRhCBtuHENZQGyeOUP4t/gp1HFv/hQpTgmB9xWB6Wg5rVDDRDGw
         46q5YJ+v1U1Co8bF3D5HgaaK3YQV7xCXM9GMWLd8=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EF183602F3;
        Tue, 23 Apr 2019 08:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556009396;
        bh=NbSDMqi7hIQ95VLwmru5G3ujsOnrkYCVOKDjytvh67g=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RfCtHm/Zd0dBb8YIu3iUKbaOsRsoT/k3GYr5QEulSIoTOjH8I6DwnJluuL/x/0N/R
         oTIblHp3HdNswfCp0TxPoaiJmpQnvgYf4QPbPBKYLYrlckBeSLkG2sbEKp2ZQBAjqf
         UYke5TVvc0agvdMGzHHBLKIqJDXmR/sOyK1o7aJU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EF183602F3
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH 00/21] RT3883 support from OpenWrt
References: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
Date:   Tue, 23 Apr 2019 11:49:51 +0300
In-Reply-To: <1554809828-13500-1-git-send-email-sgruszka@redhat.com>
        (Stanislaw Gruszka's message of "Tue, 9 Apr 2019 13:36:47 +0200")
Message-ID: <875zr5xg0g.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> Upstream RT3883 support patches cared by openwrt for quite
> a while now.
>
> Patches do not contain the changelog and generate this checkpatch.pl
> warning:
>
> WARNING: Missing commit description - Add an appropriate one

No empty commit logs, please. They are very annoying.

> but I do not see much sense for fixing that.
>
> Gabor Juhos (21):
>   rt2x00: rt2800lib: enable support for RT3883
>   rt2x00: rt2800lib: add rf_vals for RF3853
>   rt2x00: rt2800lib: enable VCO calibration for RF3853
>   rt2x00: rt2800lib: add channel configuration function for RF3853
>   rt2x00: rt2800lib: enable RF3853 support
>   rt2x00: rt2800lib: add MAC register initialization for RT3883
>   rt2x00: rt2800soc: fix rt2800soc_disable_radio for RT3883
>   rt2x00: rt2800lib: add BBP register initialization for RT3883
>   rt2x00: rt2800lib: add RFCSR initialization for RT3883
>   rt2x00: rt2800lib: use the extended EEPROM map for RT3883
>   rt2x00: rt2800lib: force rf type to RF3853 on RT3883
>   rt2x00: rt2800lib: add channel configuration code for RT3883
>   rt2x00: rt2800lib: fix txpower_to_dev function for RT3883
>   rt2x00: rt2800lib: use correct txpower calculation function for RT3883
>   rt2x00: rt2800lib: hardcode txmixer gain values to zero for RT3883
>   rt2x00: rt2800lib: use correct [RT]XWI size for RT3883
>   rt2x00: rt2800lib: fix antenna configuration for RT3883
>   rt2x00: rt2800lib: fix LNA gain configuration for RT3883
>   rt2x00: rt2800lib: fix VGC setup for RT3883
>   rt2x00: rt2800lib: fix EEPROM LNA validation for RT3883
>   rt2x00: rt2800lib: fix txpower compensation for RT3883
>
>  drivers/net/wireless/ralink/rt2x00/rt2800.h    |  19 +-
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 598 ++++++++++++++++++++++++-
>  drivers/net/wireless/ralink/rt2x00/rt2800soc.c |   9 +-
>  3 files changed, 607 insertions(+), 19 deletions(-)

I'm not seeing the point of of all these small patches, they are all
about adding RT3883 support, right? I think it it would be easier to
combine all these to one bigger patch and write a proper commit log
explaining the background and what has been tested etc. It wouldn't be
that big patch anyway.

-- 
Kalle Valo
