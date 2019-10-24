Return-Path: <SRS0=l1pt=YR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90590CA9EBC
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 18:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67E9520684
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Oct 2019 18:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571942664;
	bh=vvS8NHgWqzFAvjFh6auB7LQrOacNbGqy2A0HschvZqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wNy8CtRLdV89neNPN8tRv5gw0IuDEGPGKwEIXZCBrHnmKcb+AjlXdehpmFadA41Vm
	 nDSNK41JuO+k6Ih9Bsxup3ict8OV1dwdB+s7z5NGIvOfzKxN0e1erCViwXzDbK/b3Z
	 fH0vfkDXtlrv7+ztjhUjKwTJdlm4TUK4Hlyixhgc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504111AbfJXSoU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Oct 2019 14:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440075AbfJXSoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Oct 2019 14:44:20 -0400
Received: from localhost (unknown [75.104.69.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5798E205F4;
        Thu, 24 Oct 2019 18:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571942658;
        bh=vvS8NHgWqzFAvjFh6auB7LQrOacNbGqy2A0HschvZqU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=csXyKMqTL8c7qWdUUYVj52JXHYhKQZLnDB2HeJkx/bf6DcrVqq6CLVnbaM54L9UTz
         Mf7ZhLnUas0Xi5PkLPhscb4psZL/OgCUBIZGn1c33424Cp99JBuINFdhoinZx8Vj/j
         IeTGBXtV1aa577YUKuvk90tRGhPw/zF+E/5WZfhE=
Date:   Thu, 24 Oct 2019 14:44:08 -0400
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     arnd@arndb.de, johannes@sipsolutions.net, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] rfkill: allocate static minor
Message-ID: <20191024184408.GA260560@kroah.com>
References: <20191024174042.19851-1-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024174042.19851-1-marcel@holtmann.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Oct 24, 2019 at 07:40:42PM +0200, Marcel Holtmann wrote:
> udev has a feature of creating /dev/<node> device-nodes if it finds
> a devnode:<node> modalias. This allows for auto-loading of modules that
> provide the node. This requires to use a statically allocated minor
> number for misc character devices.
> 
> However, rfkill uses dynamic minor numbers and prevents auto-loading
> of the module. So allocate the next static misc minor number and use
> it for rfkill.

As rfkill has been around for a long time, what new use case is needing
to auto-load this based on a major number?

thanks,

greg k-h
