Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310AFC00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5DB22089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:52:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Doi617kS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D5DB22089F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726854AbeJCXmI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 19:42:08 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:44916 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeJCXmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 19:42:08 -0400
Received: by mail-oi1-f175.google.com with SMTP id u74-v6so5081484oia.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 09:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YXn2MDtwtJe2k2wpMpXosnvx4KkFqslN0W3KgViPMbQ=;
        b=Doi617kSoXnyRi4VO9fL9TVfnTG33bFzjzFtBJqxT5aBTAzvnJzY5YnD9fD6x06tCv
         21bgXLd5kyzItd7+Pxz2gCxUaaDvN2xSLrS+bxA4jxui3JPENSvIH9Bn56qqDnRVDe2t
         EwPTVISN8vqmOoQFvJbkQclsMrD89gxtriFzh/8D29Oj587I1enbwIwnUAdPObHsPJb4
         jbf47cVncITDeafHhcG8N+xKBAuTygMJhhHoDJs7q4WOanO1sANNAUiaFaOl4XAge4nz
         pONq7og/PkfOM1D3Hl+NkncLxg1ah+uhe2gHdzs1sIhGX+ODGE0OMYwB1mkT2kJUVU4Y
         Vo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YXn2MDtwtJe2k2wpMpXosnvx4KkFqslN0W3KgViPMbQ=;
        b=Zkizk4cNkUTRhF55LYnvc1dhi8xjqp4d4kNpA6u0RA21e+2QETXOO8gWlkBgZhvQIz
         /D2uivcfV9TE2WyqOIU0uHlUwhSBdAPWZF1vpFmn4xQXgUpAr/VKTUvCx/bxVco/sAwC
         J2DP+nRYzSvm8fbv6wS7Sj/h2JI7cWXmHnmWmdMeVmgHFwr9h39B/mpkpy10l9B3pBFe
         fKXF1XxqID45BjsIqAlLV6bTM5e0hGgdTz2NWigcLpH1S+SHiPPaOF5/eU2DlAtt1q4f
         Hn5w8IHQ7Dhh8xdwgVduZRYm9hPyLKABD1znFMERcZuImSK6cuSeU5j7mAJnwDqUD+Rm
         nzDg==
X-Gm-Message-State: ABuFfogXFoyiADLV3KXhtCms68WcBB2HvGVdsZXchFnO+dVWYYWwR80v
        IegcHYqXgp8lA2VUz6d0jQJjZJlT
X-Google-Smtp-Source: ACcGV62Z0mFNLAsXbBnDdZX5bLUj/ULAzRYo3/d4/M9V/L9CRMRb4J5f5wnfzrRcs07Cqua+75pJcA==
X-Received: by 2002:a54:4e0f:: with SMTP id a15-v6mr1061873oiy.346.1538585571050;
        Wed, 03 Oct 2018 09:52:51 -0700 (PDT)
Received: from [192.168.1.107] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id e9sm581576oth.7.2018.10.03.09.52.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Oct 2018 09:52:50 -0700 (PDT)
Subject: Re: [RFC v2 00/12] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Sid Hayn <sidhayn@gmail.com>, yhchuang@realtek.com
Cc:     Kalle Valo <kvalo@codeaurora.org>, pkshih@realtek.com,
        tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <CAM0KTbAkm+crgK98kus7N7fCZFA5w9aRJ=Fam+Qe5cv_t9x=DA@mail.gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <3aa94c69-9cdf-77e0-f7b6-d31b501beaee@lwfinger.net>
Date:   Wed, 3 Oct 2018 11:52:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <CAM0KTbAkm+crgK98kus7N7fCZFA5w9aRJ=Fam+Qe5cv_t9x=DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/3/18 11:15 AM, Sid Hayn wrote:
> Is there a public repository where I can track development for this driver?

For the moment, this is it. Once the driver is accepted into the 
wireless-drivers-next tree, I will create a new rtw88 branch in 
http://github.com/lwfinger.git with this driver to accomodate people that want 
to use the driver with an older kernel.. At the moment, it is still in too much 
of a flux.

Larry


