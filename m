Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34124 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbeEVN5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:57:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ramon Fried <ramon.fried@gmail.com>
Cc: jjohnson@codeaurora.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Eyal Ilsar <eilsar@codeaurora.org>,
        Ramon Fried <ramon.fried@linaro.org>
Subject: Re: [PATCH v2] wcn36xx: Add support for Factory Test Mode (FTM)
References: <20180518103122.28439-1-ramon.fried@gmail.com>
Date: Tue, 22 May 2018 16:57:09 +0300
In-Reply-To: <20180518103122.28439-1-ramon.fried@gmail.com> (Ramon Fried's
        message of "Fri, 18 May 2018 13:31:22 +0300")
Message-ID: <87a7srvlmy.fsf@purkki.adurom.net> (sfid-20180522_155734_567591_CDD3163A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ramon Fried <ramon.fried@gmail.com> writes:

> From: Eyal Ilsar <eilsar@codeaurora.org>
>
> Introduce infrastructure for supporting Factory Test Mode (FTM) of the
> wireless LAN subsystem. In order for the user space to access the
> firmware in test mode the relevant netlink channel needs to be exposed
> from the kernel driver.
>
> The above is achieved as follows:
> 1) Register wcn36xx driver to testmode callback from netlink
> 2) Add testmode callback implementation to handle incoming FTM commands
> 3) Add FTM command packet structure
> 4) Add handling for GET_BUILD_RELEASE_NUMBER (msgid=0x32A2)
> 5) Add generic handling for all PTT_MSG packets
>
> Signed-off-by: Eyal Ilsar <eilsar@codeaurora.org>
> Signed-off-by: Ramon Fried <ramon.fried@linaro.org>

kbuild bot reported a warning:

drivers/net/wireless/ath/wcn36xx/testmode.c:122:5: warning: 'msg' may be used uninitialized in this function [-Wmaybe-uninitialized]

-- 
Kalle Valo
