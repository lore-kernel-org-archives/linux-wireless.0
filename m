Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF237C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3AB2148E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 07:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GMFmukCE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TKBDBbB8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725788AbfA2HIp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 02:08:45 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56612 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfA2HIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 02:08:44 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 041BD60851; Tue, 29 Jan 2019 07:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548745724;
        bh=fCRQTrnGySVjRl21YZmCQxpMngsZBRxnqax5UmX6dIk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GMFmukCEULu+COX/67zu8sX0l+qNP2yi4u8Vn7sc5eDldmNIO8c+lC3iabWVguKFY
         nvLILKt6ekAM/bIdEh4TtwPyN/WGWFUb6Nk5tLEOIjgVz+6mAl4W71+VIg1ZuCaMTs
         tRedN2ZpmtQOAH0em2Q7M3ePa0c9KtOMqWVVKLcU=
Received: from x230.qca.qualcomm.com (87-93-85-88.bb.dnainternet.fi [87.93.85.88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7BDD16030D;
        Tue, 29 Jan 2019 07:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548745723;
        bh=fCRQTrnGySVjRl21YZmCQxpMngsZBRxnqax5UmX6dIk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TKBDBbB8lWcHHZaknUA3vjqVHmhzg3y+TxdlT7yNrCkMbgyz8cuugkFlsOkdBvbwv
         CgDrXu1+sFlHEXhxjBbRs1aR+eu58zSimEdhDY2xF2xNiDXLaA6yy34W46a1uf0BlX
         AtEqqL3OcPDOx0SIpUma50xclvwkrDAmFoJfb4Go=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7BDD16030D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com
Subject: Re: [PATCH wireless-drivers] mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info
References: <cover.1548587542.git.lorenzo.bianconi@redhat.com>
        <44789d3d0dee6e2e0bb7d75f755927d415aa56d4.1548587542.git.lorenzo.bianconi@redhat.com>
        <87tvhstujr.fsf@purkki.adurom.net>
        <20190128205002.GA2165@localhost.localdomain>
Date:   Tue, 29 Jan 2019 09:08:39 +0200
In-Reply-To: <20190128205002.GA2165@localhost.localdomain> (Lorenzo Bianconi's
        message of "Mon, 28 Jan 2019 21:50:03 +0100")
Message-ID: <87bm40ym88.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
>> 
>> > Report correct eeprom per channel power value.
>> > Fix chan_vs_power map in mt76x0_get_power_info routine
>> >
>> > Fixes: f2a2e819d672 ("mt76x0: remove eeprom dependency from mt76x0_get_power_info")
>> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
>> 
>> So what's the actual bug this fixes? The commit log is not really clear
>> on that. Wondering because you marked this for wireless-drivers.
>
> Hi Kalle,
>
> You are right, I have been not so clear in the commit log.
> Offsets in chan_map were wrong since mt76x02_eeprom_get() reads at even addresses.
> Moreover 'if' condition in the for loop was wrong (chan->hw_value and
> chan_map[i].chan were swapped)

But how does this affect from user's point of view? I mean what feature
is broken and how does this fix that?

-- 
Kalle Valo
