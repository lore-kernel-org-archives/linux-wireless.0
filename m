Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185F2C28CF8
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 00:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C363520835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 00:08:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="cJzXCtW2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C363520835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbeJLHiR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 03:38:17 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38414 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbeJLHiR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 03:38:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id f29-v6so5224098pff.5
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 17:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cD8mtAZnrwn3vT5YGMGRUty9PS2JbeDJxnzk0S4dAR0=;
        b=cJzXCtW2AxctRXnqexgbTiwu3AHfn6Y5YZSH6BS9wz1NFBLaWzGTw6Q2oBrPsTmhia
         XMw2x0xVOi5dyiduyybF4/bspow9MKUyBwp6tcUo5I3afzXIlsu7aVC+k8kI8+g20enB
         ZThC+awp4GXC6H/TBTr6SbG6pgXbK2dv3m9iI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cD8mtAZnrwn3vT5YGMGRUty9PS2JbeDJxnzk0S4dAR0=;
        b=XhagllkpGfRBaerNYq7VwUNX5Vz3E4cuj25niK7fTSK0/aUd4KymQAc66HbDHx+ElT
         iHKfnj1N+Fk9Ln4lcbOsz1dkwGJgkSfHe30B8/ZaKLGMkL4NHtJUcU/SxLWh7Lj8wcZy
         Futs5i5bNVhUWshdDFAc5hQYOEyFkxtgK3RlkT1HBs/8+PXUvzDvEdTDtrgRL0kqpclJ
         PAq7cM6d5nTRAbE1UhJesoCTMuTszxZOtAJB+0DmliVPG1j4/w5qMOO13TFnV0EK/exK
         15qsATHWIsnxqgz6OYR8BsSynF8ipMMT9M5k5ZkmEgUOAj5woZr59lU7qww++Mmc+Lc2
         v/uw==
X-Gm-Message-State: ABuFfog8z9yFF4iD6QAzpKOPkW1v6OTHhivaQG9I43iJfY2nA1MqcquX
        pPKmdHsmBHjAqA6YoEEuMlb4Tg==
X-Google-Smtp-Source: ACcGV63Z/xdp8P3dJpoFsaLnKu2TMP6cnj/QZYAbysmErnlv3NSin+Y3tLcPpGj4Q9v00FoBMPS28A==
X-Received: by 2002:a62:5e02:: with SMTP id s2-v6mr3809792pfb.146.1539302918364;
        Thu, 11 Oct 2018 17:08:38 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:b6af:f85:ed6c:ac6a])
        by smtp.gmail.com with ESMTPSA id c2-v6sm26202941pfn.95.2018.10.11.17.08.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 17:08:37 -0700 (PDT)
Date:   Thu, 11 Oct 2018 17:08:37 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Message-ID: <20181012000837.GP22824@google.com>
References: <20180925210255.172734-1-mka@chromium.org>
 <20181009010711.GA1577@ban.mtv.corp.google.com>
 <CAMuHMdWe5JYp5eC2PvuG4xEud908Crhm+BhrtxPJ4Uo1-LCc4g@mail.gmail.com>
 <20181009183141.GA126050@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20181009183141.GA126050@ban.mtv.corp.google.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 09, 2018 at 11:31:42AM -0700, Brian Norris wrote:
> On Tue, Oct 09, 2018 at 09:22:07AM +0200, Geert Uytterhoeven wrote:
> > Please note these aliases become cumbersome once you start considering
> > (dynamic) DT overlays.  That's why I made them optional in the sh-sci
> > serial driver, cfr. commit 7678f4c20fa7670f ("serial: sh-sci: Add support
> > for dynamic instances").
> 
> Note that as I understand it, the entire point of documenting this sort
> of thing is to help solidify the interface between a DT aware boot
> program (e.g., bootloader) and a device tree which is provided
> separately, to avoid memorizing node/path hierarchy. It doesn't need to
> (and doesn't, as I read it) enforce an OS's device naming policy.
> 
> > Relevant parts of the commit description are:
> > 
> >     On DT platforms, the sh-sci driver requires the presence of "serialN"
> >     aliases in DT, from which instance IDs are derived.  If a DT alias is
> >     missing, the drivers fails to probe the corresponding serial port.
> > 
> >     This becomes cumbersome when considering DT overlays, as currently
> >     there is no upstream support for dynamically updating the /aliases node
> >     in DT.
> 
> That part is not a DT spec problem :)
> 
> >     Furthermore, even in the presence of such support, hardcoded
> >     instance IDs in independent overlays are prone to conflicts.
> > 
> >     Hence add support for dynamic instance IDs, to be used in the absence of
> >     a DT alias.  This makes serial ports behave similar to I2C and SPI
> >     buses, which already support dynamic instances.
> 
> This seems to be a much different sort of problem. People always love
> having predictable IDs given by the OS (myself included), but that's
> just plain hard to do and impossible in some cases. I don't think that's
> what this document is about though.
> 
> IOW, this document seems pretty consistent with the above: it doesn't
> require the usage of aliases (and it seems silly to have a driver
> *require* an alias) -- it just documents how one should name such an
> alias if you expect multiple independent software components to
> understand it.
> 
> > To clarify my point: R-Car M2-W has 4 different types of serial ports, for a
> > total of 18 ports, and the two ports on a board labeled 0 and 1 may not
> > correspond to the physical first two ports (what's "first" in a collection of
> > 4 different types?).
> > 
> > Aliases may be fine for referring to the main serial console (labeled
> > port 0 on the device, too), and the primary Ethernet interface (so U-Boot
> > knows where to add the "local-mac-address" property), but beyond that,
> > I think they should be avoided.
> 
> That's fair enough. Just because the solution isn't an all-purpose tool
> doesn't mean it shouldn't be documented. The general concept is already
> in ePAPR, but it's just not very specific about property names.

Basically what Brian said, this doc doesn't encourage the use of
aliases, it just intends to establish a consistent naming for cases
where aliases are needed/more useful than harmful. The misuse of
aliases needs to be addressed in the reviews of the patches that
introduce them.

Maybe the doc should include a recommendation to use aliases
sparingly? I'm open to input on that from folks who have a better
understanding of the potential pitfalls ;-)

Cheers

Matthias
