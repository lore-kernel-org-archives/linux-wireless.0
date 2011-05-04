Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61846 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1EDMnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 08:43:25 -0400
Received: by eyx24 with SMTP id 24so338104eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 May 2011 05:43:24 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [PATCH] carl9170: fix allmulticast mode
Date: Wed, 4 May 2011 14:43:25 +0000
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <4DC13CC5.9050909@lri.fr>
In-Reply-To: <4DC13CC5.9050909@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105041443.25501.chunkeey@googlemail.com> (sfid-20110504_144328_343419_5EF5BF54)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 04 May 2011 11:47:17 Nicolas Cavallari wrote:
> Currently, the driver only disable multicast filtering when the
> FIF_ALLMULTI driver flag has been just set (ie,
> if changed_flags& FIF_ALLMULTI and *new_flags& FIF_ALLMULTI) or else
> it will reenable multicast filtering.
> 
> But next time, this condition will be false and multicast filtering
> will be reenabled, even through FIF_ALLMULTI is still set.
> 
> This mean that allmulticast only works for less than two minutes in
> ad-hoc mode.  This patch fixes that to disable multicast filtering
> as long as FIF_ALLMULTI is set.
> 
> Signed-off-by: Nicolas Cavallari  <cavallar@lri.fr>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
[Just a minor niggle]

> ---
> diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> index 1638468..7d5c65e 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -883,7 +883,7 @@ static void carl9170_op_configure_filter(struct
> ieee80211_hw *hw,
> 	 * then checking the error flags, later.
> 	 */
> 
> -	if (changed_flags&  FIF_ALLMULTI&&  *new_flags&  FIF_ALLMULTI)
                      ^^^            ^^^          ^^^
It looks like your mailer realigned the spaces around the operators
and added a line-wrap so it won't apply without some help. Can you
fix the problem and send the patch again?

Thanks,
	Christian
