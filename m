Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab2CBVnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 16:43:19 -0500
Subject: Re: [PATCHv3 1/2] mac80211_hwsim:  Add tsf to beacons, probe
 responses and radiotap header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1330722280-28879-1-git-send-email-javier@cozybit.com> (sfid-20120302_220506_374722_1B6412A4)
References: <1330722280-28879-1-git-send-email-javier@cozybit.com>
	 (sfid-20120302_220506_374722_1B6412A4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 22:43:18 +0100
Message-ID: <1330724598.9652.4.camel@jlt3.sipsolutions.net> (sfid-20120302_224322_276484_BF447C85)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 13:04 -0800, Javier Cardona wrote:

> @@ -667,6 +679,19 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	bool ack;
>  	struct ieee80211_tx_info *txi;
>  	u32 _pid;
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> +	struct mac80211_hwsim_data *data = hw->priv;
> +	__le64 *tsfpos;
> +	u16 fc = le16_to_cpu(hdr->frame_control);
> +	u16 fctypes = fc & (IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
> +
> +	if (fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_RESP) ||
> +	    fctypes == (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON)) {
> +		struct ieee80211_hdr_3addr *hdr3 =
> +			(struct ieee80211_hdr_3addr *) skb->data;
> +		tsfpos = (__le64 *) (hdr3 + 1);
> +		put_unaligned(__mac80211_hwsim_get_tsf(data), tsfpos);
> +	}

And here, you can do the same with struct ieee80211_mgmt and don't even
need the struct ieee80211_hdr * variable then.

Also, you should use ieee80211_is_beacon() and ieee80211_is_probe_req().

Sorry for the incoherent review!

johannes

