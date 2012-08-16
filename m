Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57890 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab2HPJXm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 05:23:42 -0400
Message-ID: <502CBC15.6090804@openwrt.org> (sfid-20120816_112346_258862_1996DADA)
Date: Thu, 16 Aug 2012 11:23:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: stop btcoex on device suspend
References: <1344496046-2177-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1344496046-2177-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-09 9:07 AM, Rajkumar Manoharan wrote:
> During suspend, the device will be moved to FULLSLEEP state.
> As btcoex is never been stopped, the btcoex timer is running
> and tries to access hw on fullsleep state. Fix that.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Why put ath9k_stop_btcoex here? mac80211 calls drv_stop on suspend, and
ath9k_stop_btcoex is called early in ath9k_stop().

- Felix
