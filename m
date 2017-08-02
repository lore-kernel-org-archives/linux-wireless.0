Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34761 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbdHBHCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 03:02:32 -0400
Date: Wed, 2 Aug 2017 09:01:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: mike@hellotwist.com
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] rt2x00: Fix MMIC countermeasures.
Message-ID: <20170802070117.GA2790@redhat.com> (sfid-20170802_090235_721632_7626EB3C)
References: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKXXJEw72EYHJpdwoWhudmOmFF=w+u_JG3vrp=-TCfR3zhANZw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

The patch was mangled by your email client, but I'm not sure if it is
correct anyway.

On Tue, Aug 01, 2017 at 06:43:33PM -0400, Michael Skeffington wrote:
> Mac80211 doesnt check MMIC failure until after falling through the
> check for whether the packet is decrypted.  Therefore, this driver
> never causes MMIC countermeasures to be initiated.

The relevant mac80211 code look like this:

ieee80211_rx_result
ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
{
<snip>
	/*
	 * No way to verify the MIC if the hardware stripped it or
	 * the IV with the key index. In this case we have solely rely
	 * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
	 * MIC failure report.
	 */
	if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
		if (status->flag & RX_FLAG_MMIC_ERROR)
			goto mic_fail_no_key;

		if (!(status->flag & RX_FLAG_IV_STRIPPED) && rx->key &&
		    rx->key->conf.cipher == WLAN_CIPHER_SUITE_TKIP)
			goto update_iv;

		return RX_CONTINUE;
	}

	/*
	 * Some hardware seems to generate Michael MIC failure reports; even
	 * though, the frame was not encrypted with TKIP and therefore has no
	 * MIC. Ignore the flag them to avoid triggering countermeasures.
	 */
	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP ||
	    !(status->flag & RX_FLAG_DECRYPTED))
		return RX_CONTINUE;

	if (rx->sdata->vif.type == NL80211_IFTYPE_AP && rx->key->conf.keyidx) {
		/*
		 * APs with pairwise keys should never receive Michael MIC
		 * errors for non-zero keyidx because these are reserved for
		 * group keys and only the AP is sending real multicast
		 * frames in the BSS.
		 */
		return RX_DROP_UNUSABLE;
	}

	if (status->flag & RX_FLAG_MMIC_ERROR)
		goto mic_fail;
<snip>

So we indeed check RX_FLAG_DECRYPTED and then RX_FLAG_MMIC_ERROR at some
point. However before that check, we also have:

	if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
		if (status->flag & RX_FLAG_MMIC_ERROR)
			goto mic_fail_no_key;

and we always set RX_FLAG_MMIC_STRIPPED and RX_FLAG_IV_STRIPPED flags in
rt2800 driver. Hence I do not think patch fixes any problem.

Perhaps what should be done is change mic_fail_no_key to mic_fail label
in mac80211 to increase rx->key->u.tkip.mic_failures++ statistic.

Thanks
Stanislaw
