Return-Path: <SRS0=ssZ+=5L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C6DC43331
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 14:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F147F2076A
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585234682;
	bh=VlIH/HbbzacO7WTaoFZuFZaSaDMas5cEiQwSW69sMv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=t3iJAWj8glYBcUy3HFwVO4sq/qYjmNKb0qgChu97D2yvangkgJYKTrS5InYB2SR6o
	 o0HMSv1Gy9L2XGBPHqWvmvE/nSbktphMyr73TCKArBjWiUKK4FqwmKUH38d9CYIwre
	 eEiZ0BsexBYoYIGOgC65uZDzdScIWlSFPwoXCykc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgCZO6B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCZO6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Mar 2020 10:58:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABBCF206F6;
        Thu, 26 Mar 2020 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585234679;
        bh=VlIH/HbbzacO7WTaoFZuFZaSaDMas5cEiQwSW69sMv8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pVCQxe9ftRdz7c+ZdUayWnpTe9G3AT69tTWwWK6lz1J/l76DXdBcMvZVD+CCARHbq
         o+ZVwJyjp7JOLRNft+EdhrmzqiRZkAKR1OifPytPbrhYpvRY3h0ZCJm0jpguf5HVep
         +4GRtJk4wTjvacfFTnAN8/hm7RQO0hAfYQP6uEv0=
Date:   Thu, 26 Mar 2020 15:57:55 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     lkml@sdf.org, Adham.Abozaeid@microchip.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wilc1000: Use crc7 in lib/ rather than a private copy
Message-ID: <20200326145755.GA1526831@kroah.com>
References: <20200322120408.GA19411@SDF.ORG>
 <2315a030-75ad-0383-3aa3-25528d2cd29a@microchip.com>
 <20200323064558.GC19411@SDF.ORG>
 <48611e28-5a55-ab05-3865-71992a5be327@microchip.com>
 <20200323141422.GA3769@SDF.ORG>
 <c084bee0-9b3a-631d-5e68-b38775531bac@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c084bee0-9b3a-631d-5e68-b38775531bac@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 26, 2020 at 02:54:41PM +0000, Ajay.Kathat@microchip.com wrote:
> Hi Greg,
> 
> I just noticed this patch is not applied to staging. I suspect, its not
> picked because not sent to devel@driverdev.osuosl.org and 'staging' is
> missing from subject.

That's a very good reason for me to have never seen it, how else would I
have known to take it?  :)

> Please confirm if new version for patch should be submitted to apply in
> staging.

My staging queue is long-empty, please resend.

thanks,

greg k-h
