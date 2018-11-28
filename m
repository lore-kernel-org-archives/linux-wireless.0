Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631A6C04EB8
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 10:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31F82205C9
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 10:44:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31F82205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbeK1Vp4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 16:45:56 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55505 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbeK1Vpz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 16:45:55 -0500
Received: by mail-wm1-f67.google.com with SMTP id y139so2048735wmc.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 02:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tUk7yiXmnrLAyU5xyTpJrK6jpI8frngrFPY5Cp5BCcg=;
        b=GcMQJGFJBRvp4vrvbv4fogkkohK7BxA03PUxAA2gLm78fxWd2mWCkzBt8L77RWpLmu
         lQawVH+XG1WD0IDC1LlwiKsc9YCgXTdUJyqR5gdKiR1SM0bL9lAvjWnfg9TRGl6V3jnx
         D6laPW4x8WUYLNkgzKqqb1+gkD6GMHB7iGTY+mlufF1C7SPfYLfcDATdm2xBFt7cJcuX
         0oyGD4GzWKQQ57vWr8Fyrej7DDYknkz1p5aCW9T59LLdILkczaSuJOYhYR/Bb8wzUqj2
         g/nKO9F7LX7cFrjA9nc1NCgYYUtN/6T2HzRtEihfFTw0JlP0uFWmeQd6n3SGUrTGYsqQ
         SyDw==
X-Gm-Message-State: AA+aEWbsxPerBuiO2LRZB4pi5p+Z4j1E30/BGC1B0bLy/FyalIMW6wIg
        ikzL+9CsB/2LtpdwDlsb6SqaMXwyQ1c=
X-Google-Smtp-Source: AFSGD/UzFDUOzy5aIbCArhrHtIaiWUr0Clymq9XXS0E/LmE46xmyn03UV/As10QgEMfNzvPvwnO4iQ==
X-Received: by 2002:a1c:702:: with SMTP id 2-v6mr2268323wmh.113.1543401880733;
        Wed, 28 Nov 2018 02:44:40 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r76-v6sm2156860wmb.21.2018.11.28.02.44.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 28 Nov 2018 02:44:39 -0800 (PST)
Date:   Wed, 28 Nov 2018 11:44:37 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Message-ID: <20181128104436.GA2298@localhost.localdomain>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
 <8736rla4ow.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736rla4ow.fsf@purkki.adurom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:
> 
> > This series is intended as a playground to start experimenting/developing
> > with XDP/eBPF over WiFi and collect ideas/concerns about it.
> > Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
> > actions are:
> > - XDP_PASS
> > - XDP_ABORTED
> > - XDP_DROP
> > Introduce ndo_bpf mac80211 callback in order to to load a bpf
> > program into low level driver XDP rx hook.
> > This series has been tested through a simple bpf program (available here:
> > https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
> > used to count frame types received by the device.
> > Possible eBPF use cases could be:
> > - implement new statistics through bpf maps
> > - implement fast packet filtering (e.g in monitor mode)
> > - ...

Hi Kalle,

> 
> This is most likely a stupid question, but why do this in the driver and
> not in mac80211 so that all drivers could benefit from it? I guess there
> are reasons for that, I just can't figure that out.
> 
> -- 
> Kalle Valo

I thought about that possibility (and I think it is definitely valuable) but
I preferred to work as close as possible to the hw running the bpf program
before skb allocation. My primary goal when I started thinking about eBPF over
WiFi was to perform fast packet filtering.
I think these two possibility are not mutually exclusive, we can fall-back to
mac80211 if hw driver does not support XDP.
This is an early stage implementation, at this point I would collect other
people opinions/concerns about using bpf/xdp directly on 802.11 frames.

Regards,
Lorenzo
