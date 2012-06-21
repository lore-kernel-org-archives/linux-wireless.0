Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2FUTpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 15:45:22 -0400
Message-ID: <1340307920.4489.45.camel@jlt3.sipsolutions.net> (sfid-20120621_214527_227038_2C05F539)
Subject: Re: [PATCH] mac80211: clear ifmgd->bssid only after building DELBA
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 21 Jun 2012 21:45:20 +0200
In-Reply-To: <1338538443-23172-1-git-send-email-eliad@wizery.com> (sfid-20120601_101426_512766_847B35B5)
References: <1338538443-23172-1-git-send-email-eliad@wizery.com>
	 (sfid-20120601_101426_512766_847B35B5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-01 at 11:14 +0300, Eliad Peller wrote:
> ieee80211_set_disassoc() clears ifmgd->bssid before
> building DELBA frames, resulting in frames with invalid
> bssid ("00:00:00:00:00:00").
> 
> Fix it by clearing ifmgd->bssid only after building
> all the needed frames.
> 
> After this change, we no longer need to save the
> bssid (before clearing it), so remove the local array.

Applied to mac80211.git, sorry I missed this, I thought John had picked
it up. I guess I'll have to send a pull request with this patch soon :)

johannes

