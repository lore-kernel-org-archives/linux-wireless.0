Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41D1C07E85
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A800320892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 10:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ccp56iY/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LFaL5sks"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A800320892
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbeLGKyK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 05:54:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55042 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbeLGKyK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 05:54:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 594B760CEC; Fri,  7 Dec 2018 10:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544180049;
        bh=QOsLtI2Gq6oADUbtWKtmbiyE38xiPRniEhIvX/2ekeY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ccp56iY/+A7s0oWpQizP2JxqWks8liJ+ZE+sq9YETG/lZEyvmJSv3IsKvYmW5/nkF
         ujNtzskZ2ULvME7mJykyXiEmK/c2y8RPy+TwEjDY1Zc0GahOjN5AkSTeTp2r/jO0In
         sxwBIqQ2epEFzvvSSlHNuUTJwSdlTsO0ecVo72AI=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D727C60B1E;
        Fri,  7 Dec 2018 10:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544180048;
        bh=QOsLtI2Gq6oADUbtWKtmbiyE38xiPRniEhIvX/2ekeY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LFaL5sks5jHSvyBOokQi9f7yGZy38krdMZ3IZDakko3Py1ff6e2TmogelUJn8Zt3a
         +wzOAyew3mt0ayVGpiPoKWs2DJr9+iR3G3ZHE/Y/jM2x/yDgSA0e/dZ4HcnyYtQNOt
         JldcarThliHmHDquas0eXYstPdpwJEPfRmMfynsI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D727C60B1E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-11-30
References: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name>
        <87sgzc4ecv.fsf@kamboji.qca.qualcomm.com>
        <CAA2SeN+1-4tfKX=uW8u5RbOc4UrtdPx3yG4suMM+0koEKGuWPw@mail.gmail.com>
Date:   Fri, 07 Dec 2018 12:54:05 +0200
In-Reply-To: <CAA2SeN+1-4tfKX=uW8u5RbOc4UrtdPx3yG4suMM+0koEKGuWPw@mail.gmail.com>
        (Lorenzo Bianconi's message of "Wed, 5 Dec 2018 10:04:21 +0100")
Message-ID: <87bm5xehf6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi83@gmail.com> writes:

>> Felix Fietkau <nbd@nbd.name> writes:
>>
>> > here's my first pull request for 4.21
>> >
>> > - Felix
>> >
>> > The following changes since commit b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:
>> >
>> >   brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:33:10 +0200)
>> >
>> > are available in the Git repository at:
>> >
>> >   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-11-30
>> >
>> > for you to fetch changes up to e28487ea84a9c081c6d8d7da319427f7fcc32ff5:
>> >
>> >   mt76: replace sta_add/remove ops with common sta_state function
>> > (2018-11-30 12:30:37 +0100)
>> >
>> > ----------------------------------------------------------------
>> > first batch of mt76 patches for 4.21
>> >
>> > * use the same firmware for mt76x2e and mt76x2u
>> > * mt76x2 fixes
>> > * mt76x0 fixes
>> > * mt76x0e survey support
>> > * more unification between mt76x2 and mt76x0
>> > * mt76x0e AP mode support
>> > * mt76x0e DFS support
>> > * rework and fix tx status handling for mt76x0 and mt76x2
>> >
>> > ----------------------------------------------------------------
>>
>> I fast forwarded w-d-next to net-next and now there's a conflict. I did
>> a test merge in the pending branch, please double check:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?h=pending&id=e69caab09bf98d0d8b559d06887364cc0090097c
>>
>
> ack

Thanks for checking, I'll pull this soon.

-- 
Kalle Valo
