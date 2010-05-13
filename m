Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49884 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0EMGCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 02:02:35 -0400
Subject: Re: [PATCH] cfg80211: Parse channel_type in NL80211_CMD_JOIN_IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: Benoit Papillault <benoit.papillault@free.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201005130956.25680.br1@einfach.org>
References: <1273698460-18061-1-git-send-email-benoit.papillault@free.fr>
	 <201005130956.25680.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 May 2010 08:02:31 +0200
Message-ID: <1273730552.3761.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-13 at 09:56 +0900, Bruno Randolf wrote:
> On Thursday 13 May 2010 06:07:37 Benoit Papillault wrote:
> > The channel_type field is filled by iw and parse by cfg80211 before
> > being sent to mac80211 for instance (we also check if the specified
> > channel is capable of ht40+, ht40- or ht20). This information is needed
> > to properly configure an HT IBSS.

> do you think this could also be used to configure "pure G" channels? remember 
> the discussion we had about the basic rate set in IBSS? if we could use this 
> to configure the channel as "pure G" we could use a basic rate set with higher 
> rates (ERP mandatory rates: 1, 2, 5.5, 11, 6, 12, 24). i still need this 
> feature in order to configure higher-thruput G-only IBSS...

No, that would be a basic/mandatory rateset configuration for a regular
20MHz channel.

johannes

