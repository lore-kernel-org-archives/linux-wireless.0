Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36284 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab2HTLVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:21:23 -0400
Message-ID: <1345461679.4459.11.camel@jlt3.sipsolutions.net> (sfid-20120820_132126_709578_56E6FB97)
Subject: Re: [PATCH v2] mac80211: avoid using synchronize_rcu in
 ieee80211_set_probe_resp
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Eyal Shapira <eyal@wizery.com>
Date: Mon, 20 Aug 2012 13:21:19 +0200
In-Reply-To: <1344252376-20971-1-git-send-email-arik@wizery.com> (sfid-20120806_132621_600765_F616ABEB)
References: <1344252376-20971-1-git-send-email-arik@wizery.com>
	 (sfid-20120806_132621_600765_F616ABEB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 14:26 +0300, Arik Nemtsov wrote:
> From: Eyal Shapira <eyal@wizery.com>
> 
> This could take a while (100ms+) and may delay sending assoc resp
> in AP mode with WPS or P2P GO (as setting the probe resp takes place
> there). We've encountered situations where the delay was big enough
> to cause connection problems with devices like Galaxy Nexus.
> Switch to using call_rcu with a free handler.

Applied, thanks.

johannes

