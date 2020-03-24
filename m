Return-Path: <SRS0=4Kz6=5J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584DDC2BAEE
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 15:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2314020774
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585064549;
	bh=iY0iQy8M8M9PlPZnJFM5YPoDv72kOb7VIAOeqRPiEr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d3ti+evr3OFIuJYDzVLajF8DIQ4fqFOSQgn/V+iBcm7l9JHsWtSaLR+wd+hOM1fwR
	 3TdgqU9xCPn+nSeGOBnF7tetWC4mn+0qNJUPeeVFMjb1VyDD1O6VnxIKxW/3fO/FPm
	 VbrXCkGapH325qybX39MKhTekddY+CMq0GNt5ao4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgCXPmX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Mar 2020 11:42:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727916AbgCXPmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Mar 2020 11:42:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE5A820714;
        Tue, 24 Mar 2020 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585064542;
        bh=iY0iQy8M8M9PlPZnJFM5YPoDv72kOb7VIAOeqRPiEr4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IlLuGC74jPz7CHp6TqNiqQThNKA/sJDDbmlEjIAvKxA6pA5tOSsRUyZ+zAOsV06HO
         TRVl1xNKlH6/YSc6lMm7YGYmF+IR4zkyXm3zSS4QLK8YAR9aKJ4O+fMbYQQIUglCtk
         HymrUB7OUvyj7O9y/47EZr41SeYXXRGs3mYuK1+0=
Date:   Tue, 24 Mar 2020 16:42:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bastien Nocera <hadess@hadess.net>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH resend 3] staging: rtl8188eu: Add rtw_led_enable module
 parameter
Message-ID: <20200324154219.GB2513347@kroah.com>
References: <97d2ef68a6bcb7d1ece978eef6315e95732ca39d.camel@hadess.net>
 <20200324152040.GA2511658@kroah.com>
 <73723ab7d2c64c7d5ce7e2ae05b857c965824168.camel@hadess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73723ab7d2c64c7d5ce7e2ae05b857c965824168.camel@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 24, 2020 at 04:21:47PM +0100, Bastien Nocera wrote:
> On Tue, 2020-03-24 at 16:20 +0100, Greg Kroah-Hartman wrote:
> > On Tue, Mar 24, 2020 at 11:36:00AM +0100, Bastien Nocera wrote:
> > > Make it possible to disable the LED, as it can be pretty annoying
> > > depending on where it's located.
> > > 
> > > See also https://github.com/lwfinger/rtl8188eu/pull/304 for the
> > > out-of-tree version.
> > > 
> > > Signed-off-by: Bastien Nocera <hadess@hadess.net>
> > > ---
> > >  drivers/staging/rtl8188eu/core/rtw_led.c      | 6 ++++++
> > >  drivers/staging/rtl8188eu/include/drv_types.h | 2 ++
> > >  drivers/staging/rtl8188eu/os_dep/os_intfs.c   | 5 +++++
> > >  3 files changed, 13 insertions(+)
> > 
> > Why was this resent?  Didn't I just reject this?
> 
> It wasn't resent, it's the same mail you already answered.

Ah, slow mailing lists, sorry :)

greg k-h
