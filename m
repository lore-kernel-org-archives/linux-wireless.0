Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:56913 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbZGOSkN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 14:40:13 -0400
Received: by wf-out-1314.google.com with SMTP id 26so1296935wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 11:40:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247681863.10754.26.camel@johannes.local>
References: <1247680936-21513-1-git-send-email-andrey@cozybit.com>
	 <1247681863.10754.26.camel@johannes.local>
Date: Wed, 15 Jul 2009 11:40:13 -0700
Message-ID: <45e8e6c40907151140j270aa24dl6336c3c291a971af@mail.gmail.com>
Subject: Re: [PATCH] mac80211: don't sleep in mesh_path_add allocation
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 11:17 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-07-15 at 11:02 -0700, Andrey Yurovsky wrote:
>> mesh_path_add allocates an mpath and a node but it is called with RCU
>> held.  Use the GFP_ATOMIC flag to prevent these allocations from
>> sleeping since otherwise we can hit the following sleep-while-atomic:
>
> This isn't sufficient, quoting from the function, highlight added:
>
> int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
> {
> ...
>        if (grow) {
>                struct mesh_table *oldtbl, *newtbl;
>
>                write_lock(&pathtbl_resize_lock);
>                oldtbl = mesh_paths;
>                newtbl = mesh_table_grow(mesh_paths);
>                if (!newtbl) {
>                        write_unlock(&pathtbl_resize_lock);
>                        return 0;
>                }
>                rcu_assign_pointer(mesh_paths, newtbl);
>                write_unlock(&pathtbl_resize_lock);
>
> *******         synchronize_rcu();
>                mesh_table_free(oldtbl, false);
>        }
> ...
> }
>
> johannes
>

Yes, we'll address growing the issue separately.  Ok, we'll send a new
patch for the allocations as well as growing the table in the future.

  -Andrey
