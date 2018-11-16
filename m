Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB33BC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:40:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 917592089D
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:40:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PDwpYhQv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Jmc/j9nG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 917592089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389345AbeKPSva (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:51:30 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbeKPSva (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 13:51:30 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0786B601D4; Fri, 16 Nov 2018 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542357609;
        bh=Kk8mXqTKhyOyz7nZuDBuQfUhNvRSyIeKO8Ar0KTg0DI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PDwpYhQvaTijI+wYSSikv5LyHSlnxZfHdeOEpLWDERiVaGgrdrg4epRtGJEMV1I1R
         RIysywKVCHdx5PgjoGtcL4Q++ldVQa6nv/JzT86ItQ4JpC4xy+VbWlP7UbKyNzMt7B
         loG7ZZhLNJYIj+6K6ItjTc8z/0NLSDomUpHRcCTE=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5798460764;
        Fri, 16 Nov 2018 08:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542357608;
        bh=Kk8mXqTKhyOyz7nZuDBuQfUhNvRSyIeKO8Ar0KTg0DI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Jmc/j9nGcin1u1gihAt4YQTpXBvkqZ0yXJWLkAJ1y5fg6PLYbExXZfd8+rBt3DHEI
         Xp9PP5eurwxrgeYWrg/9DEpM03z09K7DuePoGJIfqjiX7pWkG2KM6Xveag3K9Lb67/
         ScmeRhCpE6QEkTz93jo/n5nEZ+RYjOlZDPN/cxDA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5798460764
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, stable@vger.kernel.org
Subject: Re: [PATCH FIX] brcmfmac: fix reporting support for 160 MHz channels
References: <20181108150829.24842-1-zajec5@gmail.com>
        <87lg62cpno.fsf@codeaurora.org>
        <f1e1160ba35a42e12a0162629be23304@milecki.pl>
Date:   Fri, 16 Nov 2018 10:40:02 +0200
In-Reply-To: <f1e1160ba35a42e12a0162629be23304@milecki.pl> (=?utf-8?Q?=22R?=
 =?utf-8?Q?afa=C5=82_Mi=C5=82ecki=22's?=
        message of "Fri, 09 Nov 2018 21:10:56 +0100")
Message-ID: <87muq98lgd.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> writes:

> On 2018-11-09 15:05, Kalle Valo wrote:
>> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>>
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
>>> important to provide valid & complete info about supported bands for
>>> each channel. By default no support for 160 MHz should be assumed
>>> unless
>>> firmware reports it for a given channel later.
>>>
>>> This fixes info passed to the userspace. Without that change userspace
>>> could try to use invalid channel and fail to start an interface.
>>>
>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>> Cc: stable@vger.kernel.org
>>
>> Should this be queued to 4.20?
>
> That's my suggestion.

Ok, I'll queue this for 4.20.

--=20
Kalle Valo
