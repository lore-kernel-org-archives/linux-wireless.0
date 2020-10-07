Return-Path: <SRS0=5fY4=DO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0254EC4363D
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Oct 2020 10:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7BBF212CC
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Oct 2020 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602068078;
	bh=wOytTXNCU8gtZ+ntCxQtyM7YOuGQFzHEkacmPvyiVVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=vp4fNp8QAcnINj+LP8ejc8OdJ71aVq3rHT+eSyLVfqrjVF0Ik055GE0DK3oYMPsBS
	 cbwjm7nk0Qc6uOxREcBOJZ/E6WElt51l9WOodKcE6ffrygn3djGo4Vq6NrwxqW0SGh
	 klLLZ9fA6mE/fSZORmh7ysYgaDx/NnsiOgRMN+OU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgJGKyc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Oct 2020 06:54:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbgJGKyb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Oct 2020 06:54:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DAC4212CC;
        Wed,  7 Oct 2020 10:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602068069;
        bh=wOytTXNCU8gtZ+ntCxQtyM7YOuGQFzHEkacmPvyiVVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hBQtrv+04atIlx+6BcY4bd16tOCql3kl/BA+KjY/+fm2rBldCMlR7fAGLcRD4W6vN
         qhLpvXe5uMerVjjfMWrzrXuwYZzSunvxF+41BlVFnBozqFjp1oIkSx6dfxyqwYPnJP
         reqxG4DrtcZeO8eYZSwdOq0zCw7YZ6LpwouKpBZ0=
Date:   Wed, 7 Oct 2020 12:55:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 0/7] wfx: move out from the staging area
Message-ID: <20201007105513.GA1078344@kroah.com>
References: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201007101943.749898-1-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 07, 2020 at 12:19:36PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> I think the wfx driver is now mature enough to be accepted in the
> drivers/net/wireless directory.
> 
> There is still one item on the TODO list. It is an idea to improve the rate
> control in some particular cases[1]. However, the current performances of the
> driver seem to satisfy everyone. In add, the suggested change is large enough.
> So, I would prefer to implement it only if it really solves an issue. I think it
> is not an obstacle to move the driver out of the staging area.
> 
> In order to comply with the last rules for the DT bindings, I have converted the
> documentation to yaml. I am moderately happy with the result. Especially, for
> the description of the binding. Any comments are welcome.
> 
> The series also update the copyrights dates of the files. I don't know exactly
> how this kind of changes should be sent. It's a bit weird to change all the
> copyrights in one commit, but I do not see any better way.
> 
> I also include a few fixes I have found these last weeks.
> 
> [1] https://lore.kernel.org/lkml/3099559.gv3Q75KnN1@pc-42

I'll take the first 6 patches here, the last one you should work with
the wireless maintainers to get reviewed.

Maybe that might want to wait until after 5.10-rc1 is out, with all of
these changes in it, making it an easier move.

thanks,

greg k-h
