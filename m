Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57027 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab1HHNf7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:35:59 -0400
Subject: Re: [PATCH 1/2] mac80211: refactor sta_info_insert_rcu to 3 main
 stages
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1311715772-8855-1-git-send-email-guy@wizery.com> (sfid-20110726_233144_501539_6CB55590)
References: <1311715772-8855-1-git-send-email-guy@wizery.com>
	 (sfid-20110726_233144_501539_6CB55590)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:35:57 +0200
Message-ID: <1312810557.4372.34.camel@jlt3.sipsolutions.net> (sfid-20110808_153602_390379_41651C64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just a cursory look, I'll send a more detailed review later, but I
wanted to ask John to not merge this for now; 

> +static int sta_info_insert_adhoc(struct sta_info *sta) __acquires(RCU)

_ibss would be preferred

> +static int sta_info_insert_mgd(struct sta_info *sta) __acquires(RCU)

_mgd is terribly misleading, this will be done for all modes other than
IBSS.

johannes


