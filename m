Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54818 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932843AbbFITqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 15:46:21 -0400
Message-ID: <1433879178.1892.14.camel@sipsolutions.net> (sfid-20150609_214626_883449_08F5D923)
Subject: Re: [PATCH v2] mac80211: Fix double locking on CSA counter update
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, julian.calaby@gmail.com
Date: Tue, 09 Jun 2015 21:46:18 +0200
In-Reply-To: <1433170291-28665-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20150601_165150_599042_C9CB69CD)
References: <1433170291-28665-1-git-send-email-Wojciech.Dubowik@neratec.com>
	 (sfid-20150601_165150_599042_C9CB69CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-01 at 16:51 +0200, Wojciech Dubowik wrote:
> We call rcu locked ieee80211_csa_update_counter from already locked
> section. Fix it by splitting ieee80211_csa_update_counter into
> locked and unlocked variants and use the latter in rcu locked section.

The subject of this patch implies there's a bug ("double locking", which
I'd interpret as "nested locking") and that there's something to fix.

At best, this is an optimisation, can you please label it as such?

johannes

