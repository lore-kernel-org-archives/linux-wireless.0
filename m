Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab1KXSVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:21:41 -0500
Subject: Re: [RFC v2 1/8] cfg80211 and nl80211: mesh power mode config
 parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>
In-Reply-To: <1321886416-12597-2-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154143_503349_E0664691)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 <1321886416-12597-2-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154143_503349_E0664691)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:21:37 +0100
Message-ID: <1322158897.5366.28.camel@jlt3.sipsolutions.net> (sfid-20111124_192144_585568_100AC1F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:
> According to IEEE80211s standard a mesh STA maintains a mesh power mode
> for non-peer mesh STAs. Non-peer mesh power mode is a mesh configuration
> parameter so it should be presented in mesh_config structure. Possible
> values for mesh power mode are presented in nl80211_mesh_power_mode
> enumeration. These modes are active, light sleep and deep sleep.

This patch seems a bit strange to me because it adds an nl80211 enum
without an attribute it can be carried in.

> @@ -765,6 +765,8 @@ struct mesh_config {
>  	u16 dot11MeshMaxPeerLinks;
>  	u8  dot11MeshMaxRetries;
>  	u8  dot11MeshTTL;
> +	/* non-peer mesh power save mode */
> +	u8 power_mode;

You're later using casts etc -- shouldn't this be the enum-typed
variable?

johannes

