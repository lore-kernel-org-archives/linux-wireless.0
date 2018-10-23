Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24FACC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA99A20651
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:35:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNNvY1W7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA99A20651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbeJWW6q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbeJWW6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 18:58:45 -0400
Received: from localhost (unknown [185.7.230.214])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F37320651;
        Tue, 23 Oct 2018 14:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540305304;
        bh=Q/qQE6a7Du+EIAEEcdrCCjKJuypGR/JpxHcqKubpBlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNNvY1W76yEVSpavgmMjlCREgxuJV2OQiiSvKtoTxiF3pZkygeX+cCMhR4dAVSEWM
         zg1HlGAOaP2wabYO766dWz4ZbBdfw9I4Pq7tIchxRya+w7Tp/MzPrMs2qeSJa9ZlH/
         KRbFoK7dRvaxtO4WQ7Cb/zUErpvdglcnaUrLTpcE=
Date:   Tue, 23 Oct 2018 15:34:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Is Fixes line enough?
Message-ID: <20181023143455.GA25771@kroah.com>
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 23, 2018 at 09:05:20AM -0500, Larry Finger wrote:
> Greg,
> 
> A question has come up on the linux-wireless ML. If a patch has a "Fixes"
> line, is that sufficient to get it flagged as a patch in Stable, or is a
> "Cc: Stable" line also needed?

No, a "Fixes" line is not sufficient enough, stable@ will get the
attention of my scripts properly and will always be looked at.
Sometimes I look at the fixes: tag, if I have nothing else to do (not
something that's happened in the past few months), and sometimes Sasha's
scripts will pick up on that tag, but not always.

So to be sure, always use cc: stable@ like the stable_kernel_rules.txt
file says to do.

thanks,

greg k-h
