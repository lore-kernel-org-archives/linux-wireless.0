Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbbIONpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 09:45:08 -0400
Date: Tue, 15 Sep 2015 06:45:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 2/7] staging: wilc1000: remove definition WILC_NULLCHECK
Message-ID: <20150915134507.GA22620@kroah.com> (sfid-20150915_154512_565877_89495C01)
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
 <1442285621-29457-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442285621-29457-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 11:53:36AM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes the definition WILC_NULLCHECK which is not used anymore.

No, it is used, you just remove all usages of it in this patch as well
:)

Also, your fixes are not correct, you are not keeping the same codepaths
here anymore, you are returning and not jumping to the ERRORHANDLER: tag
anymore, which could mean you are leaking memory.  Please fix up this
series and resend, but note, I took the first patch here.

thanks,

greg k-h
