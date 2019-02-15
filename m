Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFBDC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E5D21924
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:37:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TERElBVx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TERElBVx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405602AbfBOKhs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:37:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfBOKhs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:37:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C0E3E608FB; Fri, 15 Feb 2019 10:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550227067;
        bh=PgLdY7E3Ej8d61A9JgdNDy+0ylYqZkNmh+3C/RoGgj4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TERElBVxi85QmDnIX9lt37bds6p6SByGbN1jbavnSBoVuvwPL8arrF+qTeONtAXO7
         4l63RVXz1QkDi06GvlMOPTDyshMsQqSJJhm5WPdN9P9VOjC9cHSdMq4EYQcNNOLesT
         qdTuDoK/4Zbt//qBFl5S4UweJCuquEy2PSkDN+Xk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AC6BF60588;
        Fri, 15 Feb 2019 10:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550227067;
        bh=PgLdY7E3Ej8d61A9JgdNDy+0ylYqZkNmh+3C/RoGgj4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TERElBVxi85QmDnIX9lt37bds6p6SByGbN1jbavnSBoVuvwPL8arrF+qTeONtAXO7
         4l63RVXz1QkDi06GvlMOPTDyshMsQqSJJhm5WPdN9P9VOjC9cHSdMq4EYQcNNOLesT
         qdTuDoK/4Zbt//qBFl5S4UweJCuquEy2PSkDN+Xk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AC6BF60588
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        \<brcm80211-dev-list.pdl\@broadcom.com\>\," 
        <brcm80211-dev-list@cypress.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code
References: <20190214125758.11943-1-zajec5@gmail.com>
        <20190215064345.11946-1-zajec5@gmail.com>
        <CACna6ry=mPipNw0u16Um6vij_DV5A-M0G++16WAAO3bZh_qjuA@mail.gmail.com>
Date:   Fri, 15 Feb 2019 12:37:43 +0200
In-Reply-To: <CACna6ry=mPipNw0u16Um6vij_DV5A-M0G++16WAAO3bZh_qjuA@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 15 Feb 2019
 11:10:35 +0100")
Message-ID: <877ee1z6a0.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On Fri, 15 Feb 2019 at 07:43, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> =
wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This recently added macro provides more meaningful error messages thanks
>> to identifying a specific wiphy. It's especially important on systems
>> with few cards supported by the same (brcmfmac) driver.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>> V2: Fix one line over 80 chars
>> V3: Pass drvr to the brcmf_fweh_call_event_handler() to make getting
>>     wiphy 100% reliable
>
> Kalle: please kindly hold on with this patch until we're done
> discussing bphy_err(). Mark it as deferred maybe?

Ok, I marked it as deferred. But please do remind me when it's ready to
be applied :)

--=20
Kalle Valo
