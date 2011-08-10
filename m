Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1HJNrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:47:14 -0400
Subject: Re: [PATCH 7/8] {nl,cfg,mac}80211: let userspace set RANN interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1312933511-9486-8-git-send-email-thomas@cozybit.com> (sfid-20110810_014705_414621_0792BFAD)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-8-git-send-email-thomas@cozybit.com>
	 (sfid-20110810_014705_414621_0792BFAD)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:47:11 +0200
Message-ID: <1312984031.4325.4.camel@jlt3.sipsolutions.net> (sfid-20110810_154722_272384_AAFB2A13)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:

>  	mod_timer(&ifmsh->mesh_path_root_timer,
> -		  round_jiffies(jiffies + IEEE80211_MESH_RANN_INTERVAL));
> +		  round_jiffies(jiffies +
> +			  usecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPRannInterval * 1024)));

TU_TO_EXP_TIME ?

johannes

