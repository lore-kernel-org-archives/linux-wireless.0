Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbIUEiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 00:38:17 -0400
Date: Sun, 20 Sep 2015 19:01:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 08/18] staging: wilc1000: remove declaration of
 WILC_WFI_frame_register
Message-ID: <20150921020143.GC22262@kroah.com> (sfid-20150921_063824_733677_ECF5B239)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:15PM +0900, Chaehyun Lim wrote:
> This patch removes function declaration of WILC_WFI_frame_register in
> linux_wlan.c file, then adds it in wilc_wfi_cfgoperations.h file.
> 
> The compilation warning occurs because it is assigned to incorrect
> pointer type of second parameter of WILC_WFI_frame_register.
> It is assigned with struct wireless_dev pointer type.

How was this code ever even working properly if the wrong pointer was
being passed into it?

Tony, what is going on here, is this code just never called?  If so, can
we just delete the whole function?

thanks,

greg k-h
