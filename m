Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab3CZTm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 15:42:26 -0400
Message-ID: <1364326932.8319.15.camel@jlt4.sipsolutions.net> (sfid-20130326_204229_569249_BC9C9998)
Subject: Re: [PATCH v3] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Mar 2013 20:42:12 +0100
In-Reply-To: <1364259443-22469-1-git-send-email-greearb@candelatech.com> (sfid-20130326_015732_712534_6202434D)
References: <1364259443-22469-1-git-send-email-greearb@candelatech.com>
	 (sfid-20130326_015732_712534_6202434D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-25 at 17:57 -0700, greearb@candelatech.com wrote:

> v3:  Use rcu_dereference_protected as suggested.

Heh.

> +		some_sta = rcu_dereference_protected(sta->sdata->some_sta, 1);

No no no, you're supposed to give it a proper argument like
"lockdep_is_held(&local->sta_mtx)"

johannes

