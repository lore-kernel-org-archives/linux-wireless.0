Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1GOJHi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 05:07:38 -0400
Subject: Re: [PATCH v2 4/5] mac80211: move RSN IE to tail of mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1310691023-31844-1-git-send-email-thomas@cozybit.com> (sfid-20110715_025107_430675_CA8483D8)
References: <1310600747-9583-5-git-send-email-thomas@cozybit.com>
	 <1310691023-31844-1-git-send-email-thomas@cozybit.com>
	 (sfid-20110715_025107_430675_CA8483D8)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 11:07:34 +0200
Message-ID: <1310720854.4164.5.camel@jlt3.sipsolutions.net> (sfid-20110715_110741_234083_6F92A235)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 17:50 -0700, Thomas Pedersen wrote:
> The mesh specific beacon IEs go right before the vendor IEs. Add a
> filter that checks for custom IEs (currently just the RSN IE), which
> belong after the TIM, but before HT. Also, ensure we don't add any
> custom IEs twice in mesh_mgmt_ies_add().
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
> 
> v2:
> 	Ensure room for custom IEs in transmitted beacon (Johannes).
> 	We'll be allocating twice as much space as needed for some IEs
> 	(in tail_len and again ie_len), but it shouldn't be a big deal.

Not that I like allocating twice as much, but I don't really care
either.

Maybe you should be doing the cleanups in mesh_mgmt_ies_add()
separately? I'm having a hard time following these changes.

> +               noffset = ieee80211_ie_split_vendor(ifmsh->ie, ifmsh->ie_len,
> +                                                   offset);
> +               if (noffset != offset) {

isn't offset always 0 here? So wouldn't it make more sense to put 0
explicitly?

johannes

