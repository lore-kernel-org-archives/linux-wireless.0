Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1ELMZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 08:25:39 -0400
Subject: mesh RCU issues
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 14:25:38 +0200
Message-ID: <1305203138.3461.24.camel@jlt3.sipsolutions.net> (sfid-20110512_142543_533404_D7A57FF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was reviewing sparse RCU warnings in mac80211...

This seems to be some kind of bad joke:

void mesh_path_timer(unsigned long data)
{
        struct ieee80211_sub_if_data *sdata;
        struct mesh_path *mpath;
   
        rcu_read_lock();
        mpath = (struct mesh_path *) data;
        mpath = rcu_dereference(mpath);
        if (!mpath)
                goto endmpathtimer;

????

And indeed I don't see a del_timer_sync() when the mesh path is freed.
But this is _clearly_ totally bogus. Somebody please fix ASAP.

johannes

