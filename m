Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC15C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 13:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D1912098A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 13:04:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D1912098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lemonage.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbeJRVEx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 17:04:53 -0400
Received: from smtp2.goneo.de ([85.220.129.33]:44092 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbeJRVEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 17:04:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.goneo.de (Postfix) with ESMTP id AA70A24188A;
        Thu, 18 Oct 2018 15:03:53 +0200 (CEST)
X-Virus-Scanned: by goneo
Received: from smtp2.goneo.de ([127.0.0.1])
        by localhost (smtp2.goneo.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id h0VxCrj-4Lb7; Thu, 18 Oct 2018 15:03:52 +0200 (CEST)
Received: from lem-wkst-02.lemonage (hq.lemonage.de [87.138.178.34])
        by smtp2.goneo.de (Postfix) with ESMTPSA id 0143723F6CA;
        Thu, 18 Oct 2018 15:03:51 +0200 (CEST)
Date:   Thu, 18 Oct 2018 15:03:46 +0200
From:   Lars Poeschel <poeschel@lemonage.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Samuel Ortiz <sameo@linux.intel.com>, Jiri Slaby <jslaby@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] nfc: pn533: add UART phy driver
Message-ID: <20181018130346.GA3975@lem-wkst-02.lemonage>
References: <20181017102037.28537-1-poeschel@lemonage.de>
 <20181017115357.GC32302@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017115357.GC32302@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 17, 2018 at 01:53:57PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Oct 17, 2018 at 12:20:35PM +0200, Lars Poeschel wrote:
> > This adds the UART phy interface for the pn533 driver.
> > The pn533 driver can be used through UART interface this way.
> > It is implemented as a tty line discipline.
> 
> Why not use the serdev interface instead?

Maybe because the most obivious is not obivious enough. ;)
I did not know about serdev before. Thank you very much for this! I am
almost finished migrating to serdev and everything is much cleaner and
more simple now!

I will post a follow-up with all your other comments addressed.

Thanks,
Lars
