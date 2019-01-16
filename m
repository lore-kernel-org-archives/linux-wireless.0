Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180CEC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D7320657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LJIBe+7k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="En0N+59r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387586AbfAPQfz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:35:55 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAPQfz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:35:55 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 265F560591; Wed, 16 Jan 2019 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547656555;
        bh=24/8YKg6gYZzar1IOaZHd4HOlzzt2uZ/UV/dHh4fkQs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LJIBe+7k27JlyqTlf6/CHJ0Wp4dqq2lZuWpmZGyRn7EA2k+cwfGg/Uc2cDDtkqN5/
         0ELaP/MBkVylzAQ5LE0SdYlesEF6EXMtKA29s2o0IUnAJufxwmSUUb+afljg/BwePz
         lunhfKoI7GMfBbfT4jn6obYbDYU8HYjya8kG1cC0=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9A89E6021A;
        Wed, 16 Jan 2019 16:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547656554;
        bh=24/8YKg6gYZzar1IOaZHd4HOlzzt2uZ/UV/dHh4fkQs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=En0N+59rmc2EugnhsqlVE0vdVWzTSS8jn82Qb+5grBMWehhdWN6ZdnlbYF1EALoVU
         UNO1LZeRLr+Molr75i65CvbUotjn/iIe1nM27RnLBTl2zFp3XTJtttgeeEhUiFTa0f
         Rdiyv5lFToDcWlQE7lIh8VXWZxgWac09BZAGVjL8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9A89E6021A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?= 
        <rafal@milecki.pl>, linux-wireless@vger.kernel.org,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
References: <20190108232646.GV11171@n2100.armlinux.org.uk>
        <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
        <20190109105622.GY11171@n2100.armlinux.org.uk>
        <20190111141543.GA2392@n2100.armlinux.org.uk>
        <9486d79d-ad48-1112-7100-65f9f9e5fc06@broadcom.com>
        <20190116001204.cjpvbr3okha4fhz7@e5254000004ec.dyn.armlinux.org.uk>
        <c33521df-9b75-49c8-1bfa-67ff6e7a8b74@broadcom.com>
        <20190116125149.mm3vviqgbfovtxak@e5254000004ec.dyn.armlinux.org.uk>
        <c4a0053e-5312-1b1f-68c9-ef58642698fa@broadcom.com>
        <20190116135643.bomtxuwljjcusxxf@e5254000004ec.dyn.armlinux.org.uk>
        <20190116141128.rwl3bzbu7clzomn5@e5254000004ec.dyn.armlinux.org.uk>
        <CAF7Mx6oG0-X=OyrpgYiM-Lt6p+nDpO7X5CWbdaoSieBcc6=57w@mail.gmail.com>
Date:   Wed, 16 Jan 2019 18:35:50 +0200
In-Reply-To: <CAF7Mx6oG0-X=OyrpgYiM-Lt6p+nDpO7X5CWbdaoSieBcc6=57w@mail.gmail.com>
        (Arend Van Spriel's message of "Wed, 16 Jan 2019 16:39:23 +0100")
Message-ID: <87ef9c4l21.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> I should have known better and used git-send-email. I will resend it
> later tonight.

BTW, this was again sent using HTML :) In case Russell filters out HTML
mails I'll act as a messenger.

-- 
Kalle Valo
