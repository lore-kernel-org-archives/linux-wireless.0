Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab3EFPTb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 May 2013 11:19:31 -0400
Message-ID: <1367853566.8434.8.camel@jlt4.sipsolutions.net> (sfid-20130506_171934_492678_F02CF5A3)
Subject: Re: [PATCH 1/2] cfg80211: Userspace may inform kernel of mesh auth
 method.
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen Twitty <colleen@cozybit.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wirelss <linux-wireless@vger.kernel.org>
Date: Mon, 06 May 2013 17:19:26 +0200
In-Reply-To: <1367608308-588-1-git-send-email-colleen@cozybit.com> (sfid-20130503_211224_065979_10F4624E)
References: <1367608308-588-1-git-send-email-colleen@cozybit.com>
	 (sfid-20130503_211224_065979_10F4624E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Colleen,

>  	if (setup->is_secure)
>  		setup->user_mpm = true;
>  
> +	if (tb[NL80211_MESH_SETUP_AUTH_PROTOCOL]) {
> +		if (!setup->is_authenticated || !setup->is_secure)
> +			return -EINVAL;

Is that really what you want? It seems strange to first check is secured
or authenticated and then allow to set the auth protocol to none, but
that may be fine since I don't really understand the mesh protocol very
well.

However if userspace is in control it can basically do whatever it
likes, so shouldn't you just check "setup->user_mpm"? Or am I
misunderstanding this, and the authentication isn't related to peering
at all?

johannes

