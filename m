Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BECEC43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 09:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19DF120657
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 09:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546679777;
	bh=ZoCuLCHA5VaZ+cWn4YW/SzENXYvArZ0007KJHY5Wwr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QWdLgj3nbFdetijawm8A/iSFJscPHg81og9ojgVJEL61r6I+556IJRy1hr1DSKDSo
	 hVPFgelJP/S8juLulPlis9GQz0uN9tFzpzF0brNPz24sz1oK2NQOJaYOHm1+tX1olR
	 nOwsd9PFbMDDWRXTqz48TDgRhuX3ciQZMEjtLI7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfAEJQN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 04:16:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:45382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfAEJQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 04:16:12 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F5620657;
        Sat,  5 Jan 2019 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546679772;
        bh=ZoCuLCHA5VaZ+cWn4YW/SzENXYvArZ0007KJHY5Wwr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XiiP1Bo9E79UykZM3NLjHkiRMa1/xdIbYRHKRAkRQX+TLMSB8wahTAL2T9ODzEyVj
         zgLj6Cb0+Rfth1eQmk/4jpdsbzoMG5iCFEO86vB1Q+L/v9nZGMsFCcR0weNO2EWA4g
         Kyp7+buKxSUDf/j5wYY+8Rrwx+4cDGH5z7qRhblE=
Date:   Sat, 5 Jan 2019 10:16:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?iso-8859-1?Q?J=FAlius?= Milan <jmilan.dev@gmail.com>
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        ajay.kathat@microchip.com, linux-wireless@vger.kernel.org,
        adham.abozaeid@microchip.com
Subject: Re: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190105091604.GA6126@kroah.com>
References: <20190105091025.GA28917@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190105091025.GA28917@localhost.localdomain>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Jan 05, 2019 at 10:10:25AM +0100, Július Milan wrote:
> Fixes the following sparse warnings:
> 
> drivers/staging/wilc1000/host_interface.c:2360:30: warning:
>  incorrect type in assignment (different base types)
>     expected restricted __le32 [addressable] [assigned] [usertype] frame_type
>     got restricted __le16 [usertype] <noident>
> 
> Fixes: 147ccfd451024 ("staging: wilc1000: handle mgmt_frame_register ops from cfg82011 context")
> Signed-off-by: Július Milan <jmilan.dev@gmail.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What changed from v1?  Always list that below the --- line, as the
documentation says to do.

Please fix up in your v3 submission :)

greg k-h
