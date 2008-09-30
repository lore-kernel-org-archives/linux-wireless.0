Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42825 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbYI3JOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2008 05:14:31 -0400
Message-ID: <48E1EDE5.1070409@openwrt.org> (sfid-20080930_111434_219923_C2734AF7)
Date: Tue, 30 Sep 2008 11:14:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFC] mac80211: change rate control API to allow multi-rate
 retry
References: <48E17E75.50201@openwrt.org>	 (sfid-20080930_033823_737779_1604EF6A) <1222759069.7064.52.camel@johannes.berg>
In-Reply-To: <1222759069.7064.52.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> If I'm counting correctly, that struct is now 2 bytes too large, you can
> cut out retry_limit I'd think by updating drivers to use
> retries[0].limit though. And iv/icv length can both be removed and added
> into the key_conf I think.
I'm still using retry_limit as maximum number of retries for the primary rate.
The retries[] array only specifies the settings for the alternate rates.
If it's only two bytes, then I'll just move over icv_len and iv_len.

- Felix
