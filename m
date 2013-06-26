Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210Ab3FZPRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:17:38 -0400
Message-ID: <1372259854.13529.14.camel@jlt4.sipsolutions.net> (sfid-20130626_171749_096804_D9BCCD9F)
Subject: Re: [PATCH v12 1/2] cfg80211: add 'flags' to cfg80211_rx_mgmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Ilan Peer <ilan.peer@intel.com>
Date: Wed, 26 Jun 2013 17:17:34 +0200
In-Reply-To: <1372167756-17928-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1372167756-17928-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1372167756-17928-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 16:42 +0300, Vladimir Kondratiev wrote:

> +++ b/include/uapi/linux/nl80211.h
> @@ -1436,6 +1436,8 @@ enum nl80211_commands {
>   *	allowed to be used with the first @NL80211_CMD_SET_STATION command to
>   *	update a TDLS peer STA entry.
>   *
> + * @NL80211_ATTR_RXMGMT_FLAGS: flags for cfg80211_rx_mgmt, u32

That's a little insufficient, don't you think? cfg80211_rx_mgmt()
doesn't even really make sense to userspace, you should point to the
nl80211 event and maybe even reference this new attribute in the command
description.

> +/**
> + * enum nl80211_rxmgmt_flags - flags for cfg80211_rx_mgmt
> + *
> + * @NL80211_RXMGMT_FLAG_REPLIED: frame was replied by device/driver.
> + */
> +enum nl80211_rxmgmt_flags {
> +	NL80211_RXMGMT_FLAG_REPLIED = (1 << 0),

No need for parentheses.

>  bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
> -		      const u8 *buf, size_t len, gfp_t gfp)
> +		      const u8 *buf, size_t len, u32 flags, gfp_t gfp)

I'm starting to wonder if this function has too many arguments?
Thoughts? Maybe it should get a struct or so? Not really sure ... could
just be a worthwhile cleanup afterwards?

johannes

