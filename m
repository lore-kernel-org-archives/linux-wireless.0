Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:28491 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab0CZU5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 16:57:05 -0400
Subject: Re: [PATCH] setup correct int pipe type in ar9170_usb_exec_cmd
From: Pavel Roskin <proski@gnu.org>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
In-Reply-To: <1269600273-7974-1-git-send-email-valentin.longchamp@epfl.ch>
References: <1269600273-7974-1-git-send-email-valentin.longchamp@epfl.ch>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 16:57:03 -0400
Message-Id: <1269637023.8534.17.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 11:44 +0100, Valentin Longchamp wrote:
> An int urb is constructed but we fill it in with a bulk pipe type.
> 
> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 implemented a pipe type
> check when CONFIG_USB_DEBUG is enabled. The check failed for all the ar9170
> usb transfers and the driver could not configure the wifi dongle.
> 
> This went unnoticed until now because most people don't have
> CONFIG_USB_DEBUG enabled.

Actually, if the code was broken and nobody noticed, do we need it at
all?  ar9170_usb_tx_urb_complete() is an empty function.

Suppose we need it, then maybe we could put some debug code there?  I
think that function has a poor name, it should be something with "cmd",
like ar9170_usb_tx_urb_complete_cmd().

By the way, I think such fixes belong to stable.
 
-- 
Regards,
Pavel Roskin
