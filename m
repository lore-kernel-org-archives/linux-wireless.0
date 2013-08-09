Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966645Ab3HINW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:22:29 -0400
Message-ID: <1376054546.8355.11.camel@jlt4.sipsolutions.net> (sfid-20130809_152232_384286_3BB4DB98)
Subject: Re: [PATCH 5/7] mac80211: add support for CSA in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 09 Aug 2013 15:22:26 +0200
In-Reply-To: <1375457886-7275-6-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1375457886-7275-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1375457886-7275-6-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-02 at 17:38 +0200, Simon Wunderlich wrote:

> +	if (sdata->vif.type == NL80211_IFTYPE_AP) {

> +	} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {

> +	} else {

switch() ?


> +	case NL80211_CHAN_WIDTH_10:
> +		if (WARN_ON(params.chandef.width != ifibss->chandef.width))

You should really not make a WARN_ON remotely triggerable.

johannes

