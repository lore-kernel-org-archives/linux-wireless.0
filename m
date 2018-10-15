Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F26BC71133
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 18:00:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29B352064A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 18:00:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B352064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbeJPBrH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:47:07 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35592 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbeJPBrG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:47:06 -0400
Received: by mail-oi1-f193.google.com with SMTP id 22-v6so15821447oiz.2;
        Mon, 15 Oct 2018 11:00:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MiHU2TAfJa6NcIidUcVWtIrcqTqIaHRR6Z+0nNZ8zMg=;
        b=LFwRHHa9WishY4hLVi8eqoW9RtXB20x+3T5wpDpAiNax2NERi+xhQx7BEZkRKnvxWb
         YHscGWWMHg0UDS/oDQ7v6DvYiLd0U2ZWqfGEdXDcbAIyHnaGA5PPdttrEPEsphK1tRLL
         SJCxbxfg8vNJDK+LgJaKx9bePqjSJgsciPEZfv1KAF+vF+Vm6+coF78K3pxeHZkRmhXK
         vGkwMZaA5J5O3V6smZ4qL5I/wlxG/pFr4f98muEQpgV01+GkUf0cmg/Z0CgTHoqWZUgj
         l0AmHRH45VS/Sw/AjaX/K5AHCDDQZf+tnni/oe5yNMyHe9/rgFO2vWU9yNymY3jkl6Bk
         Ix1w==
X-Gm-Message-State: ABuFfojK3bB+S4+bjB1quMCTeuhLLaU9cq8k0DG/XVmcGI17u4Zp2r0L
        CTlkGfFMIJ++h/mb4TvX7Q==
X-Google-Smtp-Source: ACcGV63umDFAMBrXIeBpBweeylCea+RWzbSlJl8LvJuwhQrujR9jAEm9mRztuodlEOXw+pBJyfoNAw==
X-Received: by 2002:aca:3a41:: with SMTP id h62-v6mr9149949oia.84.1539626447663;
        Mon, 15 Oct 2018 11:00:47 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id f5-v6sm3772958oih.51.2018.10.15.11.00.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Oct 2018 11:00:46 -0700 (PDT)
Date:   Mon, 15 Oct 2018 13:00:46 -0500
From:   Rob Herring <robh@kernel.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, swboyd@chromium.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] dt-bindings: Add bindings for aliases node
Message-ID: <20181015180046.GA18294@bogus>
References: <20180925210255.172734-1-mka@chromium.org>
 <20181009010711.GA1577@ban.mtv.corp.google.com>
 <CAMuHMdWe5JYp5eC2PvuG4xEud908Crhm+BhrtxPJ4Uo1-LCc4g@mail.gmail.com>
 <20181009183141.GA126050@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009183141.GA126050@ban.mtv.corp.google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
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

I'm all for documenting this primarily to prevent folks from just adding 
whatever they wish in /aliases. Some platforms seem to want to have 
aliases for everything.

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

This basically matches my opinion on aliases.
 
I'd decouple it from board labels a bit. Sometimes the numbering may 
match, but others not. What if a board serial port is labeled "DBG" for 
example? I think 'label' is the right way to handle human identifible 
ports (and then we should have something like /dev/serial/by-label/...).

> That's fair enough. Just because the solution isn't an all-purpose tool
> doesn't mean it shouldn't be documented. The general concept is already
> in ePAPR, but it's just not very specific about property names.

Agreed. I guess the question is what to do on used, but not recommended 
aliases. I would put SPI and I2C into that category BTW.

Rob
