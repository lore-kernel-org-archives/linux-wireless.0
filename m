Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2539DC46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:22:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB30E20866
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 14:22:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="TMLpesyC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB30E20866
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbeKEXmb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 18:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbeKEXmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 18:42:31 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24C62085A;
        Mon,  5 Nov 2018 14:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1541427754;
        bh=Ge8KHKL/e9ZR7Gg8eCqm0RIP08Nr6OwDwJdnEo8xeB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TMLpesyCrE0HWpzuh5Q9T9YAz379P9VUwOiRQSGh8iZdY/p1HGRE5hMi2/bYPiuy5
         TwHz2B+yEq9lN3JM+S+6VB1bYW1hNCxIMIBgkzHMVjWetKFecLql51zIEmriOOzspO
         yYLdb/w30u3WClvQU+v+IF88lwdwKBxzNgG6Qpfk=
Date:   Mon, 5 Nov 2018 15:22:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adham.Abozaeid@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Ganesh.Krishna@microchip.com, Mrutyunjaya.Satapathy@microchip.com,
        Aditya.Shankar@microchip.com, Sripad.Balwadgi@microchip.com,
        johannes@sipsolutions.net
Subject: Re: [PATCH v2 1/4] staging: wilc1000: remove unused flags in
 handle_cfg_param()
Message-ID: <20181105142231.GA28129@kroah.com>
References: <20181030042243.2153-1-adham.abozaeid@microchip.com>
 <20181030042243.2153-2-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030042243.2153-2-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 30, 2018 at 04:22:55AM +0000, Adham.Abozaeid@microchip.com wrote:
> From: Adham Abozaeid <adham.abozaeid@micochip.com>
> 
> handle_cfg_param() receives a bit map that describes what to be changed.
> Some of these bits flags aren't referred to from elsewhere and can be
> removed.
> 
> Signed-off-by: Adham Abozaeid <adham.abozaeid@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 216 ----------------------
>  drivers/staging/wilc1000/host_interface.h |  29 ---
>  drivers/staging/wilc1000/wilc_wlan_if.h   |   9 -
>  3 files changed, 254 deletions(-)
>  mode change 100644 => 100755 drivers/staging/wilc1000/host_interface.c
>  mode change 100644 => 100755 drivers/staging/wilc1000/host_interface.h
>  mode change 100644 => 100755 drivers/staging/wilc1000/wilc_wlan_if.h

Do not do Linux kernel testing on filesystems on windows machines :(

You just changed the permissions on these files for no reason, which
isn't ok at all :(

Dropping this series from my queue.

greg k-h
