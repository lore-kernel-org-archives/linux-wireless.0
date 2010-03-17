Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:35079 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755565Ab0CQT0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 15:26:49 -0400
Date: Wed, 17 Mar 2010 12:26:38 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: Add local-state-change-only
 auth/deauth/disassoc
Message-ID: <20100317192638.GA30167@jm.kir.nu>
References: <20100313195335.GA2420@jm.kir.nu>
 <1268842963.5989.20.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268842963.5989.20.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 09:22:43AM -0700, Johannes Berg wrote:
> On Sat, 2010-03-13 at 21:53 +0200, Jouni Malinen wrote:
> >  static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,

> I'm wondering now why we even bother sending events to userspace when it
> itself triggered the transition?

You are not the only one who was trying to figure that out.. ;-) I did
not come up with any particularly good reason when working on the patch,
but decided to avoid breaking any old behavior in the first version. If
we are fine with dropping those events for locally triggered
transitions, these areas here could be optimized.

-- 
Jouni Malinen                                            PGP id EFC895FA
