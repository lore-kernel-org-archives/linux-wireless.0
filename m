Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442C5C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B9A72086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:31:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="llUXA/aD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B9A72086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbeJMAEd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 20:04:33 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35520 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbeJMAEd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 20:04:33 -0400
Received: by mail-ed1-f68.google.com with SMTP id y19-v6so12037580edd.2;
        Fri, 12 Oct 2018 09:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CtHqhucVpoRJ9ZZE2L0WHY7oYNoqXEFljxT1F1BgAiw=;
        b=llUXA/aDq4Y7S7zn3jvNEMPiMfbxpLDj/ZZwP3IN2xi8kViqPif50ZSDCRw6rnrUSi
         q0xvMAMvfWhHDZEnEb2tN2cQnwE0EJF2oWxssz0K9i+Xh3C//2GUP6TSK+aLbVD1o4GX
         ug5UwmjRxSQpWhCXtGiojLKSl5xCpsAKQScC2+bwYa3PqhyTZNBlyjDpm4SKtw7Waj/5
         KhoZPNwjJQBdsIZkzPnYKtDXGN7SYQqEcF6QYkXReYc6W1hujAa0Mx6t3uFsLwaZ4de9
         9Glqp3cH1pq2oUtu3RwpzjYCdlkRTb5BCUsWLhHX5lQ0OGzPuT1tCcU9XJ/vCKGwNAQJ
         DXqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CtHqhucVpoRJ9ZZE2L0WHY7oYNoqXEFljxT1F1BgAiw=;
        b=kyI+287nA2rswBMPBc3m5gQJAmRLPGhVfIwJonMCj5VetCAWej4NZylW2eXwXQKnDo
         kKi9J06KlgSWme/o/+5rQqw8iNGUm0OWcO5QlhDNsD6ITEyKSdg3v8mCX9Osb0d/CGxk
         xyzYKctzdpJmVJYJseGVA/rDZSQanVl1K4nV1N5W+uPjvNAli+rUNUcUzBlKTLEaV86X
         mf8O7nfG4uvXGsUOJ97NQnUvtgBdMTVNAji1W1e6LsK0eQ68bqHJmcR7K6OJEsw7RPmo
         mPl8sUsU7J5+K3GRgahefgN/kR//lUT40X7Mys6KKV72dlU5VHmWsdkABAIPyb74IJ58
         OctQ==
X-Gm-Message-State: ABuFfojW508Wpe1GLPFTSPWfj63T72ElJ3lN6jPUMA3XpnnhnU64WQCg
        WT7IMWS3mwHX8yZmbPFTXQU=
X-Google-Smtp-Source: ACcGV62vGLozIOOik8Ri4qdwfF7/+92mPxomlq0PlJMirOdPpT0Jr++5wN0QqSUHP9QqGemIu5z24Q==
X-Received: by 2002:a17:906:b01:: with SMTP id u1-v6mr8156076ejg.124.1539361874024;
        Fri, 12 Oct 2018 09:31:14 -0700 (PDT)
Received: from debian64.daheim (p200300D5FBC368FCD63D7EFFFEBDE96E.dip0.t-ipconnect.de. [2003:d5:fbc3:68fc:d63d:7eff:febd:e96e])
        by smtp.gmail.com with ESMTPSA id e8-v6sm429592ejm.75.2018.10.12.09.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 09:31:13 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.91)
        (envelope-from <chunkeey@gmail.com>)
        id 1gB0LI-0003WH-8I; Fri, 12 Oct 2018 18:31:12 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
Date:   Fri, 12 Oct 2018 18:31:11 +0200
Message-ID: <1626442.UsWqDEgn3j@debian64>
In-Reply-To: <20181012000837.GP22824@google.com>
References: <20180925210255.172734-1-mka@chromium.org> <20181009183141.GA126050@ban.mtv.corp.google.com> <20181012000837.GP22824@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Friday, October 12, 2018 2:08:37 AM CEST Matthias Kaehlcke wrote:
> Maybe the doc should include a recommendation to use aliases
> sparingly? I'm open to input on that from folks who have a better
> understanding of the potential pitfalls 

I had a similar discussion with the OpenWrt devs over the
use of "led-$function" aliases in a DTS. I did a bit of digging and
found this wonderful emails from Mark Rutland regarding the general
use and abuse of aliases in a reply to a patch by Christer Weinigel 
"devicetree - document using aliases to set spi bus number."

<https://patchwork.kernel.org/patch/9133903/#19207021>

|"If those ports are physically organised and labelled the same, then
|using aliases could make sense, to describe the well-defined physical
|labels. If you've assigned the numbers artificially, or if the physical
|organisation differs across boards, then aliases are not the right tool
|for the job.
|
|In the latter cases we're altering the hardware description to suit an
|application, rather than providing the necessary abstraction, which is
|the kind of (ab)use of aliases which we want to avoid."

And he followed it up with a summary:
<https://patchwork.kernel.org/comment/19207071/>

|Typically, serial ports are much more user-accessible (physically), and
|much more directly useful to a user in a generic fashion. They're often
|labelled (physically or in a manual) with a number, and we use aliases
|to describe those labels to the kernel. The fact that the kernel may use
|that to drive its own internal numbering is immaterial to the binding.

So the gist of this is that aliases are meant for user-accessible /
physically devices/ports/etc... that are labeled as such. And this of
course works perfectly for power/status LEDs and such because they
usually have little "power" symbols/pictograms/lables near them. 


