Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:34835 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751487Ab0I2FS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 01:18:27 -0400
Date: Tue, 28 Sep 2010 22:18:17 -0700
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
Message-ID: <20100929051817.GA8302@jm.kir.nu>
References: <201009210057.13297.chunkeey@googlemail.com>
 <20100924180013.GD8077@tuxdriver.com>
 <201009250002.21219.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201009250002.21219.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 25, 2010 at 12:02:20AM +0200, Christian Lamparter wrote:
> because mesh uses actions instead of AUTH/ASSOC and
> the following code in ieee80211_rx_h_action (rx.c)
> 
> 1986)       if (!rx->sta && mgmt->u.action.category != WLAN_CATEGORY_PUBLIC)
> 1987)               return RX_DROP_UNUSABLE;
> 
> prevents any new plinks because action.category is probably
> WLAN_CATEGORY_MESH_PLINK, right?

Which Category does not even exist in the latest P802.11s draft..
Someone needs to update the mesh code to match with the latest draft at
some point and the processing of Action frames for setup (between two
STAs that are not associated) needs some changes (e.g., handling of the
new Self Protect Action Category).

-- 
Jouni Malinen                                            PGP id EFC895FA
