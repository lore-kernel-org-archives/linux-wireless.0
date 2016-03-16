Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1567 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965962AbcCPKVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 06:21:25 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mohammed@codeaurora.org" <mohammed@codeaurora.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: Introduce Extended Resource Config support
 for 10.4
Date: Wed, 16 Mar 2016 10:21:10 +0000
Message-ID: <87h9g6lo4y.fsf@kamboji.qca.qualcomm.com> (sfid-20160316_112129_536344_801C5BFD)
References: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
	<1458052250-2529-2-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1458052250-2529-2-git-send-email-mohammed@qca.qualcomm.com>
	(Mohammed Shafi Shajakhan's message of "Tue, 15 Mar 2016 20:00:49	+0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Raja Mani <rmani@qti.qualcomm.com>
>
> Add API support for Extended Resource Configuration for 10.4. This
> is useful to enable new features like Peer Stats, LTEU etc if the
> firmware advertises support for the service. This is also done to
> provide backward compatibility with older firmware. Also for clarity
> send default host platform type as 'WMI_HOST_PLATFORM_HIGH_PERF',
> though this should not make any difference in functionality
>
> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

[...]

> @@ -2665,7 +2666,32 @@ struct wmi_resource_config_10_4 {
>  	 * 0  - This is not qwrap
>  	 */
>  	__le32 qwrap_config;
> -} __packed;
> +} __packed

This doesn't compile:

In file included from drivers/net/wireless/ath/ath10k/core.h:32:0,
                 from drivers/net/wireless/ath/ath10k/htt.c:22:
drivers/net/wireless/ath/ath10k/wmi.h:2680:1: error: expected ';',
                 identifier or '(' before 'enum'
make[1]: *** [drivers/net/wireless/ath/ath10k/htt.o] Error 1
In file included from drivers/net/wireless/ath/ath10k/core.h:32:0,
                 from drivers/net/wireless/ath/ath10k/debug.c:25:
drivers/net/wireless/ath/ath10k/wmi.h:2680:1: error: expected ';',
                 identifier or '(' before 'enum'

-- 
Kalle Valo