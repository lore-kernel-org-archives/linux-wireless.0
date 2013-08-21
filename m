Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3HUJft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 05:35:49 -0400
Message-ID: <1377077745.15268.8.camel@jlt4.sipsolutions.net> (sfid-20130821_113552_219103_8470D665)
Subject: Re: [PATCHv3 09/18] mac80211: change IBSS channel state to chandef
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 21 Aug 2013 11:35:45 +0200
In-Reply-To: <1368702045-27598-10-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130223_680292_101CF04D)
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1368702045-27598-10-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20130516_130223_680292_101CF04D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-16 at 13:00 +0200, Simon Wunderlich wrote:

> -	cfg80211_chandef_create(&chandef, chan, ifibss->channel_type);
> +	chandef = ifibss->chandef;

This part is obviously wrong - it ignores the given channel. Please post
a fix as soon as you can, with the code as it is now we never join an
existing IBSS correctly but always use the channel the user gave.

johannes

