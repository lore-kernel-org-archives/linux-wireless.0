Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:34262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1CWWFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 18:05:48 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id p2NM5l1X026860
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 15:05:47 -0700
Received: from wwa36 (wwa36.prod.google.com [10.241.241.36])
	by wpaz29.hot.corp.google.com with ESMTP id p2NM5jaa004170
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 15:05:45 -0700
Received: by wwa36 with SMTP id 36so9763576wwa.25
        for <linux-wireless@vger.kernel.org>; Wed, 23 Mar 2011 15:05:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300910253-28189-5-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
	<1300910253-28189-2-git-send-email-nbd@openwrt.org>
	<1300910253-28189-3-git-send-email-nbd@openwrt.org>
	<1300910253-28189-4-git-send-email-nbd@openwrt.org>
	<1300910253-28189-5-git-send-email-nbd@openwrt.org>
Date: Wed, 23 Mar 2011 15:05:44 -0700
Message-ID: <AANLkTinhxdQqjhBXFh6akhkegzrqSpYSgC5=gPhYsp2-@mail.gmail.com>
Subject: Re: [PATCH 05/10] ath9k_hw: remove pCap->total_queues
From: Sam Leffler <sleffler@google.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 23, 2011 at 12:57 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> The EEPROM contains a field that can restrict the number of hardware queues,
> however this is not only useless (all the known chips contain the same
> number of hardware queues), but also potentially dangerous in case of a
> misprogrammed EEPROM (could trigger driver crashes), so let's just ignore
> it completely.

I can't say if there will ever be h/w w/ different #'s of tx q's but I
think you're better off just capping any value read from eeprom to
guard against the very unlikely scenario of misprogramming.

-Sam
