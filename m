Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18677 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab0D1HAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 03:00:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Apr 2010 00:00:50 -0700
Subject: Re: [PATCH] ath9k: Added get_survey callback in order to get
 channel noise
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Benoit Papillault <benoit.papillault@free.fr>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath5k.org" <ath9k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr>
References: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 10:00:45 +0300
Message-ID: <1272438045.2772.6.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-04-27 at 15:08 -0700, Benoit Papillault wrote:
> +static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
> +			     struct survey_info *survey)

> +	struct ieee80211_conf *conf = &hw->conf;
> +
> +	 if (idx != 0)
> +		return -ENOENT;
> +
> +	survey->channel = conf->channel;

Are there any plans on providing this information from all channels? I
have assumed that the survey command was supposed to be used for
surveying all channels (e.g., to get information for auto-channel
selection) and returning something for the current channel is quite
limited subset of that. In other words, I would like to be able to run a
scan of all channels and then use NL80211_CMD_GET_SURVEY to fetch
additional per-channel information like noise (and also channel usage
statistics in case of ath9k) from the scanned channels.

- Jouni


