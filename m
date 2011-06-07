Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:57537 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab1FGSZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 14:25:41 -0400
Received: by mail-ew0-f47.google.com with SMTP id 5so1879523ewy.6
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 11:25:40 -0700 (PDT)
Subject: Re: [PATCH 3.0] nl80211: fix overflow in ssid_len
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com, stable@kernel.org
Cc: linux-wireless@vger.kernel.org, ido@wizery.com,
	johannes@sipsolutions.net
In-Reply-To: <1307468546-16915-1-git-send-email-coelho@ti.com>
References: <1307468546-16915-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 21:25:35 +0300
Message-ID: <1307471135.31669.15.camel@cumari> (sfid-20110607_202545_932180_56262EEB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-07 at 20:42 +0300, Luciano Coelho wrote: 
> When one of the SSID's length passed in a scan or sched_scan request
> is larger than 255, there will be an overflow in the u8 that is used
> to store the length before checking.  This causes the check to fail
> and we overrun the buffer when copying the SSID.
> 
> Fix this by checking the nl80211 attribute length before copying it to
> the struct.
> 
> This is a follow up for the previous commit
> 208c72f4fe44fe09577e7975ba0e7fa0278f3d03, which didn't fix the problem
> entirely.
> 
> Reported-by: Ido Yariv <ido@wizery.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

This should also go to stable, but since it won't apply directly there,
I'll wait till it's applied upstream and then backport it to stable
kernels.

-- 
Cheers,
Luca.

