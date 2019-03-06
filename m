Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C905C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 05:14:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2545D20663
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 05:14:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lsq9jMqb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TMQlkBrA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfCFFOL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 00:14:11 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfCFFOK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 00:14:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0665A60ACA; Wed,  6 Mar 2019 05:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551849250;
        bh=wvVKL1+LWl4/KpFTexJSnVNWlHQtDF48pANH0peXw5U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lsq9jMqbJv5kPNYlunOj+ezzwZhYZ8Lmr4jMGICUefGlQx4/VFNoZqTuhrP31fuhX
         FoEaaeykZcPklwQxee8+QR9iMjVFrM2vXnEyNVlCZVD/lX7hUHIOkSoXOiS/Np30Of
         vCTug6C0t8n+h5YiBRZQChIvPU8f52NKvxHgF2pU=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 551386030B;
        Wed,  6 Mar 2019 05:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551849249;
        bh=wvVKL1+LWl4/KpFTexJSnVNWlHQtDF48pANH0peXw5U=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TMQlkBrA3tOT2zDa6KnTGentj2Y7aa8WpKUr41qfIJtW/edAamHImLCdLhYH1ujJT
         3wmHt1b7Y1Co1urZtC3JDuYgJtJ8UAnwHdUvtwxX3D+OrHv08tJDKwddZHeiDhqiab
         qF5tnRiXwKMKolvwfbgyldWKEOEnq6y9Q1cx+oNc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 551386030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>
Subject: Re: mediatek: duplicate usb devices
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
Date:   Wed, 06 Mar 2019 07:14:05 +0200
In-Reply-To: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com> (Xose Vazquez
        Perez's message of "Tue, 5 Mar 2019 19:33:51 +0100")
Message-ID: <87o96ozisi.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ jakub

Xose Vazquez Perez <xose.vazquez@gmail.com> writes:

> There a three duplicate devices at:

[...]

> mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },

This is not good, two drivers should not be competing about the same
device. So which driver should support this device?

-- 
Kalle Valo
