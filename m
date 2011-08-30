Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55542 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434Ab1H3KoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 06:44:25 -0400
Message-ID: <4E5CBEFE.1010306@openwrt.org> (sfid-20110830_124428_567265_24D70614)
Date: Tue, 30 Aug 2011 12:44:14 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Adrian Chadd <adrian@freebsd.org>
Subject: Re: [PATCH] ath9k_hw: Fix fast clock support for AR9280 v2.0+
References: <1314699958-4951-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1314699958-4951-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-30 12:25 PM, Rajkumar Manoharan wrote:
> To enable fast clock support on 5GHz for AR9280 v2.0+ chips,
> mac version alone is not sufficient. It also depends on eeprom
> values.
No, it doesn't. The check is bogus, even though it's present in the 
internal atheros codebase. All AR9280 can do fastclock even though on 
some the EEPROM flag is disabled.

- Felix
