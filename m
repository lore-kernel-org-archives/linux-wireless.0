Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36194 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3FXOJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 10:09:05 -0400
Message-ID: <1372082937.8439.9.camel@jlt4.sipsolutions.net> (sfid-20130624_160910_302187_E8877430)
Subject: Re: [PATCH v10 1/2] cfg80211: add flags to cfg80211_rx_mgmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Date: Mon, 24 Jun 2013 16:08:57 +0200
In-Reply-To: <1372063757-24286-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1372063757-24286-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1372063757-24286-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-24 at 11:49 +0300, Vladimir Kondratiev wrote:

> +/**
> + * enum nl80211_rxmgmt_flags - flags for cfg80211_rx_mgmt
> + *
> + * Defined are bits, to be used in form like
> + * BIT(NL80211_RXMGMT_FLAG_xxx)
> + *
> + * @NL80211_RXMGMT_FLAG_REPLIED: frame was replied by device/driver.
> + */
> +enum nl80211_rxmgmt_flags {
> +	NL80211_RXMGMT_FLAG_REPLIED,
> +};

I think you should define the bitmasks, i.e. use

NL80211_RXMGMT_FLAG_REPLIED	= 1<<0,

I think that'd be clearer, and userspace doesn't even always have a
BIT() macro.

johannes

