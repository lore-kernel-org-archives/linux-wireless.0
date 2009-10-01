Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:63521 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbZJAOkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 10:40:06 -0400
Received: by ewy7 with SMTP id 7so246219ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 07:40:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <57b62e7d0910010732m38ab57k916662f9047fcc91@mail.gmail.com>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
	 <1254341787.3959.11.camel@johannes.local>
	 <57b62e7d0910010732m38ab57k916662f9047fcc91@mail.gmail.com>
Date: Thu, 1 Oct 2009 16:40:09 +0200
Message-ID: <57b62e7d0910010740t67a96d88h59b10161844f2836@mail.gmail.com>
Subject: Re: VLAN traffic appearing on the wrong iface
From: =?UTF-8?B?Qmxhxb4gQmHEjW5paw==?= <bacnik@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Meh, I messed up the patch. Take two, hopefully better. Sorry.

Regards, Blaz


--- a/net/mac80211/sta_info.c	2009-10-01 16:24:34.000000000 +0200
+++ b/net/mac80211/sta_info.c	2009-10-01 16:27:31.000000000 +0200
@@ -498,7 +498,7 @@ static void __sta_info_unlink(struct sta
 			       &(*sta)->sta);
 	}

-	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+	if (ieee80211_vif_is_mesh(&(*sta)->sdata->vif)) {
 		mesh_accept_plinks_update(sdata);
 #ifdef CONFIG_MAC80211_MESH
 		del_timer(&(*sta)->plink_timer);


On Thu, Oct 1, 2009 at 4:32 PM, Blaž Bačnik <bacnik@gmail.com> wrote:
> On Wed, Sep 30, 2009 at 10:16 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> I can't reproduce that oops, but we have a fix to the issue which I'll
>> send separately.
>
> Thanks for patches. However, I've investigated that oops and I don't really
> understand it. Problem seems to be in __sta_info_unlink where code checks
> if vif is a mesh. Since this is a vlan iface, sdata used actually belongs to ap
> iface due to previous if but that really shouldn't be a problem since ap's
> sdata should have vif->type as well, right?
>
> While testing I've found out that sdata_of_ap->vif points to funny addresses
> like 248 and such. So I've changed the code and that seems to have fixed
> oops. I think this is now the right behaviour, anyway.
>
> --- a/net/mac80211/sta_info.c   2009-10-01 16:27:31.000000000 +0200
> +++ b/net/mac80211/sta_info.c   2009-10-01 16:24:34.000000000 +0200
> @@ -498,7 +498,7 @@ static void __sta_info_unlink(struct sta
>                               &(*sta)->sta);
>        }
>
> -       if (ieee80211_vif_is_mesh(&(*sta)->sdata->vif)) {
> +       if (ieee80211_vif_is_mesh(&sdata->vif)) {
>                mesh_accept_plinks_update(sdata);
>  #ifdef CONFIG_MAC80211_MESH
>                del_timer(&(*sta)->plink_timer);
>
