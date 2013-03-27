Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40396 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3C0TsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 15:48:06 -0400
Message-ID: <1364413680.8388.24.camel@jlt4.sipsolutions.net> (sfid-20130327_204814_267967_A40E9334)
Subject: Re: [PATCH v3] mac80211:  Optimize sta lookup for many VIFs
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 27 Mar 2013 20:48:00 +0100
In-Reply-To: <51533BDD.9010700@candelatech.com>
References: <1364259443-22469-1-git-send-email-greearb@candelatech.com>
	  (sfid-20130326_015732_712534_6202434D) <1364326932.8319.15.camel@jlt4.sipsolutions.net>
	 <51533BDD.9010700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 11:35 -0700, Ben Greear wrote:
> On 03/26/2013 12:42 PM, Johannes Berg wrote:
> > On Mon, 2013-03-25 at 17:57 -0700, greearb@candelatech.com wrote:
> >
> >> v3:  Use rcu_dereference_protected as suggested.
> >
> > Heh.
> >
> >> +		some_sta = rcu_dereference_protected(sta->sdata->some_sta, 1);
> >
> > No no no, you're supposed to give it a proper argument like
> > "lockdep_is_held(&local->sta_mtx)"
> 
> Before I screw this up again..do you prefer that I line up
> method arguments and go over 80 character line length, or
> force the argument leftward to meet the 80 char limit?
> 
> I see no good way to make it fit in 80 chars and also
> line up properly.

Huh, no idea. I guess I'd rather have it less than 80 cols.

johannes

