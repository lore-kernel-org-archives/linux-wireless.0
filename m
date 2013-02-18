Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3BROT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 09:19:59 -0500
Message-ID: <1361197194.8555.17.camel@jlt4.sipsolutions.net> (sfid-20130218_152002_739230_4BF221FB)
Subject: Re: [RFC] mac80211: make CONFIG_MAC80211_MESH=y default
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 18 Feb 2013 15:19:54 +0100
In-Reply-To: <1361042551-15598-1-git-send-email-thomas@cozybit.com> (sfid-20130216_202344_719934_6E0E9CCB)
References: <1361042551-15598-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130216_202344_719934_6E0E9CCB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-02-16 at 11:22 -0800, Thomas Pedersen wrote:
> Increases mac80211 memory use by about 95K.
> 
> At least Ubuntu, Debian, and Arch Linux already enable
> this in their default kernels.

*shrug*

I guess I don't really see a problem with this, although only a small
subset of drivers really supports it. Anyone really wanting to build for
a small system will probably turn it off anyway.

OTOH, if distros enable it, I also don't see much point in changing
it ;-)

What might be interesting is for drivers to somehow indicate they
support it? But you wouldn't necessarily want drivers to "select MESH",
so it'd probably have to be something like not allowing mesh to be
turned on if no driver is turned on that has it? But that makes it
complicated again, so it's all probably not worth it.

johannes

