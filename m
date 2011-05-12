Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52521 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab1ELW06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 18:26:58 -0400
Received: by vws1 with SMTP id 1so1468919vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 15:26:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 12 May 2011 15:26:36 -0700
Message-ID: <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com> (sfid-20110513_002703_148673_EB5CAA5B)
Subject: Re: mesh RCU issues
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Thu, May 12, 2011 at 5:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> I was reviewing sparse RCU warnings in mac80211...
>
> This seems to be some kind of bad joke:
>
> void mesh_path_timer(unsigned long data)
> {
>        struct ieee80211_sub_if_data *sdata;
>        struct mesh_path *mpath;
>
>        rcu_read_lock();
>        mpath = (struct mesh_path *) data;
>        mpath = rcu_dereference(mpath);
>        if (!mpath)
>                goto endmpathtimer;
>
> ????

Thanks for cleaning that up.

> And indeed I don't see a del_timer_sync() when the mesh path is freed.

Isn't the call to del_timer_sync() you are looking for in
mesh_path_node_reclaim() ?

> But this is _clearly_ totally bogus. Somebody please fix ASAP.

I'll run sparse and see if I see other rcu warnings that I can fix.

Thanks,

j


> johannes
>
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
