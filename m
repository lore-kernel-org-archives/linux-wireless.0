Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A4BC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FCA206B7
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfBKJwr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:52:47 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:35493 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbfBKJwr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:52:47 -0500
Received: by mail-wm1-f52.google.com with SMTP id t200so16005642wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Feb 2019 01:52:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=59iM/q78SRw0Hc1UZbNJdNEBQXq3Xi5dxoN2DruQg+0=;
        b=Pyc1BxABdLfSH7ZvjOyqWwcrzlQAbxYrbNYcwdawRlEyQ6rlD7F9YE7NPqOMewW+Zw
         0zaboSshRbB6z7oNWF39w7TsCWCli26o97z8nNrEyIlsEgQzAIji0vlXhBhPRJcht9bs
         uaWiyc5Xf2nJZ/5Zz3d0m9dgpBNZAlnvygZCwlUmoNjYG3+kSA/A6z0ozzc2QIvRMM2b
         pz0snHT5AvAo7DkGaZ60jXnS2/J4YLI8Qnimin/FfOfOA10vdHOBXZc3Sn5pQsrxxsVn
         bzIeaBKStbOo9MVBEDO+HNV2iYPKcsPaJOh3qoBqqHBNJgA4GctnCVVTxJTVLCUOu9GZ
         ubjw==
X-Gm-Message-State: AHQUAubj+TpKoTi0DkyFIYegMvEPAjqY6c7cA/yIbtsVLftMDD+uvP8b
        vc6q9GyrttbaRlP/VVW4GSQnww==
X-Google-Smtp-Source: AHgI3IZsAYalmZbVaT6cX2e3n4qNqXhln5RAYeAc1zJ/Ks4kfSdLFMPRVYap+zENIHJb3NW0EAuIeg==
X-Received: by 2002:adf:edca:: with SMTP id v10mr2128860wro.313.1549878765154;
        Mon, 11 Feb 2019 01:52:45 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id c1sm10980387wrf.20.2019.02.11.01.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Feb 2019 01:52:44 -0800 (PST)
Date:   Mon, 11 Feb 2019 10:52:42 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190211095241.GC3467@localhost.localdomain>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <20190210092943.GA2913@redhat.com>
 <307601671.418864.1549816737996@email.ionos.de>
 <CAJ0CqmXL_PXf0LuFOnshbYZb=j_KEHyfmV5wpHHW5HXcexhDJA@mail.gmail.com>
 <20190211075056.GB6292@redhat.com>
 <32eebaf4-f728-17a9-62e0-8c694ab83f86@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32eebaf4-f728-17a9-62e0-8c694ab83f86@i2se.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Hi,
> 
> Am 11.02.19 um 08:50 schrieb Stanislaw Gruszka:
> > On Sun, Feb 10, 2019 at 05:52:30PM +0100, Lorenzo Bianconi wrote:
> >> Anyway we will need to avoid SG since dwc_otg controller does not support it
> 
> this isn't correct. AFAIK the dwc2 host driver doesn't implement it,
> which doesn't mean the controller does not support it.

This is what I meant :)

Regards,
Lorenzo

> 
> Stefan
> 
> > What does it mean the dwc_otg does not support SG ? Please be more specific.
> >
> > Stanislaw
> 
