Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752676AbbBZCRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 21:17:33 -0500
Date: Thu, 26 Feb 2015 03:17:31 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, ArikX Nemtsov <arik@wizery.com>
Subject: Re: [PATCH v7 2/3] cfg80211: Add API to change the indoor
	regulatory setting
Message-ID: <20150226021731.GH8749@wotan.suse.de> (sfid-20150226_031736_365072_910CC17A)
References: <1424857624-24944-1-git-send-email-ilan.peer@intel.com> <1424857624-24944-2-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424857624-24944-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 25, 2015 at 04:47:03AM -0500, Ilan Peer wrote:
>  	case NL80211_USER_REG_HINT_INDOOR:
> -		return regulatory_hint_indoor_user();
> +		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
> +		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
> +			owner_nlportid = info->snd_portid;
> +
> +		return regulatory_hint_indoor(is_indoor, owner_nlportid);
>  	default:
>  		return -EINVAL;
>  	}

You are changing this so that this can only work when
NL80211_ATTR_REG_INDOOR is used however this should only
be true if the info->attrs[NL80211_ATTR_SOCKET_OWNER
was set as in the old days the usersapce API allowed
for NL80211_ATTR_REG_INDOOR to not be set. Don't
break old userspace.

Fix that, and it seems fine. While at it please explain
how / who send the userespace hint and that right now
we don't do anything with the country IE indoor / outdoor
flag.

 Luis
