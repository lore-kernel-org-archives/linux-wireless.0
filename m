Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56702 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaEUKrr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 06:47:47 -0400
Message-ID: <537C8446.9030807@openwrt.org> (sfid-20140521_124750_937546_CD6B8A93)
Date: Wed, 21 May 2014 12:47:34 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Handle multiple keys while setting tx filters
References: <1400665650-24320-1-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1400665650-24320-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-21 11:47, Rajkumar Manoharan wrote:
> The keycache index is used to abort transmission for given station
> when it goes to sleep state. But the commit "ath9k_hw: Abort transmission
> for sleeping station" is not handling multi-key station. Fix that.
> 
> Cc: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
The use of num_keys in that patch seems quite wrong (or at least very
fragile) to me, you don't decrement it in the DISABLE_KEY case at all.
Maybe you should just remove it, as it does not really help with
speeding things up in any meaningful way.
Also, please make use of ARRAY_SIZE, so you don't need to hardcode the
array size in multiple places.

- Felix
