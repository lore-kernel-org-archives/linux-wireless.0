Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:51746 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab1LOIxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:53:45 -0500
Received: by mail-lpp01m010-f49.google.com with SMTP id c1so1168947lah.22
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:53:44 -0800 (PST)
Subject: Re: [PATCH] wl12xx: don't write out of bounds when hlid >
 WL12XX_MAX_LINKS
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1323769142-20515-1-git-send-email-coelho@ti.com>
References: <1323769142-20515-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:53:39 +0200
Message-ID: <1323939219.2800.178.camel@cumari> (sfid-20111215_095347_872549_06E8A625)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-13 at 11:39 +0200, Luciano Coelho wrote: 
> We should not get an hlid value bigger than WL12XX_MAX_LINKS from
> wl1271_rx_handle_data().  We have a WARN_ON in case it happens.  But
> despite the warning, we would still go ahead and write the hlid bit
> into active_hlids (a stack variable).  This would cause us to
> overwrite other data in the stack.
> 
> To avoid this problem, we now skip the write when issuing the warning,
> so at least we don't corrupt data.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

