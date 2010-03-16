Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab0CQAyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:54:17 -0400
Subject: Re: [RFC] cfg80211: Add local-state-change-only
 auth/deauth/disassoc
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100313195335.GA2420@jm.kir.nu>
References: <20100313195335.GA2420@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 15:18:14 -0700
Message-ID: <1268777894.8918.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-13 at 21:53 +0200, Jouni Malinen wrote:
> cfg80211 is quite strict on allowing authentication and association
> commands only in certain states. In order to meet these requirements,
> user space applications may need to clear authentication or
> association state in some cases. Currently, this can be done with
> deauth/disassoc command, but that ends up sending out Deauthentication
> or Disassociation frame unnecessarily. Add a new nl80211 attribute to
> allow this sending of the frame be skipped, but with all other
> deauth/disassoc operations being completed.

Just a thought ...

mac80211 no longer maintains auth state at all when the auth is not in
process, so should we, instead of passing this all through mac80211,
make it cfg80211-only? Ok that doesn't work for the assoc part, but for
auth it should?

johannes


