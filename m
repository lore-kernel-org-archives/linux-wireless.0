Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:43200 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab1D2TVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:21:48 -0400
Received: by pvg12 with SMTP id 12so2411733pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 12:21:47 -0700 (PDT)
Message-ID: <4DBB0FC7.8040809@lwfinger.net> (sfid-20110429_212151_860599_0B7C748E)
Date: Fri, 29 Apr 2011 14:21:43 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] b43: avoid uninitialized variable warnings in phy_n
References: <1304103559-28415-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1304103559-28415-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2011 01:59 PM, John W. Linville wrote:
>    CC [M]  drivers/net/wireless/b43/phy_n.o
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_set_channel’:
> drivers/net/wireless/b43/phy_n.c:3848:47: warning: ‘tabent_r2’ may be used uninitialized in this function
> drivers/net/wireless/b43/phy_n.c:3849:47: warning: ‘tabent_r3’ may be used uninitialized in this function
> drivers/net/wireless/b43/phy_n.c: In function ‘b43_nphy_poll_rssi.clone.14’:
> drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$7’ may be used uninitialized in this function
> drivers/net/wireless/b43/phy_n.c:2270:6: warning: ‘save_regs_phy$8’ may be used uninitialized in this function
>
> FWIW, the usage of these variables is goverened by checks that match
> their initializations.  So, I think these are actually false warnings.
> Still, I would rather avoid the warning SPAM...
>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> ---
>   drivers/net/wireless/b43/phy_n.c |    7 +++++--
>   1 files changed, 5 insertions(+), 2 deletions(-)
>

If you s/goverened/governed/ in the commit message, then ACK.

For my info, what compiler version and architecture shows these warnings? I 
don't see them with gcc v4.5.1 on x86_64.

Larry
