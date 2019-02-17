Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7FFCC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 10:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFCD2147C
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 10:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfBQKyA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 05:54:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36189 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfBQKyA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 05:54:00 -0500
Received: from mail-ed1-f72.google.com ([209.85.208.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gvK58-0005Sd-6p
        for linux-wireless@vger.kernel.org; Sun, 17 Feb 2019 10:53:58 +0000
Received: by mail-ed1-f72.google.com with SMTP id c53so5966416edc.9
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2019 02:53:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WdRKVYOlBTwIp8iIxhheyN14PJ2F114qw/Wvi0RzWLU=;
        b=kxDQWbra4JW5SCUk4SKdeIor9kYKvBw3XRkohEDEUW6RBDAtoVo9/nZVollkind/4e
         l06osz5lS5pXclztrdhAMFoIaeAXsvca3HcjpLf/FBSWqiGeb6k61wAvmjfUyA58MXBB
         hJPLqzS3GbvTtgVWFEKUIV3FE4aZLuZFLz5BZHjMDzfiyLD1ziXhwMA3zyLTVBNtDGgr
         XaQO9CmsKQ6QjpIGApI5mw0KVvD2bTnNcfOkYr+gnn5D7Tg6lX0DrbMe+uS8e2sIoOcz
         Qwxs4PXFwIteT/hNm08oGk5eZlZuVlbZQkIRj/dmG1um1SNrNsF3WZwk8NKCHcYHLN9C
         WHFA==
X-Gm-Message-State: AHQUAubDcZmTzeYTXet5wKHP2H4CDsOnDcQMduWJ7mG7z+2Dwx0zdvYk
        II/WU8pbfMB0MiR4IxbpxvP0pnR6tph0OF1jB8P33Sil9OMD/W79Wa9rOrNHilG2DR+PeOWtdxv
        nwrNA1pLPGVQTgnwkrHK+atvXII66cbtB5GDhOuVmtMND
X-Received: by 2002:a50:b3ce:: with SMTP id t14mr10784572edd.58.1550400836391;
        Sun, 17 Feb 2019 02:53:56 -0800 (PST)
X-Google-Smtp-Source: AHgI3IaMBqnKD2JQuG6smw0Xo74+DK57rR2nF/3AGfc2HjZTq4aG7bC7YDvtidHf+uC038VhDGox4g==
X-Received: by 2002:a50:b3ce:: with SMTP id t14mr10784553edd.58.1550400835913;
        Sun, 17 Feb 2019 02:53:55 -0800 (PST)
Received: from localhost ([88.128.80.113])
        by smtp.gmail.com with ESMTPSA id w24-v6sm2329364eja.71.2019.02.17.02.53.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Feb 2019 02:53:54 -0800 (PST)
Date:   Sun, 17 Feb 2019 11:53:53 +0100
From:   Seth Forshee <seth.forshee@canonical.com>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     wireless-regdb@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: update 60ghz band rules for us
Message-ID: <20190217105353.GA22074@ubuntu-xps13>
References: <20181218080815.19395-1-chaitanya.mgit@gmail.com>
 <20190122211351.GW7206@ubuntu-xps13>
 <CABPxzY+jbfoVGF_fta3reHa5yngmp_+dVKCiu3DR-8WzzxAPow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPxzY+jbfoVGF_fta3reHa5yngmp_+dVKCiu3DR-8WzzxAPow@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 23, 2019 at 04:19:26PM +0530, Krishna Chaitanya wrote:
> On Wed, Jan 23, 2019 at 2:43 AM Seth Forshee <seth.forshee@canonical.com> wrote:
> >
> > On Tue, Dec 18, 2018 at 01:38:15PM +0530, chaitanya.mgit@gmail.com wrote:
> > > From: Chaitanya Tata <Chaitanya.Mgit@gmail.com>
> > >
> > > Include channels 4, 5 & 6 for US in 60GHz band. FCC extended the
> > > 57-64GHz band till 71GHz with almost same rules.
> >
> > This looks right to me based on my research. You're missing one thing
> > though. You need to provide a Signed-off-by tag, please see the
> > CONTRIBUTING file for more information. If you reply with your tag I
> > will add it when I apply the patch. Thanks!
> 
> Sorry, didn't realize missed SO. You can use below. Thanks.
> Signed-off-by: Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>

Sorry for the delay. Applied now, thanks!
