Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43711 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaEUUw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:52:26 -0400
Message-ID: <537D1200.1020700@openwrt.org> (sfid-20140521_225229_180558_64971C17)
Date: Wed, 21 May 2014 22:52:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: Handle multiple keys while setting tx filters
References: <1400671759-30499-1-git-send-email-rmanohar@qti.qualcomm.com> <537C9B84.7000002@openwrt.org> <20140521141632.GA5922@qca.qualcomm.com>
In-Reply-To: <20140521141632.GA5922@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-21 16:16, Rajkumar Manoharan wrote:
> On Wed, May 21, 2014 at 02:26:44PM +0200, Felix Fietkau wrote:
>> On 2014-05-21 13:29, Rajkumar Manoharan wrote:
>> > The keycache index is used to abort transmission for given station
>> > when it goes to sleep state. But the commit "ath9k_hw: Abort transmission
>> > for sleeping station" is not handling multi-key station. Fix that.
>> > 
>> > Cc: Felix Fietkau <nbd@openwrt.org>
>> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>> > ---
>> >  drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
>> >  drivers/net/wireless/ath/ath9k/main.c  | 52 +++++++++++++++++++++++++++-------
>> >  2 files changed, 42 insertions(+), 11 deletions(-)
>> > 
>> > @@ -1610,11 +1626,25 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
>> >  				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
>> >  			ret = 0;
>> >  		}
>> > +		if (an && key->hw_key_idx) {
>> > +			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
>> > +				if (an->key_idx[i])
>> > +					continue;
>> > +				an->key_idx[i] = key->hw_key_idx;
>> I think this should be moved inside the ret >= 0 test.
> Since key->hw_key_idx is valid only when ret > 0, this change is moved
> out of ret check to avoid additional indentation.
That's my point. key->hw_key_idx is valid only when ret >= 0, are you
sure that it's always zero before attempting to set it in hw?

Not sure if a key can be disabled from mac80211 and then enabled again,
but that's one scenario I can come up with, where hw_key_idx might be stale.

It might be a good idea to initialize it to zero if adding the key
failed (and also when disabling it).

- Felix
