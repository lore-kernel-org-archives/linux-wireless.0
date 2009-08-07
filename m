Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56121 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbZHGTxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 15:53:37 -0400
Date: Fri, 7 Aug 2009 15:36:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090807193610.GK7545@tuxdriver.com>
References: <20090807191156.GS19257@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090807191156.GS19257@buzzloop.caiaq.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2009 at 09:11:56PM +0200, Daniel Mack wrote:
> Since a recent merge of the wireless tree to Linus' master, my SDIO
> connected libertas module fails to connect to our WLAN.
> 
> 'iwlist scanning' works fine, but wpa_supplicant keeps on spitting out
> the following message:
> 
>   CTRL-EVENT-SCAN-RESULTS 
>   Trying to associate with 00:04:0e:4b:c7:b3 (SSID='caiaq' freq=2437 MHz)
>   Association request to the driver failed
> 
> Haven't done any bisect or deeper inspection of recent changes yet. Can
> anyone point me in some direction maybe? The change must have been
> introduced between -rc3 and -rc5. My userspace did not change since
> then.

Normally a bisect is exactly what you would do.  In this case, there
is only this on libertas patch in the range you mention:

commit 154839962a582b8eb661cde94ef3af0e03b374d7
Author: Marek Vasut <marek.vasut@gmail.com>
Date:   Thu Jul 16 19:19:53 2009 +0200

    libertas: Fix problem with broken V4 firmware on CF8381
    
    Firmware V4 on CF8381 reports region code shifted by 1 byte to left.
    The following patch checks for this and handles it properly.
    
    Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

If you revert that, does your problem disappear?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
