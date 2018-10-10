Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FF3AC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 054752086D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrLeXTMg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 054752086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbeJJT0r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:26:47 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36386 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJT0q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 15:26:46 -0400
Received: by mail-io1-f67.google.com with SMTP id p4-v6so3659588iom.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2018 05:04:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hCoP/jWlzl1uzK8NbTDyjJmOP8POm+OXqf2fzp0sb0I=;
        b=UrLeXTMg+9vMGCyQiNK3oNBKzFoecTGhBjrTKwyfWiaOObSHwooCTFYGzvBU9L9pBv
         EYTc7C21+o1tTRDEtxjV07y0lnA5Uqn6ZNdSumiPS7gwUcat4jQt2KFC6FOJRNqPx13N
         yHgfRRnPk8wZtwkmf76CYqUhqtFoYM/+bhBEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=hCoP/jWlzl1uzK8NbTDyjJmOP8POm+OXqf2fzp0sb0I=;
        b=X5T7HltzeLHyiTOZDDCmWfP/ypUv2wnl1JaDuSn4zhwIbrF2m3NERauB6MQgpFUE8H
         3//FvVynwIMh5ATQcZKeGQoh9tTn3JEtM0iWwn7DO77Odvf0sNfgy/ke1quFgnCtDXal
         qVuniEA1ltgLuS8wBXiK5bO03eVnT1K/8YsxMjLkQPKkR1kWBjpXpWoMfDSIBmfKE7Ev
         NwRFRJ1LS5dGBn3AyYdseJXVuqdf1zLaLLYDKW98nvAkthoqI7IIBXpsD1N7g8An/mxW
         P7+oaxfDg61d6WR0j71HmmOHmwufqVS46zbOxbby+oPyaG8iU5zEz/2gw+SlVUc343Gq
         IE+Q==
X-Gm-Message-State: ABuFfogCKCHUBrGdsS7nlzRBlP4ccTlF99a6+Kb/fXbl+zO76vcS35Xj
        9zpHOLMRVDtyu14rN77sSWrN+AtcgDhnSESiEPWyMA==
X-Google-Smtp-Source: ACcGV63rfu3l9q9EAdCiY12iL7jIqbx7m1crr1TOBfPhOB93xD4XBXYE/aOtY0jlX33noviAaTgMuoKN1uogmAkhZg8=
X-Received: by 2002:a6b:8fcb:: with SMTP id r194-v6mr11281346iod.266.1539173095352;
 Wed, 10 Oct 2018 05:04:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:3941:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 05:04:14
 -0700 (PDT)
In-Reply-To: <87efczqm1t.fsf@purkki.adurom.net>
References: <20181008200357.10819-1-daniel@zonque.org> <CAPDyKFoo-gnjUg9Khc3EPm=cvHgyR_VNW8xgjP1Tea7wjRfvSw@mail.gmail.com>
 <87efczqm1t.fsf@purkki.adurom.net>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Wed, 10 Oct 2018 14:04:14 +0200
Message-ID: <CAPDyKFrrnbU98sr2UtM_fPc9P66Ft9uHU30bhbQduQR0vNCfTA@mail.gmail.com>
Subject: Re: [PATCH] libertas: call into generic suspend code before turning
 off power
To:     Kalle Valo <kvalo@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Cc:     Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 9 October 2018 at 15:36, Kalle Valo <kvalo@codeaurora.org> wrote:
> Ulf Hansson <ulf.hansson@linaro.org> writes:
>
>> On 8 October 2018 at 22:03, Daniel Mack <daniel@zonque.org> wrote:
>>> When powering down a SDIO connected card during suspend, make sure to call
>>> into the generic lbs_suspend() function before pulling the plug. This will
>>> make sure the card is successfully deregistered from the system to avoid
>>> communication to the card starving out.
>>>
>>> Fixes: 7444a8092906 ("libertas: fix suspend and resume for SDIO connected cards")
>>> Signed-off-by: Daniel Mack <daniel@zonque.org>
>>
>> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> BTW, if you need this to reach 4.19 I have already queued some other
>> mmc fixes so I can take this as well, if it helps. I need and ack of
>> course.
>
> I'm not planning to send anything to 4.19 anymore and this is so simple
> that hopefully it cause any conflicts with -next patches, so feel free
> to do that:
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>

Applied for fixes, thanks!

Kind regards
Uffe
