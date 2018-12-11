Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F618C5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23A082084E
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 16:16:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ta67NsVV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ogKCq+TS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23A082084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbeLKPrk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Dec 2018 10:47:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49822 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbeLKPrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Dec 2018 10:47:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CB89460CEC; Tue, 11 Dec 2018 15:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544543258;
        bh=EvezvSovCiG+rZTuzeY5DBw+q8iht9hDkIOc58MiDAA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ta67NsVVeuMUWyAkBgBSrOrjQyYbO9k8t+kGRLKcW70usvF1wCdTj4/g0LtPEqR/w
         1iug6gbnCmD73UPxYWe5v7JTTu/LhsdRluRBjv7Iwe14DqgnnyjM+ToRoHjrDf5prM
         2f0uAgrY7nut0+DeEC6OEjz4GAooxd+K8WZfmcsU=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DE2C160C5F;
        Tue, 11 Dec 2018 15:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544543256;
        bh=EvezvSovCiG+rZTuzeY5DBw+q8iht9hDkIOc58MiDAA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ogKCq+TS0VuxcBBubFEu7v6WcJV5pbi/kc0xQLWl53oqmJSCLAyRecneIXe3GRva7
         CMG3Z+1+8WHWQUiEJLu7qNW8bbhiElhpAtij3NpapO/DqEVmyI7dhrIIJocM1PyK4x
         R8TsOkN3QQb+BUTB+7Ru3GciyqIjkjFE71zt58U4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DE2C160C5F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Frank Lee <tiny.windzz@gmail.com>
Cc:     merez@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
References: <20181203132557.12269-1-tiny.windzz@gmail.com>
        <874lbug2fr.fsf@codeaurora.org>
        <CAEExFWtc2vRm7k2YpoNae+tOtnusSbVnapU-Wmo7kR-WfY+dzQ@mail.gmail.com>
        <CAEExFWtqn=-0bq6u_YWhn2YtwVL-eoEEUFkXSU-G5wc4UE=MXg@mail.gmail.com>
Date:   Tue, 11 Dec 2018 17:47:32 +0200
In-Reply-To: <CAEExFWtqn=-0bq6u_YWhn2YtwVL-eoEEUFkXSU-G5wc4UE=MXg@mail.gmail.com>
        (Frank Lee's message of "Tue, 11 Dec 2018 23:28:13 +0800")
Message-ID: <87ftv412wb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Frank Lee <tiny.windzz@gmail.com> writes:

> On Mon, Dec 3, 2018 at 9:36 PM Frank Lee <tiny.windzz@gmail.com> wrote:
>>
>> On Mon, Dec 3, 2018 at 9:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>> >
>> > Yangtao Li <tiny.windzz@gmail.com> writes:
>> >
>> > > Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>> > >
>> > > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
>> >
>> > The prefix for the title should be just "wil6210:", I can fix that.
> Hi Kalle:
> Why I can't find it in ath.git?

Because I haven't reviewed and applied it yet. BTW, you can reduce email
by checking the status from patchwork yourself:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
Kalle Valo
