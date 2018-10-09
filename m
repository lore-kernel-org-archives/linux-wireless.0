Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8F7ECDE3A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2BCA2085B
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 18:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QLN55wqy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2BCA2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbeJJBuD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 21:50:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46743 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbeJJBuD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 21:50:03 -0400
Received: by mail-pg1-f193.google.com with SMTP id a5-v6so1214060pgv.13
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 11:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=902PhF52M/Cz6Tu0Ri21LRUdH6aCiX/xSuwLUBdR8ts=;
        b=QLN55wqy95vfQfu3ELTE4AOFrRezhhBK59GpCWSwIOsxFbNAwjmYqdA85qD9jVibFn
         A7I/V4JIPKkLuv5Sz5TWsB/VYDKIBi/U+wQANi3MqtHdJDT9W9CEpqfWw/K1vi4G1jyL
         p8RxgjVI6jM3N+vJ7d9hkwn1nUnFK3hx31WLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=902PhF52M/Cz6Tu0Ri21LRUdH6aCiX/xSuwLUBdR8ts=;
        b=BP9mxWrG9TyuczyEcj7NBHmHdDR16jmSnXUNbUL/S5vxV1+vtMYT6u8dXJaTRDurhm
         h33WZIlnl9ydThoKJZ9+s+OPvraCULaWrMCSrHmxiX8poP9mNWg+HbJvjb+Gj5YWhkZ0
         6vxVp8xIeddNxhXk1g1BDel28TFCQQ7XNif2dODwrZJH1DZw+35XuzkxrEhe7pC5OJE/
         LpMutAXco/pumto2N5jnZBcWQz/A2W8aA57TepOhk2K0F1SYJ+AhBDPn41us7F2CGrB3
         iEHr3FLAV5RVKFBrlpOyTxCjjUFJ0jLz0VseySiVXvLNG53ZfwQ0Bg4/gENGXfLCxWUe
         HbFw==
X-Gm-Message-State: ABuFfojkNkhV9h3xGpd1Ej4SVLcJUh+c1IC5GcipT4YmyMGpVOfouJwo
        5/Nw1d7IjC4IEUXYktvxOw5s7UlAaMtGvg==
X-Google-Smtp-Source: ACcGV62FGv5+mRRhnjg9YGiStdG8+taHNLe/5v+BoNk8URpqchtFOAwlxfD6zJwEgMXBfeGyG0mYAQ==
X-Received: by 2002:a62:798e:: with SMTP id u136-v6mr30611363pfc.95.1539109905997;
        Tue, 09 Oct 2018 11:31:45 -0700 (PDT)
Received: from ban.mtv.corp.google.com ([2620:15c:202:1:299d:6b87:5478:d28a])
        by smtp.gmail.com with ESMTPSA id l10-v6sm39061838pgs.45.2018.10.09.11.31.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Oct 2018 11:31:44 -0700 (PDT)
Date:   Tue, 9 Oct 2018 11:31:42 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, swboyd@chromium.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] dt-bindings: Add bindings for aliases node
Message-ID: <20181009183141.GA126050@ban.mtv.corp.google.com>
References: <20180925210255.172734-1-mka@chromium.org>
 <20181009010711.GA1577@ban.mtv.corp.google.com>
 <CAMuHMdWe5JYp5eC2PvuG4xEud908Crhm+BhrtxPJ4Uo1-LCc4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWe5JYp5eC2PvuG4xEud908Crhm+BhrtxPJ4Uo1-LCc4g@mail.gmail.com>
User-Agent: Mutt/1.10.1+48 (1f3a9df87d11) (2018-07-22)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 09, 2018 at 09:22:07AM +0200, Geert Uytterhoeven wrote:
> Please note these aliases become cumbersome once you start considering
> (dynamic) DT overlays.  That's why I made them optional in the sh-sci
> serial driver, cfr. commit 7678f4c20fa7670f ("serial: sh-sci: Add support
> for dynamic instances").

Note that as I understand it, the entire point of documenting this sort
of thing is to help solidify the interface between a DT aware boot
program (e.g., bootloader) and a device tree which is provided
separately, to avoid memorizing node/path hierarchy. It doesn't need to
(and doesn't, as I read it) enforce an OS's device naming policy.

> Relevant parts of the commit description are:
> 
>     On DT platforms, the sh-sci driver requires the presence of "serialN"
>     aliases in DT, from which instance IDs are derived.  If a DT alias is
>     missing, the drivers fails to probe the corresponding serial port.
> 
>     This becomes cumbersome when considering DT overlays, as currently
>     there is no upstream support for dynamically updating the /aliases node
>     in DT.

That part is not a DT spec problem :)

>     Furthermore, even in the presence of such support, hardcoded
>     instance IDs in independent overlays are prone to conflicts.
> 
>     Hence add support for dynamic instance IDs, to be used in the absence of
>     a DT alias.  This makes serial ports behave similar to I2C and SPI
>     buses, which already support dynamic instances.

This seems to be a much different sort of problem. People always love
having predictable IDs given by the OS (myself included), but that's
just plain hard to do and impossible in some cases. I don't think that's
what this document is about though.

IOW, this document seems pretty consistent with the above: it doesn't
require the usage of aliases (and it seems silly to have a driver
*require* an alias) -- it just documents how one should name such an
alias if you expect multiple independent software components to
understand it.

> To clarify my point: R-Car M2-W has 4 different types of serial ports, for a
> total of 18 ports, and the two ports on a board labeled 0 and 1 may not
> correspond to the physical first two ports (what's "first" in a collection of
> 4 different types?).
> 
> Aliases may be fine for referring to the main serial console (labeled
> port 0 on the device, too), and the primary Ethernet interface (so U-Boot
> knows where to add the "local-mac-address" property), but beyond that,
> I think they should be avoided.

That's fair enough. Just because the solution isn't an all-purpose tool
doesn't mean it shouldn't be documented. The general concept is already
in ePAPR, but it's just not very specific about property names.

> Just my two^H^H^Hfive €c.

Thanks,
Brian

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
