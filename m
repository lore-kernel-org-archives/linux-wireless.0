Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348F1C0044C
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF1DF20657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kXMPRIpx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kXMPRIpx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF1DF20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbeJ2Xp2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:45:28 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbeJ2Xp1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:45:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A8EB160159; Mon, 29 Oct 2018 14:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824988;
        bh=olEIAigMDp+Mb21rADtHL8YJdBYUxh1qaS7HZgQkQgU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kXMPRIpxyhyCwCk/p8DkQadpUt6+5Ycd7zxK3mVTnjDjtiKPe5Lnj7NRVxedD5J+P
         O0tOTyYq9F7TMjRZmxOuAYvZ1iYdEP8sYCOR0A1qcw+40X4fnRBTBPamt6qo9MXrWZ
         SXohHkRCCQXfDShpbeuxDm5wlhBD7eQofe1brpPk=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2BAAA6019F;
        Mon, 29 Oct 2018 14:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824988;
        bh=olEIAigMDp+Mb21rADtHL8YJdBYUxh1qaS7HZgQkQgU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kXMPRIpxyhyCwCk/p8DkQadpUt6+5Ycd7zxK3mVTnjDjtiKPe5Lnj7NRVxedD5J+P
         O0tOTyYq9F7TMjRZmxOuAYvZ1iYdEP8sYCOR0A1qcw+40X4fnRBTBPamt6qo9MXrWZ
         SXohHkRCCQXfDShpbeuxDm5wlhBD7eQofe1brpPk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2BAAA6019F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: add support for Topaz chipsets
In-Reply-To: <20181015194636.7ydshvuo2ykqyp3d@bars> (Sergey Matyukevich's
        message of "Mon, 15 Oct 2018 19:46:44 +0000")
References: <20181008095551.18651-1-sergey.matyukevich.os@quantenna.com>
        <20181008095551.18651-6-sergey.matyukevich.os@quantenna.com>
        <87murioxft.fsf@purkki.adurom.net>
        <20181015194636.7ydshvuo2ykqyp3d@bars>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
Date:   Mon, 29 Oct 2018 16:56:25 +0200
Message-ID: <87k1m0er8m.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > +config QTNFMAC_TOPAZ_PCIE
>> > +     tristate "Quantenna QSR1000/QSR2000 PCIe support"
>> > +     default n
>> > +     depends on PCI && CFG80211
>> > +     select QTNFMAC
>> > +     select FW_LOADER
>> > +     select CRC32
>> > +     help
>> > +       This option adds support for wireless adapters based on Quantenna
>> > +       802.11ac QSR1000/QSR2000 (aka Topaz) FullMAC chipset
>> > +       running over PCIe.
>> > +
>> > +       If you choose to build it as a module, two modules will be built:
>> > +       qtnfmac.ko and qtnfmac_pcie.ko.
>
>> I'm not really fond of adding a Kconfig option for every supported
>> hardware version unless there are very good reasons (memory savings
>> etc). So is this really needed?
>
> Yes, the idea was to save some memory building pcie backend for
> the requested chip family only.
>  
>> A much better approach would be to have a generic QTNFMAC_PCIE option
>> which can be used to include or exclude all PCI code.
>
> Ok, sounds reasonable. Three Kconfig options for the single qtnfmac_pcie
> module is way too much. We will drop chipset specific Kconfig knobs in
> v2, keeping single Kconfig option for qtnfmac_pcie backend as a whole.

Great, thanks.

-- 
Kalle Valo
