Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab3AZW6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jan 2013 17:58:34 -0500
Message-ID: <1359241136.9086.0.camel@jlt4.sipsolutions.net> (sfid-20130126_235844_032457_426457DC)
Subject: Re: [PATCH v2] mac80211: dynamic short slot time for MBSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Sat, 26 Jan 2013 23:58:56 +0100
In-Reply-To: <1359232645-10563-1-git-send-email-thomas@cozybit.com> (sfid-20130126_213837_005675_90531EEB)
References: <1359232645-10563-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130126_213837_005675_90531EEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-01-26 at 12:37 -0800, Thomas Pedersen wrote:

> +	u32 rates, changed = 0;

> +		for_each_set_bit(i, (unsigned long *)&rates,
> +				 sizeof(rates) * BITS_PER_BYTE) {

this is broken on 64-bit architectures.

johannes

