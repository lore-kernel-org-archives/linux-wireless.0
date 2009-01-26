Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:61431 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbZAZXLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 18:11:25 -0500
Received: by fxm13 with SMTP id 13so1638309fxm.13
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 15:11:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dac45060901260548n7e541464ufaa7d1bb961f7573@mail.gmail.com>
References: <dac45060901260548n7e541464ufaa7d1bb961f7573@mail.gmail.com>
Date: Mon, 26 Jan 2009 15:11:23 -0800
Message-ID: <45e8e6c40901261511r431a7457u24019fc9efaaa36c@mail.gmail.com> (sfid-20090127_001136_064406_E739E4AD)
Subject: Re: A short question about mesh routing
From: Andrey Yurovsky <andrey@cozybit.com>
To: Mark Ryden <markryde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark.  The current implementation has the PREQ mechanism and
implements on demand patch selection.  The draft indeed specifies that
the routing protocol has both on demand and proactive path selection
and proactive can be implemented using the PREQ mechanism or the RANN
mechanism.  The current implementation does not have the RANN
mechanism so perhaps implementing proactive path selection using PREQ
would be a good way to start.

  -Andrey

On Mon, Jan 26, 2009 at 5:48 AM, Mark Ryden <markryde@gmail.com> wrote:
> Hello,
> - Mesh routing in Linux implements the hwmp protocol.
> - I had delved into the mesh code in the latest git wireless-testing tree.
> - The part for on demand routing is implemented via the
> mesh_path_start_discovery()  and other methods and via
> sending/receiving the MPATH_PREQ /MPATH_PREP/MPATH_PERR messages  (see
> mesh_hwmp.c)
>
> - My question is about proactive routing: First, AFAIK,  proactive
> routing is mandatory in hwmp (the name hybrid suggests it, proactive
> routing and on demand
> routing). This technique should proactively build a tree topology.
> AFAIK, there should be at least one Portal is present in the network (so
> that the tree shall be rooted at that Portal).
> However, I could not find the Root Announcement (RANN) message which is needed
> proactive routing in the mac80211 stack.
>
> Is proactive routing implemented at all in the mesh code in the Linux kernel?
>
> Regards,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
