Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1GNFc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 01:32:59 -0400
Subject: Re: [PATCH] mwifiex: remove wireless.h inclusion and fix resulting
 bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1310607514-30808-1-git-send-email-bzhao@marvell.com>
References: <1310607514-30808-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 07:32:55 +0200
Message-ID: <1310621575.3902.1.camel@jlt3.sipsolutions.net> (sfid-20110714_073308_855156_1E36572B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 18:38 -0700, Bing Zhao wrote:

>  	/* Allocate buffer to store the BSSID list */
> -	buf_size = sizeof(struct mwifiex_bssdescriptor) * IW_MAX_AP;
> +	buf_size = sizeof(struct mwifiex_bssdescriptor) * MWIFIEX_MAX_AP;

By the way, why does mwifiex store "the BSSID list" in a statically
sized table? It seems that this shouldn't be necessary since cfg80211
stores it in a dynamic list and lets drivers get information out again
as well.

johannes

