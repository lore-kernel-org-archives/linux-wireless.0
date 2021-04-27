Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9F1C433B4
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Apr 2021 06:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C93561078
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Apr 2021 06:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234556AbhD0G2C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Apr 2021 02:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhD0G2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Apr 2021 02:28:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B6D061078;
        Tue, 27 Apr 2021 06:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619504836;
        bh=Nr3cd+KOt3fMGOex5XWsfAzO5GZwj6JZdEr9kL2YN3s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=luG0kQ6WvnHlUUMWDk1Ql6Oe4O/8x4ZbmH/MJ864bp1Xkgc7t8HPk74wvnM2xh7j5
         a+qulZpYhS2PpeAEj2yLW8oyLjWlZjWII3LqiBCHeKICjsHkQUQ7XYe5ryG5re3u+N
         XjIxxs2biMvuwmh+oKSMAVmBZ7nwnm8D6fbpr6BI=
Date:   Tue, 27 Apr 2021 08:27:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     youling 257 <youling257@gmail.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, ross.schm.dev@gmail.com
Subject: Re: [PATCH 1/1] staging: rtl8723bs: Move wiphy setup to after
 reading the regulatory settings from the chip
Message-ID: <YIeuvZbM8KopcYGG@kroah.com>
References: <20210201152956.370186-2-hdegoede@redhat.com>
 <20210426183406.13055-1-youling257@gmail.com>
 <6dd2cb8b-5540-a410-92d8-f329be98327b@redhat.com>
 <CAOzgRdZF2WyRmGRv=+PehmSbfKDhPp-WYPcLbsuRR92qxmq+bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzgRdZF2WyRmGRv=+PehmSbfKDhPp-WYPcLbsuRR92qxmq+bw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 27, 2021 at 09:34:36AM +0800, youling 257 wrote:
> rtl8723bs v5.2.17 is a external module, i not use staging/rtl8723bs
> driver, rtl8723bs v5.2.17 support build with linux kernel 5.12.

There is not much we can do about external driver code, please work to
fix up the in-kernel driver if there are any gaps in functionality in it
that is preventing you from using it.

thanks,

greg k-h
