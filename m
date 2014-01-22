Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaAVXKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 18:10:49 -0500
Message-ID: <1390432245.20070.0.camel@jlt4.sipsolutions.net> (sfid-20140123_001052_661337_21771340)
Subject: Re: [PATCH 2/2] mac80211: Support tx-hw-crypt with rx-sw-crypt.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 Jan 2014 00:10:45 +0100
In-Reply-To: <1390431296-20568-2-git-send-email-greearb@candelatech.com> (sfid-20140122_235550_068991_E5B7233B)
References: <1390431296-20568-1-git-send-email-greearb@candelatech.com>
	 <1390431296-20568-2-git-send-email-greearb@candelatech.com>
	 (sfid-20140122_235550_068991_E5B7233B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 14:54 -0800, greearb@candelatech.com wrote:

> + * @IEEE80211_KEY_FLAG_SW_RX_CRYPT: This flag indicates hardware will not
> + *	do any decrypt for received packets, though it may have uploaded
> + *	the hardware key to be used for encrypting transmitted frames.

This isn't needed, all you need to do is return 0 from the set_key
callback in the driver, without programming the key into the device. And
then ignore tkip key updates for such a key.

johannes

