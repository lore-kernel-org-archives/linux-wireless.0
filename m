Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3BEC4360F
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4586820868
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552064709;
	bh=jZXQCeEfjPNyJzbL04sgLPUXb4r21AeoUSuwCjB+hH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IX9zMBU6rnnnbzd1PRBEJCxOXJF7RInsEJNjYWjUeEtP50urocyCdfRTVQ+EbFzfY
	 HPIaHQnVxTT9joQt92V6AlzurLxQ76lu47aLc++ioylFj6pxbdhPoxUY8+y53XN5q6
	 DXumUYB84xf1nWQZOnY04u9CuRUFYFXtiE2idTDY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbfCHRFI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:05:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfCHRFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 12:05:04 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB58820868;
        Fri,  8 Mar 2019 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552064704;
        bh=jZXQCeEfjPNyJzbL04sgLPUXb4r21AeoUSuwCjB+hH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoC/rqCBpnzdh6gM5Yj1r6dmBcc6QRxr/pYTuNki7sv0ftgMiPBtXSFglYzbd9jDO
         dOglyL48SfdymdoIZJDAcjgVciyhu9X+5G8vTbO+WuZ9g2VsFrBKufPf7IHegi0B+Y
         wNbZGccwV95Srioe9P3sUnW/bRcdGwZdoqRn+TZY=
Date:   Fri, 8 Mar 2019 15:06:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org,
        sgruszka@redhat.com, pkshih@realtek.com, tehuang@realtek.com,
        briannorris@chromium.org
Subject: Re: [PATCH v6 14/14] staging: rtlwifi: remove staging rtlwifi driver
Message-ID: <20190308140619.GE25768@kroah.com>
References: <1552053343-6513-1-git-send-email-yhchuang@realtek.com>
 <1552053343-6513-15-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1552053343-6513-15-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 08, 2019 at 09:55:43PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> series driver rtw88, remove it to avoid racing with the same ID.
> 
> The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88

The only objection I have here is that your new driver does not support
all of the devices that this driver does.  So why not just rip out the
PCI stuff for the staging driver until the USB/SDIO code gets added to
the new one, and then you can drop the rest of this code?

thanks,

greg k-h
