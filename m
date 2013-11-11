Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45270 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KKRMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 12:12:44 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so1238743lbi.0
        for <linux-wireless@vger.kernel.org>; Mon, 11 Nov 2013 09:12:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384178599.14334.19.camel@jlt4.sipsolutions.net>
References: <1383907287-2925-1-git-send-email-janusz.dziedzic@tieto.com> <1384178599.14334.19.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 11 Nov 2013 18:12:22 +0100
Message-ID: <CAB=NE6VZX=9d-+ZfghTJRqKyds1cCESVSYDopiX0OBC4fpapfw@mail.gmail.com> (sfid-20131111_181247_213054_09F88D01)
Subject: Re: [PATCH 1/3] cfg80211: DFS check dfs_region before CAC
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 11, 2013 at 3:03 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2013-11-08 at 11:41 +0100, Janusz Dziedzic wrote:
>
>> +     rcu_read_lock();
>> +     regdom = rcu_dereference(cfg80211_regdomain);
>> +     dfs_region = regdom->dfs_region;
>> +     rcu_read_unlock();
>
> Isn't all of this valid to dereference under RTNL anyway? See
> get_cfg80211_regdom()

Also note that we have wiphy->regd too, so that should be considered,
if present that should be used.

  Luis
