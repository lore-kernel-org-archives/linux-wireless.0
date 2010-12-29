Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53301 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0L2JOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 04:14:49 -0500
Subject: Re: [PATCH 2/4] mwl8k: Add encapsulation of data packet for crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, mwl8k-devel@cozybit.com,
	buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
In-Reply-To: <1293577297-25755-3-git-send-email-thomas@cozybit.com>
References: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
	 <1293577297-25755-3-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 10:14:46 +0100
Message-ID: <1293614086.3546.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 15:01 -0800, Thomas Pedersen wrote:

> Different head and tail pads will be needed for crypto depending on
> the crypto mode. Add support to encapsulate the packets with
> appropriate pad values. Also, fill the header in case of CCMP.

Err, mac80211 is perfectly capable of generating the CCMP header, you
should use that functionality (and maybe memmove it elsewhere if needed)

johannes

