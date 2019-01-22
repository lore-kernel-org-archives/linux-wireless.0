Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7564DC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3509321726
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 20:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548189829;
	bh=FPrPaw5sOKBv2EszEW1iWbFcEMTr83cFvl+dLpsxvls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tErlG6XF2U6XmRyv/JMfRis01wt2UKgM+7eXMlVhYbMi3cBYlcVH04+hJPVBpGdSH
	 xvHqmlKlIQPfheB4VZm4Ow4hyK89qGEWtVnp6Ylc57vrGXzfJyvF4H+9xXmYfufxCF
	 q+Nxj6vYkvcFuizYq4SNjcmZ/v84+p/Fe71ibWjs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfAVUno (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 15:43:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbfAVUnn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 15:43:43 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCA0021726;
        Tue, 22 Jan 2019 20:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548189823;
        bh=FPrPaw5sOKBv2EszEW1iWbFcEMTr83cFvl+dLpsxvls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P16Np6dqJlI9XSe+AyKdzMOMsLj/CuZBWL2rZ00jGTmrz13WBHUUavsZuzxRmmer4
         qnteSwse1fFAgHNkjUxyRremM37yO8H7YIV15a+KX7sxkNd+TuswlBP123B268hcvi
         vmmsbcKUIb0l2/7NxOWxh1SpMXOQ2RhOsP51tFYM=
Date:   Tue, 22 Jan 2019 21:43:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-kernel@vger.kernel.org, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH] brcm80211: no need to check return value of
 debugfs_create functions
Message-ID: <20190122204340.GA30535@kroah.com>
References: <20190122152151.16139-32-gregkh@linuxfoundation.org>
 <530d2424-d679-c81a-9d11-02b2d7631bea@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530d2424-d679-c81a-9d11-02b2d7631bea@broadcom.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 22, 2019 at 09:07:48PM +0100, Arend Van Spriel wrote:
> The prefix should be 'brcmsmac'.
> 
> On 1/22/2019 4:21 PM, Greg Kroah-Hartman wrote:
> > When calling debugfs functions, there is no need to ever check the
> > return value.  The function can work or not, but the code logic should
> > never do something different based on this.
> 
> I could argue that if above is true it would be better to make the debugfs
> function return void, but I won't ;-p

I would really want to do that, but sometimes you need that return value
to pass to other debugfs functions :(

> In start_creating() the parent dentry is indeed checked for IS_ERR() so...
> 
> Acked-by: Arend van Spriel

thanks for the review!

greg k-h
