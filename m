Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18014C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 11:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D88322086A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 11:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555415293;
	bh=kdqUJhIXHIWk8u9n3PCgk3YXRiSMJZhk4HPokeEsZc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=O7vsqAsK3c2ktMZ3XQKtjyVu6u8drnKcQUNpDvQ18FiPBFuIhyYASgdT/krwlO8T7
	 vEF6qMLi4mQipH4JuKej5C1hWPclkC692rGVAAMv2zL65SrhCQERSAM+vOa5YSjTRI
	 L5/kBbX1pRp1Cu2T41HiLGAHtbE19W2mwlfyT2EM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfDPLrg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 07:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbfDPLrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 07:47:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18E742086A;
        Tue, 16 Apr 2019 11:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555415255;
        bh=kdqUJhIXHIWk8u9n3PCgk3YXRiSMJZhk4HPokeEsZc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UpDcIs3UKaOaMwX6Br5I2LqEJlHQl8AG44AgRjyxAIm7t3KMEh6BVrK9E2j0gXa8k
         uPYweNAPEsx8RiCxqCaURc2CGLdM6lrDgQ44AjU9jpWlQT4RctpRPNF8jP3gHBB1uP
         Djk48aGkQBW5Zzkh8xgfGmS4TwELfE8P9auvapKA=
Date:   Tue, 16 Apr 2019 13:15:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Avoid GFP_KERNEL allocation from
 atomic context.
Message-ID: <20190416111507.GA27902@kroah.com>
References: <1554641923-11503-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554641923-11503-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Apr 07, 2019 at 09:58:43PM +0900, Tetsuo Handa wrote:
> Since wilc_set_multicast_list() is called with dev->addr_list_lock
> spinlock held, we can't use GFP_KERNEL memory allocation.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Fixes: e624c58cf8eb5116 ("staging: wilc1000: refactor code to avoid use of wilc_set_multicast_list global")

No need for so many sha1 characters, this is the canonical length to
use:
	e624c58cf8eb
thanks,

greg k-h
