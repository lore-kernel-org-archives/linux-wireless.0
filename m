Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C405EC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 929D720844
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 08:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbfBKIIQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:08:16 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:51251 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKIIQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 03:08:16 -0500
Received: from [192.168.178.52] ([109.104.49.86]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1Mzyi6-1hGyZs08Ri-00x4wR; Mon, 11 Feb 2019 09:08:06 +0100
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <20190210092943.GA2913@redhat.com>
 <307601671.418864.1549816737996@email.ionos.de>
 <CAJ0CqmXL_PXf0LuFOnshbYZb=j_KEHyfmV5wpHHW5HXcexhDJA@mail.gmail.com>
 <20190211075056.GB6292@redhat.com>
From:   Stefan Wahren <stefan.wahren@i2se.com>
Message-ID: <32eebaf4-f728-17a9-62e0-8c694ab83f86@i2se.com>
Date:   Mon, 11 Feb 2019 09:08:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190211075056.GB6292@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:+bO6gmr5+MMqVVH6lZMPFtQcX95DPqXtarcsLQ+BSjcSfqDPorF
 OedrFs8Y26OZ8gN0y84A4gZaVSopl5jlNo45MDAXPvbt07wrqZpqMI8qihgdf4ukbS+MTlj
 4It1wVeCt+tCclHpgNUZfxPWjWG2UzXg/Md51E7WC2icATPYs6mPhPzA9pPrAWDL57uqxGT
 47NLiSVVig3HKRCdYVJlw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:SMQ7VbXjdro=:4LmXY/Xkxs2VguzRZ63ps2
 h8lpzrffjPc1/5B2t/HMF7SVeFF3rwT8hnGWbP4+deB63hX0L+FK13pYUcm+eJNDUZibPEe0c
 DsTABp4TTURmkgQ74lPXvH1mm8EdHphWLuA5UBa73RgLgx/uL6bJ3BFzAqLv/dXTxqRB2YjNv
 cLdeNmnYlB2bLrEIZ+FO4cwnU4iCzQAhYh4vqv/vwWuEl8VZPpXHt0GBHkWE8NYq4yVAiJ62j
 Bj5bFQYYutyNgEEtHY4Af9xeWgNZSMs9GreW9blwj1YcTH5lwqFkNr7dDHAB9UUn+DS9x2wF9
 5RjAGG8DI/s7ix0fyLwOeNtm5UdLc0epL3ej2tGivx8t+07cueNxBOAuN+0H4ul2exCVErOQ2
 0zpj05UFslJs5kUI5lyxJavx+KZxibHom4qwoRrc87xDMY637w31aIm1l4wN4fKVg2TTkDLaO
 BHXMu3HbdYvK77P0mC3sENoCEcdk/g4Pbaaa5/M6cIwoEIMsKOunk3iuT+wtNSnh6srCnvsG/
 bGGlpgwkpIkeerH8mkAluSVYrERUrMJIlUFQm+HyWUX0ARy6vr0APqU4ledDbewMqkUHQTMxK
 aMeVthyNIhk8hji5ZYDEBLLwI4kxSr4TDdpKk1mDlXqdFXMH5TltPnm6bWJoFVXoAPO3VFArx
 1zJE8YziZRG8hBjEdP3fnfSm7NAXpJLsHQQbC5BMVh5fd2PdJ1LwYB25jEMPJ73AaL0tOula5
 moatbrt8rSu5EmvF8no1iQbrTPqkHmGM1qG8++4r4Fg7kpOtmRlJTOQF7YE=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Am 11.02.19 um 08:50 schrieb Stanislaw Gruszka:
> On Sun, Feb 10, 2019 at 05:52:30PM +0100, Lorenzo Bianconi wrote:
>> Anyway we will need to avoid SG since dwc_otg controller does not support it

this isn't correct. AFAIK the dwc2 host driver doesn't implement it,
which doesn't mean the controller does not support it.

Stefan

> What does it mean the dwc_otg does not support SG ? Please be more specific.
>
> Stanislaw

