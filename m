Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56774 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJIHiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 03:38:13 -0400
Message-ID: <1412840290.1828.1.camel@jlt4.sipsolutions.net> (sfid-20141009_093817_580476_10C7808E)
Subject: Re: [PATCH v4 2/2] mac80211: implement cfg80211_ops to query mesh
 proxy path table
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless @ vger . kernel . org"
	<linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Thu, 09 Oct 2014 09:38:10 +0200
In-Reply-To: <1410505130-7271-3-git-send-email-henning.rogge@fkie.fraunhofer.de> (sfid-20140912_085923_842725_D4136886)
References: <1410505130-7271-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1410505130-7271-3-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 (sfid-20140912_085923_842725_D4136886)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-12 at 08:58 +0200, Henning Rogge wrote:
[...]

In general, this looks fine. However,

> @@ -691,6 +719,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
>  
>  	spin_unlock(&tbl->hashwlock[hash_idx]);
>  	read_unlock_bh(&pathtbl_resize_lock);
> +
> +	mpp_paths_generation++;

This doesn't seem to be concurrency safe?

Neither is the existing mesh_paths_generation++, I think, so maybe it's
not something we really need to worry about?

johannes

