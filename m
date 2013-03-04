Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3CDPJW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:09:22 -0500
Message-ID: <1362409756.21028.15.camel@jlt4.sipsolutions.net> (sfid-20130304_160926_680215_0F83107A)
Subject: Re: [PATCH 1/6] nl80211: explicit userspace MPM
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Mon, 04 Mar 2013 16:09:16 +0100
In-Reply-To: <1362204172-28307-1-git-send-email-thomas@cozybit.com> (sfid-20130302_070412_528831_6E0E95CB)
References: <1362204172-28307-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130302_070412_528831_6E0E95CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 22:02 -0800, Thomas Pedersen wrote:

> @@ -4769,8 +4770,11 @@ static int nl80211_parse_mesh_setup(struct genl_info *info,
>  		setup->ie = nla_data(ieattr);
>  		setup->ie_len = nla_len(ieattr);
>  	}
> +	setup->user_mpm = nla_get_flag(tb[NL80211_MESH_SETUP_USERSPACE_MPM]);

Should check the feature bit here?

johannes

