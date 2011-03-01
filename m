Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33457 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068Ab1CAV4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 16:56:09 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 13:55:47 -0800
Date: Tue, 1 Mar 2011 13:56:04 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	"dubowoj@neratec.com" <dubowoj@neratec.com>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"simon.wunderlich@saxnet.de" <simon.wunderlich@saxnet.de>
Subject: Re: [PATCH 3/9] [mac80211] enable radar detection
Message-ID: <20110301215604.GE6835@tux>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
 <201102281747.44842.bernhard.schmidt@saxnet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201102281747.44842.bernhard.schmidt@saxnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 28, 2011 at 08:47:44AM -0800, Bernhard Schmidt wrote:
> +	if (sdata && (sdata->vif.type == NL80211_IFTYPE_ADHOC ||
> +		      sdata->vif.type == NL80211_IFTYPE_AP ||
> +		      sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> +		      sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
> +		      sdata->vif.type == NL80211_IFTYPE_P2P_GO) &&

How about adding a helper as a separate patch that checks this
for us and then sprinkling in other areas of code we have that uses
the same check?

Some thing like ieee80211_sdata_can_beacon(sdata) or whatever.

  Luis
