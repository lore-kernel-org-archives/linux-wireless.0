Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52794 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab1CHOMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 09:12:51 -0500
Subject: Re: [RFC 3/9] mac80211: add WoW param to .start/.stop callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1299011804-13899-4-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
	 <1299011804-13899-4-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 15:12:49 +0100
Message-ID: <1299593569.4676.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 22:36 +0200, Eliad Peller wrote:
> Add a param which contains the enabled Wake-On-Wireless triggers,
> so lower drivers prepare themselves to suspend/resume
> (e.g. configure triggers to fw, mask irqs, etc.)

I'm not sure I like using the start/stop API for suspend in this way.
Basically, I think what happens with this is that we're saying to the
driver "stop(but really don't because of WoW)". That seems a bit strange
to me, wouldn't you agree?

I'm inclined to not use the "deconfigure everything" code in mac80211 in
the case that wow triggers were requested, and instead call suspend() in
the driver with the WoW triggers. Upon resume, also don't reconfigure,
but call resume() instead?

johannes

