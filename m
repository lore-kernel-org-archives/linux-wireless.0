Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab1HHNYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:24:34 -0400
Subject: Re: [PATCH 4/6] mac80211: update mesh peering frame format
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1311638357-28740-5-git-send-email-thomas@cozybit.com> (sfid-20110726_020035_271179_DC9E109E)
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
	 <1311638357-28740-5-git-send-email-thomas@cozybit.com>
	 (sfid-20110726_020035_271179_DC9E109E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:24:28 +0200
Message-ID: <1312809868.4372.33.camel@jlt3.sipsolutions.net> (sfid-20110808_152437_666312_AC1B472C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-25 at 16:59 -0700, Thomas Pedersen wrote:
 
> -#define PLINK_GET_LLID(p) (p + 4)
> -#define PLINK_GET_PLID(p) (p + 6)
> +#define PLINK_GET_LLID(p) (p + 2)
> +#define PLINK_GET_PLID(p) (p + 4)

This is a more tangential comment -- but I'd feel more comfortable with
the code if these macros were removed and some structs overlaid the IEs
instead. But definitely not as part of this patch -- hence tangential.
 
> +	case WLAN_CATEGORY_SELF_PROTECTED:
> +		switch (mgmt->u.action.u.self_prot.action_code) {
> +		case WLAN_SP_MESH_PEERING_OPEN:
> +		case WLAN_SP_MESH_PEERING_CLOSE:
> +		case WLAN_SP_MESH_PEERING_CONFIRM:
> +			if (!ieee80211_vif_is_mesh(&sdata->vif))
> +				goto invalid;
> +			if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
> +				/* userspace handles this frame */

Will this compile in the CONFIG_MAC80211_MESH=n case? It seems like it
might not? Do you routinely test that?

johannes

