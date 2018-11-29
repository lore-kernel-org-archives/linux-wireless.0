Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B95DC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 12:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 132F320834
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 12:50:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="yQoS8HG7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 132F320834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbeK2X4K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 18:56:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbeK2X4K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 18:56:10 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07DEB2081B;
        Thu, 29 Nov 2018 12:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543495854;
        bh=CoWIQdkh4cSKof7BAPcsWUpNDNDDV/Do0O15Xd9SLMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yQoS8HG7M6EJneJYIkL9dxEqhFBOKh79IAYhOi9+1+4qFw8800ZdE12Gzrf2/uHQM
         QanqOyPqKcYvzx16Q2TX2yEjBizVWkRICJXMVtrRVxuuPNsjBczEZbeAFkOqHsWYKc
         J6q49EwJQNcfnR8NxxBWlZve5tkQgqqieZ+6zrrY=
Date:   Thu, 29 Nov 2018 13:50:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fix for memory leak in the wireless extensions layer
Message-ID: <20181129125052.GL3149@kroah.com>
References: <e0ce06aa-9a9a-d763-4b29-57e976dc1cc4@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0ce06aa-9a9a-d763-4b29-57e976dc1cc4@lwfinger.net>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 31, 2018 at 01:49:21PM -0500, Larry Finger wrote:
> Greg,
> 
> Is the fix for a memory leak in the wext compat layer queued for stable? It
> is in kernel:HEAD as commit 848e616e66d4592fe9afc40743d3504deb7632b4
> ("cfg80211: fix wext-compat memory leak")
> 
> I just receiv3ed a complaint about a leak for a system that is running
> Ubuntu's kernel 4.19.

That would be very odd as commit
848e616e66d4592fe9afc40743d3504deb7632b4 is in 4.19, it was in 4.19-rc7.

> Unfortunately, this commit has a "fixes" line, but not a Cc for Stable.

It could have gone into the 4.18-stable tree, but that is now
end-of-life, sorry.

greg k-h
