Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1I2MQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 08:16:25 -0400
Date: Thu, 29 Sep 2011 17:44:27 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Choose highest rate of MRR based on
 IEEE80211_TX_CTL_USE_MINRATE
Message-ID: <20110929121426.GA20802@vmraj-lnx.users.atheros.com> (sfid-20110929_141628_826135_07699565)
References: <1317295446-20749-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E845733.1000203@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E845733.1000203@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 01:32:03PM +0200, Felix Fietkau wrote:
> On 2011-09-29 1:24 PM, Rajkumar Manoharan wrote:
> >Select appropriate rate as highest rate of rate series, if the frame
> >was asked to be sent at minimum rate. For example nullfunc frames
> >either can be sent at HT rates on normal case or at non-HT rates if
> >it is used for connection monitoring.
> >
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >---
> >  drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> >
> Shouldn't the check for IEEE80211_TX_CTL_USE_MINRATE be in
> rate_control_send_low(), so that it does not have to be repeated in
> every single rate control module?
>
But I donno what could be the side effect of changing rate_control_send_low
as it is used by all drivers. And also if the rate control provide the
minrate, it can be used to update the PER upon tx status. isnt it?

--
Rajkumar
