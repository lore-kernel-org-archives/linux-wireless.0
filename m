Return-Path: <SRS0=BuOi=7H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCD97C433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 11:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC7E20723
	for <linux-wireless@archiver.kernel.org>; Mon, 25 May 2020 11:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590405031;
	bh=dNwka+OZrQ/9SbGW+ISAJA+FmBHPDzDTpm4boGMGhqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DSQZkyD1ooCHd/OUQBZqfbqvxbC4n8hYavN69d8K7dw+rN3A9/YJtZP10uug3/UEF
	 b68jFTG5mBO1aDMMssPiFfcBHZ+SYY3FASMgqAAES/8p9hXJ7t4D6moCDaibglNgmJ
	 2xFamTcy8OPnqI2sM/gMUXwyWOz06ugAeMVWUOsw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390005AbgEYLKa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 May 2020 07:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389926AbgEYLK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 May 2020 07:10:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B083520723;
        Mon, 25 May 2020 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590405029;
        bh=dNwka+OZrQ/9SbGW+ISAJA+FmBHPDzDTpm4boGMGhqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N2ce1n0ARjGK23iQAxS/2CNKWJtUq/OLPYDDl3uxf+kwyxsoqH33xcncLoe/0O/3Z
         P/zdWq7FLB44PURPWUwldMyLS7st81+O61/lwZN9vPZ0b+wByO1EiOw5TAaO251Vw/
         YYNJdRECa7nnj4O9CAvUpGf0J1gswFambZz+U2BA=
Date:   Mon, 25 May 2020 13:10:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        stable@vger.kernel.org,
        syzbot+fd5332e429401bf42d18@syzkaller.appspotmail.com
Subject: Re: [PATCH] cfg80211: fix debugfs rename crash
Message-ID: <20200525111026.GA279021@kroah.com>
References: <20200525113816.fc4da3ec3d4b.Ica63a110679819eaa9fb3bc1b7437d96b1fd187d@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525113816.fc4da3ec3d4b.Ica63a110679819eaa9fb3bc1b7437d96b1fd187d@changeid>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, May 25, 2020 at 11:38:17AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Removing the "if (IS_ERR(dir)) dir = NULL;" check only works
> if we adjust the remaining code to not rely on it being NULL.
> Check IS_ERR_OR_NULL() before attempting to dereference it.
> 
> I'm not actually entirely sure this fixes the syzbot crash as
> the kernel config indicates that they do have DEBUG_FS in the
> kernel, but this is what I found when looking there.
> 
> Cc: stable@vger.kernel.org
> Fixes: d82574a8e5a4 ("cfg80211: no need to check return value of debugfs_create functions")
> Reported-by: syzbot+fd5332e429401bf42d18@syzkaller.appspotmail.com
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 341402b4f178..ce024440fa51 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -142,7 +142,7 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
>  	if (result)
>  		return result;
>  
> -	if (rdev->wiphy.debugfsdir)
> +	if (!IS_ERR_OR_NULL(rdev->wiphy.debugfsdir))
>  		debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
>  			       rdev->wiphy.debugfsdir,
>  			       rdev->wiphy.debugfsdir->d_parent, newname);

I missed that d_parent was being accessed, sorry about that.  This looks
good to me:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
