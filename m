Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39840 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbbDXKmC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:42:02 -0400
Message-ID: <1429872119.1852.39.camel@sipsolutions.net> (sfid-20150424_124207_271121_832E73E9)
Subject: Re: [PATCH v2 5/7] mac80211: Adjust chan_ctx when assigning
 reserved vif
From: Johannes Berg <johannes@sipsolutions.net>
To: andrei.otc@gmail.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Apr 2015 12:41:59 +0200
In-Reply-To: <1429606392-7776-1-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150421_105405_673537_1E313CE6)
References: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
	 <1429606392-7776-1-git-send-email-andrei.otcheretianski@intel.com>
	 (sfid-20150421_105405_673537_1E313CE6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-21 at 11:53 +0300, andrei.otc@gmail.com wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> When a vif is assigned to a reserved channel context (during CSA, for example)

This .. doesn't make much sense. vifs aren't assigned to channel
contexts, it's the other way around. I guess I'll rewrite that to "When
a vif starts using a reserved  channel context (...)"

> the width of this chanctx should be adjusted to be the maximum between the
> reserved chandef and all the chandefs of other assigned vifs.

This is not what you do - you don't take anything in the chanctx into
account. ieee80211_chanctx_non_reserved_chandef() just recalculates the
required chanctx, and you're fixing the code to actually apply the
recalculated value.

> Not doing so would result in using chanctx with narrower width than actually
> required. Fix this by calling ieee80211_change_chanctx with the widest common
> chandef. This both changes the chanctx's width and recalcs min_def.

This seems possible, yeah.


>         chandef = ieee80211_chanctx_non_reserved_chandef(local, new_ctx,
>                                 &sdata->reserved_chandef);

>  	if (WARN_ON(!chandef))
>  		return -EINVAL;
>  
> +	ieee80211_change_chanctx(local, new_ctx, chandef);
> +
>  	vif_chsw[0].vif = &sdata->vif;
>  	vif_chsw[0].old_ctx = &old_ctx->conf;
>  	vif_chsw[0].new_ctx = &new_ctx->conf;
[...]
> 	ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);

Hmm. (added more context)

The code here seems to be wrong though. It shouldn't overwrite
reserved_chandef, or it shouldn't call ieee80211_vif_update_chandef()
with it, as the vif's bss_conf.chandef should represent what *this* vif
wants/needs, while you're now putting there what the *combination*
requires in the chandef.

That's clearly wrong - please submit a new patch that fixes all the
issues in these functions.

johannes

