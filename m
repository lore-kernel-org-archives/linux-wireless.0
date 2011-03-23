Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35539 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1CWWNE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 18:13:04 -0400
Message-ID: <4D8A7069.6090208@openwrt.org>
Date: Wed, 23 Mar 2011 23:12:57 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sam Leffler <sleffler@google.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 05/10] ath9k_hw: remove pCap->total_queues
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>	<1300910253-28189-2-git-send-email-nbd@openwrt.org>	<1300910253-28189-3-git-send-email-nbd@openwrt.org>	<1300910253-28189-4-git-send-email-nbd@openwrt.org>	<1300910253-28189-5-git-send-email-nbd@openwrt.org> <AANLkTinhxdQqjhBXFh6akhkegzrqSpYSgC5=gPhYsp2-@mail.gmail.com>
In-Reply-To: <AANLkTinhxdQqjhBXFh6akhkegzrqSpYSgC5=gPhYsp2-@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-23 11:05 PM, Sam Leffler wrote:
> On Wed, Mar 23, 2011 at 12:57 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> The EEPROM contains a field that can restrict the number of hardware queues,
>> however this is not only useless (all the known chips contain the same
>> number of hardware queues), but also potentially dangerous in case of a
>> misprogrammed EEPROM (could trigger driver crashes), so let's just ignore
>> it completely.
> 
> I can't say if there will ever be h/w w/ different #'s of tx q's but I
> think you're better off just capping any value read from eeprom to
> guard against the very unlikely scenario of misprogramming.
I think when chips with fewer or more tx queues show up, we should make
that depend on the SREV, not the EEPROM data.

- Felix
