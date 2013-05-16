Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42305 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3EPLth (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:49:37 -0400
Message-ID: <5194C7CC.1090109@openwrt.org> (sfid-20130516_134942_451088_E08CA437)
Date: Thu, 16 May 2013 13:49:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv3 08/18] cfg80211/mac80211: use reduced txpower for 5
 and 10 MHz
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1368702045-27598-9-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1368702045-27598-9-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-16 1:00 PM, Simon Wunderlich wrote:
> Some regulations (like germany, but also FCC) express their transmission
> power limit in dBm/MHz or mW/MHz. To cope with that and be on the safe
> side, reduce the maximum power to half (10 MHz) or quarter (5 MHz)
> when operating on these reduced bandwidth channels.
As far as I know, chan->max_power can in some cases contain the hardware
limit instead of the regulatory limit. It's safer to check
chan->max_reg_power to see if a reduction is necessary.

- Felix

