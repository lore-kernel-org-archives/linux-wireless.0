Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC95C433DB
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Mar 2021 18:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E5D6192E
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Mar 2021 18:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhC2S6Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Mar 2021 14:58:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231468AbhC2S6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Mar 2021 14:58:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C95E76191B;
        Mon, 29 Mar 2021 18:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617044284;
        bh=c/s9VChyW+PWZcaM8NTQh/9X1+6v/QSeKT0dp32MvX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdSoptfqmS51C5yohMF4Ery+8npmlpIBFPKOsRYfVGQGmjFOt7iAsGNaONA/rytjU
         48sJiJzE4sFKwDHQFNHwoRoxLf8Yn83gGOYrdatSSScHKQlfgZPAX9McuarcwJ/sCi
         bgRTB6kFartuSl2ozV7UPbQ5rpBeO/fzFLAbfyO8=
Date:   Mon, 29 Mar 2021 20:58:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alaa Emad <alaaemadhossney.ae@gmail.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>,
        syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
Subject: Re: [PATCH] wireless/nl80211.c: fix uninitialized variable
Message-ID: <YGIjOZauy9kPwINV@kroah.com>
References: <20210329163036.135761-1-alaaemadhossney.ae@gmail.com>
 <YGIaaezqxNmhVcmn@kroah.com>
 <CAM1DhOgA9DDaGSGFxKgXBONopoo4rLJZheK2jzW_BK-mJrNZKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM1DhOgA9DDaGSGFxKgXBONopoo4rLJZheK2jzW_BK-mJrNZKQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 29, 2021 at 08:41:38PM +0200, Alaa Emad wrote:
> On Mon, 29 Mar 2021 at 20:20, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, Mar 29, 2021 at 06:30:36PM +0200, Alaa Emad wrote:
> > > Reported-by: syzbot+72b99dcf4607e8c770f3@syzkaller.appspotmail.com
> > > Signed-off-by: Alaa Emad <alaaemadhossney.ae@gmail.com>
> >
> > You need to provide some changelog text here, I know I can not take
> > patches without that, maybe the wireless maintainer is more flexible :)
> >
>  you mean explain what i did , right?

Yes, explain why this change is needed.

thanks,

greg k-h
