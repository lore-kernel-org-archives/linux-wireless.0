Return-Path: <SRS0=4Kz6=5J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204B6C43331
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 15:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E714C2080C
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585063244;
	bh=fEhQh4PlVnifiVAaye+uPmKZQi7jjOmksH5ziSoYnC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oy1XpMSIGgb35efeVuPh0Uli8z6T+jVzEJf492uBlL0AuTdHYHnTMcJ/x7bKbQn0r
	 vf+uFvmMDv99M3a6fz+jCR9syPUWL9ShsuUXiW3ZK46pAyMw0RZ45lRwXSVWx3wAgz
	 W86zYBXttKp2BaZPd2XJ9Fq9L4umlhwa2ahyqQOc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgCXPUn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Mar 2020 11:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727547AbgCXPUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Mar 2020 11:20:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2A3D20788;
        Tue, 24 Mar 2020 15:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585063242;
        bh=fEhQh4PlVnifiVAaye+uPmKZQi7jjOmksH5ziSoYnC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d5iDaKj/9VarNgXC/LNohPOLOj6QCax66vnIxTWbcQl7h0moGh6EMSNfreVz4cc8x
         IukjG8ANgvFo+FnJ6Wv5PUh+nhjTJOxKoGHkeamoMrwz8hHdrk8S0+sRS4SmrwB2aY
         fJ5yMiQDMpne2505fKcl2KOotFpkMCbD6bSX/2aE=
Date:   Tue, 24 Mar 2020 16:20:40 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bastien Nocera <hadess@hadess.net>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH resend 3] staging: rtl8188eu: Add rtw_led_enable module
 parameter
Message-ID: <20200324152040.GA2511658@kroah.com>
References: <97d2ef68a6bcb7d1ece978eef6315e95732ca39d.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97d2ef68a6bcb7d1ece978eef6315e95732ca39d.camel@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 24, 2020 at 11:36:00AM +0100, Bastien Nocera wrote:
> Make it possible to disable the LED, as it can be pretty annoying
> depending on where it's located.
> 
> See also https://github.com/lwfinger/rtl8188eu/pull/304 for the
> out-of-tree version.
> 
> Signed-off-by: Bastien Nocera <hadess@hadess.net>
> ---
>  drivers/staging/rtl8188eu/core/rtw_led.c      | 6 ++++++
>  drivers/staging/rtl8188eu/include/drv_types.h | 2 ++
>  drivers/staging/rtl8188eu/os_dep/os_intfs.c   | 5 +++++
>  3 files changed, 13 insertions(+)


Why was this resent?  Didn't I just reject this?

greg k-h
