Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42986 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1DOHA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:00:58 -0400
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH 2/2] mwl8k: setting IEEE80211_HW_CRYPTO_ENABLED for AP mode
References: <20110415045430.GA11530@hertz.marvell.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Fri, 15 Apr 2011 10:00:53 +0300
In-Reply-To: <20110415045430.GA11530@hertz.marvell.com> (Yogesh Ashok Powar's message of "Fri\, 15 Apr 2011 10\:24\:38 +0530")
Message-ID: <87mxjshuca.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yogesh Ashok Powar <yogeshp@marvell.com> writes:

> For AP mode, driver sets IEEE80211_HW_CRYPTO_ENABLED hardware flag to avoid
> mac80211 reserving tail room space for crypto suite.

A small style issue:

> +	/* This is needed to avoid tailroom calculations */
> +	hw->flags |= priv->ap_fw ? IEEE80211_HW_CRYPTO_ENABLED : 0;

Why not just:

if (priv->ap_fw)
   hw->flags |= IEEE80211_HW_CRYPTO_ENABLED

A lot easier to read.

-- 
Kalle Valo
