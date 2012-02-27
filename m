Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:55460 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2B0MA1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 07:00:27 -0500
Message-ID: <4F4B7059.3010807@lri.fr> (sfid-20120227_130031_523898_0F502C7F)
Date: Mon, 27 Feb 2012 13:00:25 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH -stable] carl9170: fix frame delivery if sta is in powersave
 mode
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr> <201202252136.37255.chunkeey@googlemail.com>
In-Reply-To: <201202252136.37255.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25/02/2012 21:36, Christian Lamparter wrote:
> Nicolas Cavallari discovered that carl9170 has some
> serious problems delivering data to sleeping stations.
> 
> It turns out that the driver was not honoring two
> important flags (IEEE80211_TX_CTL_POLL_RESPONSE and
> IEEE80211_TX_CTL_CLEAR_PS_FILT) which are set on
> frames that should be sent although the receiving
> station is still in powersave mode.
> 
> Cc: stable <stable@vger.kernel.org>
> Reported-by: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
>> Part of the reason i wrote this, is because, while this patch fixes the
>> memory accounting problem and prevent the AP from stopping working, the
>> powersaving station sometimes cannot communicate with the AP anymore
>> (other stations can). The station uses ath9k, and is just really doing a
>> background scan. The first traces that i have just indicate that the
>> station entered powersave mode, then sends probe requests and probe
>> requests directed to the AP, then sends authentication requests to the
>> AP (?), but the AP does not respond to any of them...
>>
> Ok, I think this patch [on top of yours] should fix the problem.

This effectively fixes the problem.

Thanks !
