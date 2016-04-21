Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40766 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbcDUMqk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2016 08:46:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtl8xxxu: hide unused tables
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1461016782-2640046-1-git-send-email-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Sitnicki <jsitnicki@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20160421124639.5CD9560F77@smtp.codeaurora.org> (sfid-20160421_144716_248777_F878A54E)
Date: Thu, 21 Apr 2016 12:46:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The references to some arrays in the rtl8xxxu driver were moved inside
> of an #ifdef, but the symbols remain outside, resulting in build warnings:
> 
> rtl8xxxu/rtl8xxxu.c:1506:33: error: 'rtl8188ru_radioa_1t_highpa_table' defined but not used
> rtl8xxxu/rtl8xxxu.c:1431:33: error: 'rtl8192cu_radioa_1t_init_table' defined but not used
> rtl8xxxu/rtl8xxxu.c:1407:33: error: 'rtl8192cu_radiob_2t_init_table' defined but not used
> rtl8xxxu/rtl8xxxu.c:1332:33: error: 'rtl8192cu_radioa_2t_init_table' defined but not used
> rtl8xxxu/rtl8xxxu.c:239:35: error: 'rtl8192c_power_base' defined but not used
> rtl8xxxu/rtl8xxxu.c:217:35: error: 'rtl8188r_power_base' defined but not used
> 
> This adds an extra #ifdef around them to shut up the warnings.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 2fc0b8e5a17d ("rtl8xxxu: Add TX power base values for gen1 parts")
> Fixes: 4062b8ffec36 ("rtl8xxxu: Move PHY RF init into device specific functions")

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
