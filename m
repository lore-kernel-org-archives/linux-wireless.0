Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFEBC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 19:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B4720664
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 19:52:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NKED8KV7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71B4720664
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbeK0Gru (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 01:47:50 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:43176 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbeK0Gru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 01:47:50 -0500
Received: by mail-io1-f66.google.com with SMTP id g8so14985370iop.10
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 11:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zP6lpUskG1rDoaB/olEgYPbqOaIy43+0X9FfLGT2CpE=;
        b=NKED8KV7o2WW756UqKrhWkd7CtAhv4Ngb7jjsWNKVqx4WeFjgIGwwELMrmHigy+von
         oZa0tgxRO3jx3VrFVGMbLP0743nPL56vvZjnEgHn5z4uUzpsFbPnip/qHlJr8LcFXMqd
         tdIwyniuZWaypMvq2ES35MEkptFI1Ak0S1M9wZLawfTTX/NZZ6UoGLtzMKnLwlKbeHD9
         zF2Zqtj54odlo1yXeloU7mTADMTta9cp8X5p443R4zY2215Ptii+7wTOCSaMwY0XS/0r
         +8OALVns4bvyEuR1ks0HsLDRZ9M1bde0NPwbLeii1KbrTV6mSGPk6HSfmEICfxBD05X6
         UoqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zP6lpUskG1rDoaB/olEgYPbqOaIy43+0X9FfLGT2CpE=;
        b=KJ7fBdVj3OQMnX6f6TbtwNySKoLgq3icX9aItm+QX5VQI/OIcRGyUOmFnYNHsK/3/9
         7dKEgiTuWhh07N95EIBYEWN4PV9MBq5Hup7FSSau4kdLbovD6AdAsjrOssmd2uv0fsAe
         Fh/0CakM/3PLFGhVJqSJ5leb3dVVHOGwPzkwBRVicrqh9BeP/pseL8em2HH3NzXH5N2V
         G27X5HzfVQtCi7kE0F67viJB6Fm26PA19QVSCMg4X9MQi5/DNiIMy8asb9c4CrDLUHO/
         iti6S+tEA9OeaSA5e+EC9kuN934Qbh41P5y9OzHLndyQf3zlBXIu1GqvxVyKhtY32Wkk
         nRow==
X-Gm-Message-State: AA+aEWay6+dFup0nZHGDbZ1G6W7l5YImHX4j+uvkqUKU3qe7riuulTsB
        PhypdaIvCDWzlqswAzbQD8IsL5j4W3WxgVU8Njkvrw==
X-Google-Smtp-Source: AFSGD/VHQGR5DvDLvkra34FKZmswZn/b6EW4Hx7rkWDEv8CPq541kLP30VyRCbacZibecPJdd1cLoPl/JC7v+dG/ZwQ=
X-Received: by 2002:a6b:d005:: with SMTP id x5mr22477324ioa.46.1543261958612;
 Mon, 26 Nov 2018 11:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20181121031449.255314-1-schuffelen@google.com> <d0ba9821e46e1111bc483188466bb68dc1bb3c4a.camel@sipsolutions.net>
In-Reply-To: <d0ba9821e46e1111bc483188466bb68dc1bb3c4a.camel@sipsolutions.net>
From:   Cody Schuffelen <schuffelen@google.com>
Date:   Mon, 26 Nov 2018 11:52:27 -0800
Message-ID: <CAAELVAEVJK3iezPVCB9fizDwy+HoFtFZp5KTMDu+GmYCy-KG1A@mail.gmail.com>
Subject: Re: [PATCH mac80211-next v4] mac80211-next: rtnetlink wifi simulation device
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        sergey.matyukevich.os@quantenna.com, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@android.com, Alistair Strachan <astrachan@google.com>,
        Greg Hartman <ghartman@google.com>,
        Tristan Muntsinger <muntsinger@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > +config VIRT_WIFI
> > +     bool "Wifi wrapper for ethernet drivers"
>
> The built bot complaint is most likely because of this being bool rather
> than tristate (CFG80211=m, VIRT_WIFI=y, I guess, didn't check), I
> thought this was because of the wrong reasons and should be back to
> tristate?
>
> I can change it back, let me know.
>
> johannes

Right, my mistake. This should be a tristate again, sorry about that.
Should I send v5 for this?

Cody
