Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41131C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 040112089D
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 08:47:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nCaqP2cZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TPhLAefR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 040112089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbeKPS6Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 13:58:24 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37726 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbeKPS6Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 13:58:24 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0D89060767; Fri, 16 Nov 2018 08:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542358022;
        bh=5AE3FyDpfuNs2licYqCFaT2S+KUcLmfaT4N6Tz6dn8c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nCaqP2cZeMeP4+dxE1JE5jVX7SB3q+cowYt/PCJ4djx6+9EJFlKhJspBpWtZkmuIq
         plbZj8rIY4g3u4t59bHGcVcMNlFIpbKpca0GJvGt+d8vm07xTLztN2dtcxfrOkZ+aN
         +vWrmhTkmv64oUQUHoj229dZCCtDoyybh7bcwK8I=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D6809601D4;
        Fri, 16 Nov 2018 08:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542358021;
        bh=5AE3FyDpfuNs2licYqCFaT2S+KUcLmfaT4N6Tz6dn8c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=TPhLAefRt3TSVNtSpGpPqTsg4RRuRRBU0flUbZH3A2JJ4DiNr5PObXSvHinCTIUBH
         9Ww1sJrU+nJ3tMGezFaxPG90lbfwSoKGL0/BRIatHS+EJPdWHQD3q/BlLaIhgdVA7V
         8fNEtigsVDn6msRwyX9hPr/5NlKfjVtR7e/wdJuQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D6809601D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     linux-wireless@vger.kernel.org
Subject: wiki: tree labels in patches
References: <20181108150829.24842-1-zajec5@gmail.com>
        <87lg62cpno.fsf@codeaurora.org>
        <f1e1160ba35a42e12a0162629be23304@milecki.pl>
Date:   Fri, 16 Nov 2018 10:46:58 +0200
In-Reply-To: <f1e1160ba35a42e12a0162629be23304@milecki.pl> (=?utf-8?Q?=22R?=
 =?utf-8?Q?afa=C5=82_Mi=C5=82ecki=22's?=
        message of "Fri, 09 Nov 2018 21:10:56 +0100")
Message-ID: <87in0x8l4t.fsf_-_@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(changing subject for better visibility and trimming Cc)

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
>
> I try to mark fixes (patches for currently developed release) with an
> extra FIX tag in a subject. Do you have any other method in mind that
> would be preferred by you?

Yes, I do see your FIX tag in patchwork:

 [ 31] [FIX] brcmfmac: fix reporting support for 160 MHz channels   2018-11=
-08=20

But "FIX" is a bit ambigous as not all fixes not go to wireless-drivers,
they can also go to wireless-drivers-next. So I prefer using the release
number (or name of the tree) like this:

[PATCH 4.20] brcmfmac: fix reporting support for 160 MHz channels

After seeing your question I added something about this to the wiki
which hopefully helps others:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#tree_labels

--=20
Kalle Valo
