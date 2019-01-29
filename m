Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37D3C282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 16:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C57621871
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 16:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548778198;
	bh=wvyQFKfJO8h2+Qfj+KcQiRq/qJduUBGTYLQLgQCTpjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FzLi01eNy9WH9rXRMchUaV9kaj8LmKLT129+WQUfybNr6R9gnIeyqsFkKsm+q4EV4
	 jIDBUez/jVrX2tqkZ2xte1WFZEJGEr0zuRlY0l31+3E6p/G1WFu2Tk5l+9MjN0L5OG
	 b34yRidO2xLrYYJupUpn0pho0Ulzs3IlcR8EzJqs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfA2QJ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 11:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbfA2QJ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 11:09:57 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6521F21852;
        Tue, 29 Jan 2019 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548778196;
        bh=wvyQFKfJO8h2+Qfj+KcQiRq/qJduUBGTYLQLgQCTpjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdywgYSu4I334/OyHfCzQF56awpNN7hD0iLg1YznNHBRjE5c+eXMx1RsUhk/lwS7+
         ddw3LWCyS1XydBf6DlW9uxEbeXl1WPL3KqJ0b+zVP65lO6eepFtP9IiGP/ncOZkrQu
         u07WMCWpSZkuxMkbkCTyTNg60IXUqeU0dVh8RHi4=
Date:   Tue, 29 Jan 2019 17:09:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sid Hayn <sidhayn@gmail.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: Re: [PATCH 4.20.x 0/7] mt76x0 fixes for 4.20 stable
Message-ID: <20190129160954.GB20209@kroah.com>
References: <1548160717-4059-1-git-send-email-sgruszka@redhat.com>
 <CAM0KTbBz4hLWuN5oAGJV9rXEGuHP1UDPsL2fYaKJA6pRJG1MDA@mail.gmail.com>
 <20190129094334.GC20645@kroah.com>
 <CAM0KTbBhQ+NMS814A3dWC2P6ttn78pwTCMeQ2LOhhPdbMAcecA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0KTbBhQ+NMS814A3dWC2P6ttn78pwTCMeQ2LOhhPdbMAcecA@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 29, 2019 at 10:55:55AM -0500, Sid Hayn wrote:
> Thanks for the responses, I know how hard you all work.  From my
> perspective I cannot tell the difference between missed and just in
> queue.

Given that it was only a week, normally it takes longer, so just be
patient.

> Is there a patchwork page for patches targeting stable, or is the
> process there too complex for patchwork?  Right now I only see the
> mailing list and the stable queue git tree and no other idea on how to
> see status.

There is no other way, sorry.  If after 2 weeks we don't pick something
up, and it's not the week after -rc1 happened, just email asking what
the status is, it's not a problem.

thanks,

greg k-h
