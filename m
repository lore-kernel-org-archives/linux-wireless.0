Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63325 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEUOQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 10:16:05 -0400
Date: Wed, 21 May 2014 19:46:34 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: Handle multiple keys while setting tx filters
Message-ID: <20140521141632.GA5922@qca.qualcomm.com> (sfid-20140521_161610_033325_32516CB5)
References: <1400671759-30499-1-git-send-email-rmanohar@qti.qualcomm.com>
 <537C9B84.7000002@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <537C9B84.7000002@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 21, 2014 at 02:26:44PM +0200, Felix Fietkau wrote:
> On 2014-05-21 13:29, Rajkumar Manoharan wrote:
> > The keycache index is used to abort transmission for given station
> > when it goes to sleep state. But the commit "ath9k_hw: Abort transmission
> > for sleeping station" is not handling multi-key station. Fix that.
> > 
> > Cc: Felix Fietkau <nbd@openwrt.org>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
> >  drivers/net/wireless/ath/ath9k/main.c  | 52 +++++++++++++++++++++++++++-------
> >  2 files changed, 42 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 47d442a..89be123 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -1494,6 +1498,19 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
> >  	return 0;
> >  }
> >  
> > +static inline void ath9k_sta_set_tx_filter(struct ath_hw *ah,
> > +					   struct ath_node *an,
> > +					   bool set)
> I'd suggest dropping the 'inline' - just let the compiler figure out if
> it's worth inlining.
>
fine.
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
> > +		if (!an->key_idx[i])
> > +			continue;
> > +		ath9k_hw_set_tx_filter(ah, an->key_idx[i], set);
> > +	}
> > +}
> > +
> >  static void ath9k_sta_notify(struct ieee80211_hw *hw,
> >  			 struct ieee80211_vif *vif,
> >  			 enum sta_notify_cmd cmd,
> > @@ -1610,11 +1626,25 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
> >  				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
> >  			ret = 0;
> >  		}
> > +		if (an && key->hw_key_idx) {
> > +			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
> > +				if (an->key_idx[i])
> > +					continue;
> > +				an->key_idx[i] = key->hw_key_idx;
> I think this should be moved inside the ret >= 0 test.
Since key->hw_key_idx is valid only when ret > 0, this change is moved
out of ret check to avoid additional indentation.

> You also need to add a break here to avoid the WARN_ON below.
> Did you test this patch?
> 
Oops..my bad.. Checked tx filtering functionality alone. missed
warnings..:(

-Rajkumar

