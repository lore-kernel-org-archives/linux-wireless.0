Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51325 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965888AbcCPLQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2016 07:16:50 -0400
Date: Wed, 16 Mar 2016 16:46:37 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
	<mohammed@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: Introduce Extended Resource Config support
 for 10.4
Message-ID: <20160316111637.GA5213@atheros-ThinkPad-T61> (sfid-20160316_121657_409092_95BB00BF)
References: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
 <1458052250-2529-2-git-send-email-mohammed@qca.qualcomm.com>
 <87h9g6lo4y.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h9g6lo4y.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Mar 16, 2016 at 10:21:10AM +0000, Valo, Kalle wrote:
> Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:
> 
> > From: Raja Mani <rmani@qti.qualcomm.com>
> >
> > Add API support for Extended Resource Configuration for 10.4. This
> > is useful to enable new features like Peer Stats, LTEU etc if the
> > firmware advertises support for the service. This is also done to
> > provide backward compatibility with older firmware. Also for clarity
> > send default host platform type as 'WMI_HOST_PLATFORM_HIGH_PERF',
> > though this should not make any difference in functionality
> >
> > Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> [...]
> 
> > @@ -2665,7 +2666,32 @@ struct wmi_resource_config_10_4 {
> >  	 * 0  - This is not qwrap
> >  	 */
> >  	__le32 qwrap_config;
> > -} __packed;
> > +} __packed
> 
> This doesn't compile:

[shafi] Very sorry, made that error while rebasing one of the review comments
:-( Will avoid this in future, once again apologies 

> 
> In file included from drivers/net/wireless/ath/ath10k/core.h:32:0,
>                  from drivers/net/wireless/ath/ath10k/htt.c:22:
> drivers/net/wireless/ath/ath10k/wmi.h:2680:1: error: expected ';',
>                  identifier or '(' before 'enum'
> make[1]: *** [drivers/net/wireless/ath/ath10k/htt.o] Error 1
> In file included from drivers/net/wireless/ath/ath10k/core.h:32:0,
>                  from drivers/net/wireless/ath/ath10k/debug.c:25:
> drivers/net/wireless/ath/ath10k/wmi.h:2680:1: error: expected ';',
>                  identifier or '(' before 'enum'

thanks,
shafi
> 
