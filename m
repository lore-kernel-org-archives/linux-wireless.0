Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46977 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759848Ab1ENDxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 23:53:00 -0400
Received: by vws1 with SMTP id 1so2228922vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 20:52:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305331247.680.7.camel@jlt3.sipsolutions.net>
References: <1305203138.3461.24.camel@jlt3.sipsolutions.net>
 <BANLkTinDyLyVX3HFHU7i4GFUi8SixOdzAQ@mail.gmail.com> <1305270793.3487.3.camel@jlt3.sipsolutions.net>
 <BANLkTi=R_Eyz8+iZsk+=Gs4vaNo-0eUVng@mail.gmail.com> <1305331247.680.7.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 13 May 2011 20:52:39 -0700
Message-ID: <BANLkTinYGGnGoE2jeuAmEYGW7HyBsV2+BA@mail.gmail.com> (sfid-20110514_055306_691497_A4E85D86)
Subject: Re: mesh RCU issues
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 5:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-05-13 at 13:28 -0700, Javier Cardona wrote:
>
>> diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
>> index 83ce48e..1db8bba 100644
>> --- a/net/mac80211/mesh_pathtbl.c
>> +++ b/net/mac80211/mesh_pathtbl.c
> [snip]
>
> With this patch, I get the warnings below.

Thanks.  Any ideas on how to fix sparse?  I'd like to see those too :)

> The locking ones are definitely genuine bugs,

I'm not sure I fully understand the sparse message... would this fix
the two locking warnings?

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 83ce48e..fbf0c28 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -376,8 +376,10 @@ void mesh_mpath_table_grow(void)

        rcu_read_lock();
        newtbl = mesh_table_alloc(rcu_dereference(mesh_paths)->size_order + 1);
-       if (!newtbl)
+       if (!newtbl) {
+               rcu_read_unlock();
                return;
+       }
        write_lock_bh(&pathtbl_resize_lock);
        oldtbl = mesh_paths;
        if (mesh_table_grow(mesh_paths, newtbl) < 0) {
@@ -400,8 +402,10 @@ void mesh_mpp_table_grow(void)

        rcu_read_lock();
        newtbl = mesh_table_alloc(rcu_dereference(mpp_paths)->size_order + 1);
-       if (!newtbl)
+       if (!newtbl) {
+               rcu_read_unlock();
                return;
+       }
        write_lock_bh(&pathtbl_resize_lock);
        oldtbl = mpp_paths;
        if (mesh_table_grow(mpp_paths, newtbl) < 0) {



Javier
