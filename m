Return-Path: <SRS0=pJT4=WB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A13BCC32751
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Aug 2019 12:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FF4820651
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Aug 2019 12:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565008965;
	bh=4g/NKSoxT0IZ8Hgz2hRFBjN9jUjIXKzMS18vG1ZGZMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=girnRzWOV8pBYPRgqusJTug3xbtBCpkinHXEEQ+sa3O9vN50icbjrALRB49kMD0A/
	 N/4qF61j7TSI/3+cHjfN8jnUgTSkrJjB2AaiUEyN+BTmsHYMYjIq3FNRmfgXLa1Whi
	 gkBp1pn7ACMnvbulitEWn7p6YgE0EFjDd1rpda4c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfHEMml (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Aug 2019 08:42:41 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43124 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfHEMml (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Aug 2019 08:42:41 -0400
Received: by mail-lj1-f193.google.com with SMTP id y17so54620050ljk.10;
        Mon, 05 Aug 2019 05:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QIJow21qulI378sxhe255cpiCMd56gmlR3Hpa4iMy3M=;
        b=CqyCGSY3hq6AE4dkrFPoBomjq2822pffvWmLnfwYo3m+6uD30s0pyn3P+0geZYniQ1
         bte2ylNYjPub5N/4utOunrV2iO/Oh0BQEaDrrhe8ZpjNYdpdFAaSEW/XXjyJ9JKPryvg
         aMLU50X0LvQzFvZ6wZP8/ZKGOCk+EcB4lL3ya5FpmyB/oIYXBvEpzs8nSsF7eeymRFT3
         2kK+SIi2WTi4UVe32LbMMulcBeB/GbXEFoKWaBVrR8dxq7KCJ1pRaqtDF3HuqEzizgd3
         Fjw4gujSOzur5MUDM80wcVhBi5Oi9JUJghaR9vTZs3lUr+qRIcE9lBqCGPDwRY8KxOSA
         jL6A==
X-Gm-Message-State: APjAAAVpd2CZDesfRSv8s8rkueZmVSo6g3tm7OaeCnmRaRBqLzOqca0r
        ow4+FMt3ojzIo1NhuNDOCM1rdY0xfys=
X-Google-Smtp-Source: APXvYqxPHN7NT4ABbbFUVFxxIIPpGLP/KWFqrEnIzaNd7ZqIBL3Z2UHCZYALX/XjeYllFU93Yj7d7A==
X-Received: by 2002:a2e:89d0:: with SMTP id c16mr76545659ljk.219.1565008958804;
        Mon, 05 Aug 2019 05:42:38 -0700 (PDT)
Received: from xi.terra (c-51f1e055.07-184-6d6c6d4.bbcust.telenor.se. [85.224.241.81])
        by smtp.gmail.com with ESMTPSA id s7sm17282780lje.95.2019.08.05.05.42.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 05:42:38 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92)
        (envelope-from <johan@kernel.org>)
        id 1hucJw-0006V4-T1; Mon, 05 Aug 2019 14:42:36 +0200
Date:   Mon, 5 Aug 2019 14:42:36 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PING 2] [PATCH v5 1/7] nfc: pn533: i2c: "pn532" as dt
 compatible string
Message-ID: <20190805124236.GG3574@localhost>
References: <20190111161812.26325-1-poeschel@lemonage.de>
 <20190228104801.GA14788@lem-wkst-02.lemonage>
 <20190403094735.GA19351@lem-wkst-02.lemonage>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190403094735.GA19351@lem-wkst-02.lemonage>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Apr 03, 2019 at 11:47:35AM +0200, Lars Poeschel wrote:
> Second Ping.

> On Thu, Feb 28, 2019 at 11:48:01AM +0100, Lars Poeschel wrote:
> > A gentle ping on this whole patch series.

> > On Fri, Jan 11, 2019 at 05:18:04PM +0100, Lars Poeschel wrote:
> > > It is favourable to have one unified compatible string for devices that
> > > have multiple interfaces. So this adds simply "pn532" as the devicetree
> > > binding compatible string and makes a note that the old ones are
> > > deprecated.
> > > 
> > > Cc: Johan Hovold <johan@kernel.org>
> > > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

You may want to resend this series to netdev now. David Miller will be
picking up NFC patches directly from there.

Johan
