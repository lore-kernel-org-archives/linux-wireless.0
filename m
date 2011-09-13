Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55800
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932834Ab1IMV5J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 17:57:09 -0400
Date: Tue, 13 Sep 2011 17:57:04 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	mcgrof@gmail.com
Subject: Re: [RFC] wireless: Reset beacon_found while updating regulatory
Message-ID: <20110913215704.GA14176@bombadil.infradead.org> (sfid-20110913_235713_675678_C082C492)
References: <1315925353-20152-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315925353-20152-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 08:19:13PM +0530, Rajkumar Manoharan wrote:
> During the association, the regulatory is updated by country IE
> that reaps the previously found beacons. So the passive scan
> channels after the association is never getting cleared even
> the beacons are received on that channel. This patch resets
> beacon_found while updating regulatory.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  net/wireless/reg.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 9f3aa5c..e38ccbb 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -850,6 +850,7 @@ static void handle_channel(struct wiphy *wiphy,
>  		return;
>  	}
>  
> +	chan->beacon_found = false;
>  	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
>  	chan->max_antenna_gain = min(chan->orig_mag,
>  		(int) MBI_TO_DBI(power_rule->max_antenna_gain));

Good catch, now you want to state *why* you want this and you want
to annotate this as a stable fix as well. The impact as I see it
would be that after a STA disconnects *or* when for any reason a
regulatory domain change happens the beacon hint flag is not
cleared therefore preventing future beacon hints to be learned.
This is important as a regulatory domain change or a restore
of regulatory settings would set back the passive scan and no-ibss
flags on the channel. This is the right place to do this given that
it covers any regulatory domain change.

  Luis
