Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32081 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1H3JXL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:23:11 -0400
Message-ID: <4E5CABF8.901@qca.qualcomm.com> (sfid-20110830_112315_244990_7B6E7C1B)
Date: Tue, 30 Aug 2011 12:23:04 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/20] ath6kl: Implement mgmt_tx
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-8-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-8-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> +static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
> +			  struct ieee80211_channel *chan, bool offchan,
> +			  enum nl80211_channel_type channel_type,
> +			  bool channel_type_valid, unsigned int wait,
> +			  const u8 *buf, size_t len, u64 *cookie)
> +{
> +	struct ath6kl *ar = ath6kl_priv(dev);
> +	u32 id;
> +
> +	id = ar->send_action_id++;
> +	if (id == 0)
> +		id = ar->send_action_id++;
> +
> +	*cookie = id;
> +	return ath6kl_wmi_send_action_cmd(ar->wmi, id, chan->center_freq, wait,
> +					  buf, len);
> +}

I don't understand the "if (id == 0)" check. It would be nice to get a
comment giving some background info about the situation.

Kalle
