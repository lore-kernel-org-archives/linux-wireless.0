Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD8BC65BAF
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 00:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E90920868
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 00:16:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="A9Z0AmxQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E90920868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbeLGAPy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 19:15:54 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34747 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeLGAPy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 19:15:54 -0500
Received: by mail-pf1-f195.google.com with SMTP id h3so999138pfg.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2018 16:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LrQCzepF32eSc4nulqWoLfzxYmel15K3WRQ7t0gxsl8=;
        b=A9Z0AmxQgbQ6/n5gJijTU3OosRY1SSL6itGySkugpgf2i7uanLsmLGF3rXlnGrRcF0
         MhqpTQ5GiFRHEFAnx02FqitZWiz3uIha+cDZMMt8mI1C3YXHmpamyTw6dI9ZYiLlCeQK
         ubsMcAoCGK4VayCzEVC18N4zu7ObTMfgBlmYI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LrQCzepF32eSc4nulqWoLfzxYmel15K3WRQ7t0gxsl8=;
        b=UNBhhnzBCXazOMxudDMxmh8Uxmr4KWKgmV92vc5deqxQd58p3c5KZNGacodeXZ1EpJ
         T4q+Ppx9Peexao1Wf0qdeV3kz6mwnQ6UbIGFnbgZOyy8mx1aSRcl+GPBiqery9oPunCx
         bdQtpaobnAEL23pbZMce4OYXt6yw/C8yT1VSnD6e1V9MK+7dlrdpIZY9Fc5iGjUoB+fJ
         zZmJO4oGc1kjOAUs4t1y8q75ZN5IAqG2gsXPqJdHe/i8pss3FrNqOHY93exgoWGy7Jz9
         WNYfAuEc3mApP/9j16CuRV/45DDVt7ZpFFWr/sqhVeVBBdWCyh/UKPV7cB3Rg6Oy7Fuw
         SWyg==
X-Gm-Message-State: AA+aEWa8jYxQvqTs8xjyZPRwfDh+oExS3aq31Yg7RvTbnyGjVf/17/Ge
        m9fj3DCXFj01WgUivczfGqF8Pw==
X-Google-Smtp-Source: AFSGD/VmNggKG9AdPps+47dVG6ibac4BfZY03f/XpJJt5IQ7hdII7LeIohGHg5q1/1wGkqpB3+PmIA==
X-Received: by 2002:a65:6491:: with SMTP id e17mr52023pgv.418.1544141753790;
        Thu, 06 Dec 2018 16:15:53 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id y6sm2204682pfd.104.2018.12.06.16.15.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Dec 2018 16:15:45 -0800 (PST)
Date:   Thu, 6 Dec 2018 16:15:42 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mwifiex: debugfs: correct histogram spacing,
 formatting
Message-ID: <20181207001540.GA165647@google.com>
References: <20181130225303.143409-1-briannorris@chromium.org>
 <eef7598bb282218d4700986b15cf9f83a5e7edb5.camel@perches.com>
 <20181203222654.GA155572@google.com>
 <87k1kper11.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k1kper11.fsf@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Dec 04, 2018 at 08:37:30AM +0200, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> 
> > Here's a v2 that combines both sets of strings in that way. I'm not
> > resending the other patches, since they were only related in concept
> > (since I was referring to debugfs for implementing the nl80211 stuff),
> > but have no real dependency.
> >
> > @Kalle: I can resend the others as a new series if that helps.
> 
> Yeah, it does. Trying to pick patches from different places in patchwork
> is just too much of a hassle for me. So please do resend the whole
> series.

I've split them up and resent the other 2 unmodified now (as 'RFC PATCH
v2 X/2'), as this patch is trivial and not related to the others
directly. They can be applied in any order. Hopefully that's sufficient.

Brian
