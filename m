Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1112 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZBCQYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:24:24 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 5/5] ath5k: Update reset code
Date: Tue, 3 Feb 2009 11:24:04 -0500
Message-Id: <20090203161317.M71923@bobcopeland.com> (sfid-20090203_172428_019907_0507177A)
In-Reply-To: <20090131023147.GE3342@makis>
References: <20090131023147.GE3342@makis>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 31 Jan 2009 04:31:47 +0200, Nick Kossifidis wrote
>  int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
>  	struct ieee80211_channel *channel, bool change_channel)

Here's another thing I just noticed:

>  {
> +	u32 s_seq[10], s_ant, s_led[3], staid1_flags, tsf_up, tsf_lo;

s_seq is now an array (we used to initialize s_seq to 0)

[...]
> +		if (change_channel) {
> +			/*
> +			 * Save frame sequence count
> +			 * For revs. after Oahu, only save
> +			 * seq num for DCU 0 (Global seq num)
> +			 */
> +			if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
> +
> +				for (i = 0; i < 10; i++)
> +					s_seq[i] = ath5k_hw_reg_read(ah,
> +						AR5K_QUEUE_DCU_SEQNUM(i));
> +
> +			} else {
> +				s_seq[0] = ath5k_hw_reg_read(ah,
> +						AR5K_QUEUE_DCU_SEQNUM(0));
> +			}

We only save the DCU sequence values if changing a channel

[...]

>  	if (ah->ah_version != AR5K_AR5210) {
> -		ath5k_hw_reg_write(ah, s_seq, AR5K_QUEUE_DFS_SEQNUM(0));
> +
> +		if (ah->ah_mac_srev < AR5K_SREV_AR5211) {
> +			for (i = 0; i < 10; i++)
> +				ath5k_hw_reg_write(ah, s_seq[i],
> +					AR5K_QUEUE_DCU_SEQNUM(i));
> +		} else {
> +			ath5k_hw_reg_write(ah, s_seq[0],
> +				AR5K_QUEUE_DCU_SEQNUM(0));
> +		}

But always write it.  The old code did this too, the only difference
was we explicitly initialized the s_seq[0] to 0.  Since it's an array,
gcc won't warn about it but s_seq[] probably has random crap in it.

-- 
Bob Copeland %% www.bobcopeland.com


