Return-Path: <SRS0=I2fZ=XI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EC7C49ED7
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 20:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95D23206BB
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Sep 2019 20:58:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0vojTxC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbfIMU6Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Sep 2019 16:58:25 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45874 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfIMU6Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Sep 2019 16:58:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id x3so13739275plr.12
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2019 13:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5NQ2Z6LNT8ek38XfAoo0QwHLpQn3Q4FOSyr9EpBF1YE=;
        b=B0vojTxCen8EvbIOPMq2b3GIAVPZ2OCdulShro3CUe8rZhf4sJl1PBbIsi86gteHrm
         p6irYK9jrE5m3qDvgB367CeYpRvJQmnLD66hu142+lUXr10NXlboB/a+0rqhm5BoiTXF
         xXsKKI21l5qTmAAa9vdxwDkGUnv52kumSUbFBB2oYkn1YNiEPSfV1Ib3Rad9RN6BvtYJ
         pIZRDSR4l43VBGNq6Q83ZVN0tLesBUXn+Q4/kCu7gRN5pzgkoEgSlNtS6JkR7JK/CGRi
         QlaHB9CYkRfvVRokTAWTvZz7zocs9Eu1nVvaF7OnGR1GlGEFVyw710N+VaxB0IpD1VFs
         Jqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5NQ2Z6LNT8ek38XfAoo0QwHLpQn3Q4FOSyr9EpBF1YE=;
        b=GLAjqYOxQapZszq0RvHKcy1BLSAsa/OPeyHaF1CWNn8hJmR2zWoqCZ1EmhxDdq1Dv5
         ZCgK9iASbap06s3ysF4Rx5fhbjS1BGv1XDrVj9PyeAsdpVJ0NRqp1fiKuYpPnnoJKaGe
         tIoVseR0Ua531nSi/aJJXE8VeN6LLagy2C/p+A4n74k3tsetuNIbX3kO9RZmLVIXaIw5
         4HFcsCOR3WKfD+6LJonGJpDFyDB4QbEBN3HmkIkX11jGeRg0ggW+oV7QXLK/OJxvwa83
         tUg9yfVmCvRWtJkYJnT7j+mC0RsLvrFQjyllHpsTd8rX0ZN0kNrUg5HU+S2JbBSAV3Md
         lAQA==
X-Gm-Message-State: APjAAAUGJfJJVQbFTPa05N+4p14qlwk/MAA8Tt/XYQaPZ42jrEID6A38
        s9Xbm3Hy+IBOQsgfphWRtPA=
X-Google-Smtp-Source: APXvYqz1GRLv1tGZbkBPT23Z7We54p3DMOE/1IFB6s0HCbyZuMFCQPwLxRa2Rd1/eCObWxrmPfJkPA==
X-Received: by 2002:a17:902:421:: with SMTP id 30mr52963126ple.105.1568408303941;
        Fri, 13 Sep 2019 13:58:23 -0700 (PDT)
Received: from jprestwo-test.jf.intel.com ([134.134.139.76])
        by smtp.googlemail.com with ESMTPSA id h11sm29507990pgv.5.2019.09.13.13.58.23
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 13 Sep 2019 13:58:23 -0700 (PDT)
Message-ID: <38c222129dd182de4c55e536a89eada7f58a1bf1.camel@gmail.com>
Subject: Re: [PATCH 1/2] nl80211: Add LIVE_ADDR_CHANGE feature
From:   James Prestwood <prestwoj@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Date:   Fri, 13 Sep 2019 13:56:28 -0700
In-Reply-To: <6c85d9b108825939afb84ebc8a708a211f7e2b98.camel@sipsolutions.net>
References: <20190913195908.7871-1-prestwoj@gmail.com>
         (sfid-20190913_220113_419728_36032050) <6c85d9b108825939afb84ebc8a708a211f7e2b98.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Fri, 2019-09-13 at 22:48 +0200, Johannes Berg wrote:
> On Fri, 2019-09-13 at 12:59 -0700, James Prestwood wrote:
> > Add a new feature bit signifying that the wireless hardware
> > supports
> > changing the mac address while the underlying net_device is
> > UP.  Note
> > that this is slightly different from IFF_LIVE_ADDR_CHANGE as
> > additional
> > restrictions might be imposed by the hardware.  Typical
> > restrictions
> > are:
> > 	- No connection is active on this interface, e.g. carrier is
> > off
> > 	- No scan is in progress
> > 	- No offchannel operation is in progress
> 
> Hmm, what do you need this patch for?
> 
> IFF_LIVE_ADDR_CHANGE should be sufficient to discover it?

Because userspace needs to know if this is supported?
IFF_LIVE_ADDR_CHANGE is a private flag... AFAIK userspace has no way of
obtaining this.

Thanks,
James

> 
> johannes
> 

