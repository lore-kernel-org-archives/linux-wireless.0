Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1EDM3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 08:29:03 -0400
Subject: Re: [PATCH 05/13] nl80211: Let userspace drive the peer link
 management states.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1304467039-7730-6-git-send-email-javier@cozybit.com> (sfid-20110504_015801_001265_A955B26B)
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-6-git-send-email-javier@cozybit.com>
	 (sfid-20110504_015801_001265_A955B26B)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:28:27 +0200
Message-ID: <1304512107.3563.13.camel@jlt3.sipsolutions.net> (sfid-20110504_142907_480884_E9B16C5C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:

> +++ b/include/linux/nl80211.h
> @@ -902,6 +902,9 @@ enum nl80211_commands {
>   * @NL80211_ATTR_SUPPORT_MESH_AUTH: Currently, this means the underlying driver
>   *	allows auth frames in a mesh to be passed to userspace for processing via
>   *	the @NL80211_MESH_SETUP_USERSPACE_AUTH flag.
> + * @NL80211_ATTR_STA_PLINK_STATE: The state of a mesh peer link. Used when
> + *      userspace is driving the peer link management state machine.
> + *      @NL80211_MESH_SETUP_USERSPACE_AMPE must be enabled.

What values are contained in this field?


> +++ b/include/net/cfg80211.h
> @@ -372,6 +372,33 @@ enum plink_actions {
>  };
>  
>  /**
> + * enum plink_states - state of a mesh peer link finite state machine

Looks like you want these, but they're definitely in the wrong file
then.

johannes

