Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:47936 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454Ab1LAKIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 05:08:39 -0500
Received: by lagj5 with SMTP id j5so904851lag.34
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 02:08:37 -0800 (PST)
Subject: Re: [PATCH] wl12xx: add chip_family to platform data struct
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com
In-Reply-To: <1320763424-466-1-git-send-email-coelho@ti.com>
References: <1320763424-466-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 12:08:33 +0200
Message-ID: <1322734113.8996.9.camel@cumari> (sfid-20111201_110843_611344_AE1B76CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 16:43 +0200, Luciano Coelho wrote: 
> To abstract the bus modules from the actual driver that handles the
> chip, we can pass the chip_family struct in the platform data.  This
> string is used by the bus modules to name the platform device they
> create.  The same string is used by the platform driver to get probed.
> 
> If not specified, we use "wl12xx" as default for backwards
> compatibility.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

I'll skip this patch for now, as it needs to be reworked for backwards
compatibility with compat-wireless.  We have a solution that I'll
implement soon (thanks Arik for the good discussions!).

And once we touch the platform data again, we need to add some version
numbering, so we don't keep breaking the ABI between the board files and
the driver.  More details to follow. ;)

-- 
Cheers,
Luca.

