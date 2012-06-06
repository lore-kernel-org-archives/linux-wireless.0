Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2FFIz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:55:57 -0400
Message-ID: <1338972956.4513.28.camel@jlt3.sipsolutions.net> (sfid-20120606_105600_957434_2C5E7787)
Subject: Re: [RFC 05/14] cfg80211: add channel tracking for AP and mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:55:56 +0200
In-Reply-To: <1338203942-5667-6-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-6-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> We need to know which channel is used by a running
> AP and mesh for channel context accounting and
> finding matching/active interface combination.
> 
> STA/IBSS have current_bss already which allows us
> to check which channel a vif is tuned to.

For IBSS this assumption is dangerous though since the channel can
change at will when it decides to merge with a different cell on a
different channel.

I don't mind tracking the channel for AP/mesh of course.

johannes

