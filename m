Return-Path: <SRS0=Oc7L=4A=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D09C352A4
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56E722168B
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Feb 2020 21:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581544062;
	bh=U+75VKG1F9uSU9/QVvPlQjg1qzwwnHnB0pRtKFe1f7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qoeskOioZsuYXCVE8g/G64H+9WEo/JuiynaklytT8cycRk8KCs5VLT+xclMQmSxv/
	 u4oAs9VIqrfV7txw82y6IFUZ+wquQPTVWh/onJqepzOIGPDIzkrGLxrb6jsy5brlBd
	 sxTMQosYXIi+m3uzkHpc6O+vABzSCRvX0wbo+9jM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbgBLVrl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Feb 2020 16:47:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728185AbgBLVrl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Feb 2020 16:47:41 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19419206DB;
        Wed, 12 Feb 2020 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581544061;
        bh=U+75VKG1F9uSU9/QVvPlQjg1qzwwnHnB0pRtKFe1f7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gg1bAJNDjOgkQdAe2MHPqU/i05ZV+0O9nbrpooPqhnPhDAhPWJzOd1Y6xIWTX1g/P
         qNVcYkKki3VMz6Umee7xkvJ9XqcqMqYukmvuwzlC7nb45Re8fT3TJiup0tEyQnKHqr
         EzUNkRAiRRUPmsJWl6cdSLFEqF+DT97btLknT58o=
Date:   Wed, 12 Feb 2020 13:47:40 -0800
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, Adham.Abozaeid@microchip.com
Subject: Re: [PATCH] staging: wilc1000: refactor p2p action frames handling
 API's
Message-ID: <20200212214740.GA2312757@kroah.com>
References: <20200212154503.8835-1-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200212154503.8835-1-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 12, 2020 at 10:14:15AM +0000, Ajay.Kathat@microchip.com wrote:
> From: Ajay Singh <ajay.kathat@microchip.com>
> 
> Refactor handling of P2P specific action frames. Make use of 'struct' to
> handle the P2P frames instead of manipulating using 'buf' pointer.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  [resending this patch as it failed to apply earlier]

I had to export this and apply it by hand as the base64 stuff here
really confused git :(

odd...

greg k-h
