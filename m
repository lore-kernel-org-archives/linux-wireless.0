Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19497 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759107AbZKZHvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 02:51:07 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: PROPOSAL: cfg80211 antenna selection
Date: Thu, 26 Nov 2009 08:51:00 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
References: <200911250941.10929.holgerschurig@gmail.com> <43e72e890911250736l33afdf8ak1c806e5f5482f9da@mail.gmail.com>
In-Reply-To: <43e72e890911250736l33afdf8ak1c806e5f5482f9da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200911260851.00192.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> While at it might as well make this some configurable struct
> which the drivers can add to the wiphy just as with the
> subbands. 

Something like this?


struct ieee80211_antenna lbs_antennas {
	u32 hwvalue;
	u32 flags;
	u32 capability;
	int max_gain;
}

static struct ieee80211_antenna lbs_antennas[] = {
	{
		.hwvalue = 0,
		.capability = IEEE80211_ANTENNA_RXTX,
	}
};

wiphy->antennas = lbs_antennas;
wiphy->n_anteanns = ARRAY_SIZE(lbs_antennas);

Or should the antennas be added to "struct
ieee80211_supported_band" instead of wiphy?


Capabilities could be

#define IEEE80211_ANTENNA_RX         BIT(0)
#define IEEE80211_ANTENNA_TX         BIT(1)
#define IEEE80211_ANTENNA_OMNI       BIT(2)
#define IEEE80211_ANTENNA_SECTIONAL  BIT(3)
#define IEEE80211_ANTENNA_RXTX
   (IEEE80211_ANTENNA_RX | IEEE80211_ANTENNA_TX)

An unknown gain would be set to 0.



> Not sure how to get this from other cards. Anyone know how
> about on b43, iwlwifi, rallink? 

Libertas doesn't give this to you, AFAIK you can just get the
number of antennas.


> Not sure if allowing for ops for chainmask setting would also
> be helpeful here, that would need some review.

What is "chainmask setting", I don't even know the concept.



You didn't give any comment on my mask idea for the user-space 
API.

-- 
http://www.holgerschurig.de
