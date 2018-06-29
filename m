Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36010 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753518AbeF2JpY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 05:45:24 -0400
Message-ID: <1530265522.3481.52.camel@sipsolutions.net> (sfid-20180629_114529_366809_BCF950B4)
Subject: Re: [PATCH 2/4] mac80211: Add api to configure low and high txrate
 threshold
From: Johannes Berg <johannes@sipsolutions.net>
To: Tamizh chelvam <tamizhr@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 11:45:22 +0200
In-Reply-To: <1528887539-26821-3-git-send-email-tamizhr@codeaurora.org>
References: <1528887539-26821-1-git-send-email-tamizhr@codeaurora.org>
         <1528887539-26821-3-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-06-13 at 16:28 +0530, Tamizh chelvam wrote:
> +	if (sta->txrate_low == low_txrate_thold &&
> +	    sta->txrate_high == high_txrate_thold)
> +		goto unlock;
> +
> +	sta->txrate_low = low_txrate_thold;
> +	sta->txrate_high = high_txrate_thold;

You don't really do anything here so what do you gain by doing the ==
comparison and jumping over the assignment?

I'd understand if you did some calculations here or whatever, but as it
is it reads more like something was missed than like it was intended
this way?

Again, I think you need to squash this with patch 4.

johannes
