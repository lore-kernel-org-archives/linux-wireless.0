Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45289 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYHGP71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:59:27 -0400
Message-ID: <489B1BDE.6070203@lwfinger.net> (sfid-20080807_175930_304080_CC36F676)
Date: Thu, 07 Aug 2008 10:59:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> <1218115671.23048.174.camel@johannes.berg> <200808071727.19129.chunkeey@web.de>
In-Reply-To: <200808071727.19129.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Thursday 07 August 2008 15:27:51 Johannes Berg wrote:
>>> +			priv->tx_stats[le32_to_cpu(entry_data->frame_type - 4)].len--;
>> Sorry for not catching this earlier, but this looks wrong, the -4 surely
>> should be outside the endian conversion?
> 
> likely... let's do the job properly for once and for all.
> --
> 
> This patch fixes not only the regression which has sneaked in
> with commit b19fa1f, but also provides some extra code for
> cts rates.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Is the extra code for cts rates a bug fix or a feature enhancement? If the 
latter, then this patch should be in two parts. The main reason is that fixes 
should go to stable as well as wireless-testing.

Larry

