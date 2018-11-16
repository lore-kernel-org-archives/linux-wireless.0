Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7003BC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34A96208A3
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:54:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HWQhklZk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MiaOPzlM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 34A96208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389324AbeKPTGF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:06:05 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbeKPTGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 14:06:05 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F52460591; Fri, 16 Nov 2018 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542358482;
        bh=Ujk/FXE+8DOQQvtMf9xPaUsKS8I62iOuaeLZGq6JSNs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HWQhklZk0Bh3MiGn0FL7SoqdNXk3FLs2QTDE/hqthHZVKwzzSCRBq5lDc95ZvNLOn
         XFVxrUvDuUZlG1C3/HzF5ZY+dL8Duh5jGh5rt8UGZmD3d9GNlD0pWwe8hmuGMxgoqY
         A9pX3LCUGbLRZl4RWUKSod8URNWwBVyFMiyYJ2Uo=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2398601D4;
        Fri, 16 Nov 2018 08:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542358481;
        bh=Ujk/FXE+8DOQQvtMf9xPaUsKS8I62iOuaeLZGq6JSNs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=MiaOPzlMFAe4PTBdy14aZaG1ey0QznQZOadsSLS3q1DJ75sI9lD9Xx2ZbtZ2sxQYn
         wH2SD1qXqqeLciuOzWXMWTtgeYMTHfbrqXw/DVG/a3MvSevfYQGvZmVCkr9HoUoSSC
         nKIG2LmLJoqwLLMZGK8aBoUwIpjH0TpVoTmmwdHo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2398601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org
Subject: Re: wiki: tree labels in patches
References: <20181108150829.24842-1-zajec5@gmail.com>
        <87lg62cpno.fsf@codeaurora.org>
        <f1e1160ba35a42e12a0162629be23304@milecki.pl>
        <87in0x8l4t.fsf_-_@codeaurora.org>
        <c66fa62a88f1d99dc35019c5e7d00b062c6b1785.camel@sipsolutions.net>
Date:   Fri, 16 Nov 2018 10:54:38 +0200
In-Reply-To: <c66fa62a88f1d99dc35019c5e7d00b062c6b1785.camel@sipsolutions.net>
        (Johannes Berg's message of "Fri, 16 Nov 2018 09:49:26 +0100")
Message-ID: <87efbl8ks1.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2018-11-16 at 10:46 +0200, Kalle Valo wrote:
>
>> Yes, I do see your FIX tag in patchwork:
>> 
>>  [ 31] [FIX] brcmfmac: fix reporting support for 160 MHz channels   2018-11-08 
>> 
>> But "FIX" is a bit ambigous as not all fixes not go to wireless-drivers,
>> they can also go to wireless-drivers-next. So I prefer using the release
>> number (or name of the tree) like this:
>> 
>> [PATCH 4.20] brcmfmac: fix reporting support for 160 MHz channels
>
> FWIW, davem/networking just use 
>
> [PATCH net]
> [PATCH net-next]
>
> which puts a bit more effort on the submitter but is a bit easier on the
> maintainer I suppose. Also, not really a problem here, but it would help
> disambiguate different trees on the same mailing list. I don't really
> mind either way.

Actually I already added that to the wiki[1] but made it optional just
bacause it's harder for patch submitters who are not so familiar with
our tree structure. But yes, I also like using the full tree name as the
label, even more so as it would help me to automatically assign patches
to correct maintainers in patchwork.

[1] https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#tree_labels

-- 
Kalle Valo
