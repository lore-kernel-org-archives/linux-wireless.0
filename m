Return-Path: <SRS0=BUAO=D3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51734C4363A
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Oct 2020 17:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9AA221D6C
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Oct 2020 17:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603215675;
	bh=v1Qm7Vl/Cw24zRlFjV1TGctlBsTtVgZtsEhzooeXYqY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=tI7r46G9bz1SsLvYoVoy3gnCJZfpRRs9QxGv+kRh2Mu8NjoKP6tS7NToc63QIsK4d
	 FlokeNsbDcWWhZZR6Cd3lz4xw6VjRmClJncL++NRtbj20qLdR6LkCgHlDE0s/1kmBG
	 e/rvxhN/esDLGxxxSCt/x/1fJw9e+QOZB9maUrhY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437179AbgJTRlK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Oct 2020 13:41:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395567AbgJTRlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Oct 2020 13:41:10 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D1721D6C;
        Tue, 20 Oct 2020 17:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603215669;
        bh=v1Qm7Vl/Cw24zRlFjV1TGctlBsTtVgZtsEhzooeXYqY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b5TOV8EI/eI2I7okxgAS9McAFzq3u++OS9RUlM9KGCV4QpRYCVVEmWkwZ/T/mJjfH
         e7BsxEH7YFTHVDiqjYXbJvPA2b0BY/ST0aRIam3Poaw0NOXEkfY3WbdTbokhD8Sswe
         309Ey7j7F1GI8U7kX+AnmAeHFoSKqnqPAD8Vx404=
Date:   Tue, 20 Oct 2020 10:41:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     trix@redhat.com
Cc:     mgreer@animalcreek.com, davem@davemloft.net, bianpan2016@163.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH] nfc: remove unneeded break
Message-ID: <20201020104106.10e27a43@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019191500.9264-1-trix@redhat.com>
References: <20201019191500.9264-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 19 Oct 2020 12:15:00 -0700 trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> A break is not needed if it is preceded by a return
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Applied to net, thanks!
