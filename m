Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:57404 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132Ab3FEPKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 11:10:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"ath6kl-devel@qca.qualcomm.com" <ath6kl-devel@qca.qualcomm.com>
Subject: Re: [PATCHv3 3/4] ath6kl: make mgmt_tx accept a NULL channel
References: <1370442893-1687-1-git-send-email-ordex@autistici.org>
	<1370442893-1687-3-git-send-email-ordex@autistici.org>
	<87r4ggy5ow.fsf@kamboji.qca.qualcomm.com>
	<20130605145157.GH2349@open-mesh.com>
Date: Wed, 5 Jun 2013 18:07:54 +0300
In-Reply-To: <20130605145157.GH2349@open-mesh.com> (Antonio Quartulli's
	message of "Wed, 5 Jun 2013 16:51:57 +0200")
Message-ID: <87mwr4y4s5.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_171009_078343_EED07C8D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <antonio@open-mesh.com> writes:

> On Wed, Jun 05, 2013 at 07:48:15AM -0700, Kalle Valo wrote:
>> Antonio Quartulli <ordex@autistici.org> writes:
>> 
>> > From: Antonio Quartulli <antonio@open-mesh.com>
>> >
>> > cfg80211 passes a NULL channel to mgmt_tx if the frame has
>> > to be sent on the one currently in use by the device.
>> > Make the implementation of mgmt_tx correctly handle this
>> > case
>> >
>> > Cc: Kalle Valo <kvalo@qca.qualcomm.com>
>> > Cc: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
>> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>> 
>> [...]
>> 
>> > @@ -3175,10 +3175,17 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
>> >  {
>> >  	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
>> >  	struct ath6kl *ar = ath6kl_priv(vif->ndev);
>> > -	u32 id;
>> > +	u32 id, freq;
>> >  	const struct ieee80211_mgmt *mgmt;
>> >  	bool more_data, queued;
>> >  
>> > +	/* default to the current channel, but use the one specified as argument
>> > +	 * if any
>> > +	 */
>> > +	freq = vif->ch_hint;
>> > +	if (chan)
>> > +		freq = chan->center_freq;
>> 
>> Can you please add a check here:
>> 
>> if (WARN_ON(chan == 0))
>>    return -EINVAL;
>
> I think you meant (freq == 0) ?

Yes, thanks for catching that :)

>> Just like Arend, I want to be sure that we don't submit value 0 to the
>> firmware.
>
> Yeah ok. In ath6kl, are you aware of any "firmware command" to get the channel
> from the device like I did for brcmfmac ?
>
> I couldn't find any define matching *GET*CHAN*

I don't recall seeing anything like that.

-- 
Kalle Valo
