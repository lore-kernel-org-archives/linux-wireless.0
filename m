Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA515C67872
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:37:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EB021470
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:37:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mmpXhOAo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N72+Qns8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0EB021470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbeJLXKc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:10:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45182 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728900AbeJLXKc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:10:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5C1EE601D2; Fri, 12 Oct 2018 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539358650;
        bh=88RuVfjNoqZnUx8pQgciUb2jvvqL7o09wcjkaF7nOIA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mmpXhOAoc+RDDG71yjTOnY/g6Dk1RrTwK+w5ySrBKCdGfTJAi5EiS/LXFX+VG74Fo
         /n0hEcfwqElx3aTpmizPE7XneaczauyxWt2auv/ufA2/YusCnEBdSS+l++mw3ttvws
         f6N9Ddyfdqt+Ljy+Y55d9LHX4xE1wTyIgl53v9f8=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ACC616021A;
        Fri, 12 Oct 2018 15:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539358649;
        bh=88RuVfjNoqZnUx8pQgciUb2jvvqL7o09wcjkaF7nOIA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N72+Qns83E/YHNQpxXcAoLe+JCtTd2h5jFmo1xu9mAUpdDZjp1q6e8iZVsv3AHoke
         BGiDth0KgO9DOwHjsElliuEhFzPgWf4a1cJeL+Fpi69WGOzOKsP3CdQOUQrZw7vxrs
         IFNVNSBGzr4gVKuwQxieHkRga7ymSZ8fIaJEFxSA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ACC616021A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, Wen Gong <wgong@qti.qualcomm.com>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org>
        <877ek18vyn.fsf@kamboji.qca.qualcomm.com>
        <b6d8ada015e04738b6b3cee95e485e14@aptaiexm02f.ap.qualcomm.com>
        <87zhwx7ajo.fsf@kamboji.qca.qualcomm.com>
        <92bec84a762be7589b13274fb30dd649@codeaurora.org>
Date:   Fri, 12 Oct 2018 18:37:26 +0300
In-Reply-To: <92bec84a762be7589b13274fb30dd649@codeaurora.org> (Wen Gong's
        message of "Wed, 05 Sep 2018 10:51:19 +0800")
Message-ID: <87r2gv2n2h.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@codeaurora.org> writes:

> On 2018-09-04 19:43, Kalle Valo wrote:
>> Wen Gong <wgong@qti.qualcomm.com> writes:
>>
>>>> > +enum wmi_nlo_cipher_algorithm {
>>>> > +	WMI_NLO_CIPHER_ALGO_NONE           = 0x00,
>>>> > +	WMI_NLO_CIPHER_ALGO_WEP40          = 0x01,
>>>> > +	WMI_NLO_CIPHER_ALGO_TKIP           = 0x02,
>>>> > +	WMI_NLO_CIPHER_ALGO_CCMP           = 0x04,
>>>> > +	WMI_NLO_CIPHER_ALGO_WEP104         = 0x05,
>>>> > +	WMI_NLO_CIPHER_ALGO_BIP            = 0x06,
>>>> > +	WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP  = 0x100,
>>>> > +	WMI_NLO_CIPHER_ALGO_RSN_USE_GROUP  = 0x100,
>>>>
>>>> Two defines with the same value 0x100, is this really correct?
>>>
>>> Yes, it is an interface between host driver /firmware.
>>
>> Yeah, I know it's an interface between the host driver and the firmware
>> but it does not make any sense and is just confusing. Either of them
>> should be dropped.
>
> yes, either of them can be dropped.

Ok, I dropped WMI_NLO_CIPHER_ALGO_WPA_USE_GROUP in the pending branch.

-- 
Kalle Valo
