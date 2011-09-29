Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5322 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab1I2NhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 09:37:08 -0400
Date: Thu, 29 Sep 2011 19:07:48 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Choose highest rate of MRR based on
 IEEE80211_TX_CTL_USE_MINRATE
Message-ID: <20110929133747.GA2506@vmraj-lnx.users.atheros.com> (sfid-20110929_153718_960865_A7271642)
References: <1317295446-20749-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4E845733.1000203@openwrt.org>
 <20110929121426.GA20802@vmraj-lnx.users.atheros.com>
 <4E846D4F.1070900@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E846D4F.1070900@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 29, 2011 at 03:06:23PM +0200, Felix Fietkau wrote:
> On 2011-09-29 2:14 PM, Rajkumar Manoharan wrote:
> >On Thu, Sep 29, 2011 at 01:32:03PM +0200, Felix Fietkau wrote:
> >> On 2011-09-29 1:24 PM, Rajkumar Manoharan wrote:
> >> >Select appropriate rate as highest rate of rate series, if the frame
> >> >was asked to be sent at minimum rate. For example nullfunc frames
> >> >either can be sent at HT rates on normal case or at non-HT rates if
> >> >it is used for connection monitoring.
> >> >
> >> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >> >---
> >> >   drivers/net/wireless/ath/ath9k/rc.c |    4 ++--
> >> >   1 files changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> Shouldn't the check for IEEE80211_TX_CTL_USE_MINRATE be in
> >> rate_control_send_low(), so that it does not have to be repeated in
> >> every single rate control module?
> >>
> >But I donno what could be the side effect of changing rate_control_send_low
> >as it is used by all drivers. And also if the rate control provide the
> >minrate, it can be used to update the PER upon tx status. isnt it?
> It always updates the PER upon tx status, even if
> rate_control_send_low was used. It should work the same way for
> every driver, so I think putting this in the ath9k rc is the wrong
> place, and it would be weird if a flag with such a generic name as
> IEEE80211_TX_CTL_USE_MINRATE would be used by some rate control
> modules and ignored by others.
>
That true. Till now rate_control_send_low never be used for data frame.
So just to be causious, I dicided to process tx_ctl at rate control side.
If it wont break any rate control algo other than ath9k, then I send my
earlier rfc patch. Thanks for your input.

--
Rajkumar
