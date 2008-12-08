Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yorgi.telenet-ops.be ([195.130.133.69]:53225 "EHLO
	yorgi.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYLHQEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 11:04:04 -0500
Received: from nelson.telenet-ops.be (nelson.telenet-ops.be [195.130.133.66])
	by yorgi.telenet-ops.be (Postfix) with ESMTP id D89DF681E65
	for <linux-wireless@vger.kernel.org>; Mon,  8 Dec 2008 17:04:02 +0100 (CET)
Message-ID: <493D454A.7000901@telenet.be> (sfid-20081208_170410_463891_4885052B)
Date: Mon, 08 Dec 2008 17:03:22 +0100
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: David Shwatrz <dshwatrz@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Three short questions about iwlwifi
References: <31436f4a0812072238x5d7a2cc8saeec3eb44726b0c7@mail.gmail.com>
In-Reply-To: <31436f4a0812072238x5d7a2cc8saeec3eb44726b0c7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



David Shwatrz wrote:
> Hello,
> 
> I tried to delve into the iwlwifi code and I have
> 3 short questions about iwlwifi; I hope that I can get some advice here.
>
what i have picked up. In no way the best possible answers.
 	
> 
> 1) I see that there seems to be common code in 3945 and agn.
> Are there intentions to make use of agn in 3945 in the future to avoid
> code duplication, or is it a design decision to make a full separation between
> 3945 and agn (so even when it is possible to use common code, to avoid
> it in order
> not to cause possible problems in the future).
The codebase has taken on quite a few forms. There used to be a somewhat unified
codebase, which through quite a few of defines was expanded at compile time.
For several reasons it was split. Then
some states where iwl3945 was split off and the 4965 later got the 5xxx parts
'added on' ;-). There have been several mentions of a desire to turn a large part of
the common code in a sort of library. However this will still require lots of work.
The current way the code is split up with the iwl-* files which were -afaik- meant
to be the start of a library requires all callers to have the same priv struct.
which makes it harder to extend for 3945(unless once again creating a compile time split).

So intention yes, but...
> 
> 2)  In some places in iwlwifi we have:
> #ifdef IEEE80211_CONF_CHANNEL_SWITCH.
> 
> For example, iwl-agn.c or iwl3945-base.c.
> What is this define ? is it not (an uneeded) legacy from when the drivers
> were not part of the tree?
O wow, that took me back :-), the feature indeeds appears to be removed entirely
from mac80211 so this is probably dead code. Or code waiting for the return of the
feature. It's probably past the point where it makes sense to keep the code for
backwards compatibilities sake.

> 
> 3) Little question about implementation:
> 
> In iwl3945-base.c:
> iwl3945_commit_rxon() calls iwl3945_clear_stations_table(priv);
> so is it necessary in iwl3945_set_mode() to call also
> iwl3945_clear_stations_table() , since we anyhow call iwl3945_commit_rxon()
> afterwards ?
> the only thing iwl3945_clear_stations_table() does is zeros
> priv->num_stations and zeros priv->stations.
> 
This is pretty volatile code. And you're assumption doesn't take into account
what happens when iwl3945_commit_rxon() takes an early out due to some error.

for example, during rfkill is on set_mode() will clear its station table, but the rxon
command is never commited.

However i can't say for sure that we can't do without that line. But it probably
isn't a bad idea to give it extra thought.

> David S
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
