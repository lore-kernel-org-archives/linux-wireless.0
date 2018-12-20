Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8CAC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEB762186A
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 12:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545309058;
	bh=ULqzZuzNaLe34v8f9sY6Yvp7qT1vFQeKYmJvGewT82A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=tLcOtvHUf4ZRwVR+vHutKoQdfwX3yPsY6d3T8ANUq4FkWi2uk86mNLOEKRjk8Q2Am
	 Jcbczt7y6kY668CCXNvwM/YR0ssJzfMQM4DraM/c2KKF/OJTrd1fXwkGdFWS9ri/wH
	 uHFiWJG3ZkRYJ8ZXUSpbBrB8shTPe31HfvP0ukBQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbeLTMa6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:30:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728172AbeLTMa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 07:30:58 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8B9621852;
        Thu, 20 Dec 2018 12:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545309057;
        bh=ULqzZuzNaLe34v8f9sY6Yvp7qT1vFQeKYmJvGewT82A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkLu61wuhVbudgl3vPPk7/aYb7mxPXPujQvXPgIX7BUvcNFnr2JpO9F7ZfL2l3kSF
         tZk42tyCZZds92s2aj4Ubgb3y24s/Gj0EVTua154PiI+7UiIRT0UsDJPVdknkPXx26
         nJeb5Fiq8DI7kzMeNEJingTnqzgsmRxO/gC0BLSI=
Date:   Thu, 20 Dec 2018 13:30:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     stable@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sid Hayn <sidhayn@gmail.com>
Subject: Re: [PATCH 4.19] mt76x0: mark 802.11w as supported
Message-ID: <20181220123055.GC17138@kroah.com>
References: <20181220114701.GA8660@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220114701.GA8660@redhat.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 20, 2018 at 12:47:07PM +0100, Stanislaw Gruszka wrote:
> commit 0ae976a11b4fb5704b597e103b5189237641c1a1 upstream.
> 
> This is one line hw feature backport from 0ae976a11b4f ("mt76x0: init
> hw capabilities"), which add also other different features, however
> those are not supported in 4.19.
> 
> 802.11w is supported by mac80211 and mt76x0u driver in 4.19 correctly
> fall-back to software encryption when 802.11w ciphers are used.
> 
> Without the patch we fail to associate with WPA3 APs, so this is
> considered as fix.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> [remove marking non-working features on 4.19, make topic correspond the change]
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x0/init.c | 1 +
>  1 file changed, 1 insertion(+)

What bug is this fixing?  This never worked before, so this feels like
it is adding a new feature.

thanks,

greg k-h
