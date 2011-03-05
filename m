Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1CEU0M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 15:26:12 -0500
Subject: Re: [PATCH 1/4 v3] mac80211: Enable mesh security from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
In-Reply-To: <1299356245-13926-1-git-send-email-javier@cozybit.com>
References: <1299288252-28314-2-git-send-email-thomas@cozybit.com>
	 <1299356245-13926-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 21:26:09 +0100
Message-ID: <1299356769.29845.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-03-05 at 12:17 -0800, Javier Cardona wrote:
> Userspace can enable mesh security by providing an RSN IE and setting
> the MESH_SETUP_ENABLE_SECURITY flag.
> 
> Also, rename vendor_ie to just ie to reflect that the same attribute may
> be used to pass other IEs, like for instance RSN.
> 
> Changes from v2: (from Johannes)
>  - Fix API backward compatibilty of NL80211_MESH_SETUP_IE
>  - Remove check for presence of RSN IE

Should be after --- really :-)

> + * @is_secure: or not

Given what we just discussed over in the other thread, should we rename
this to "userspace_station_mgmt" or something like that?

Also, does it make sense to advertise support for this somehow?
Otherwise the new tools will have strange failure cases on older
kernels; and I can also imagine situations where the mesh APIs are in
firmware or so that can't cope with userspace station mgmt.

johannes

