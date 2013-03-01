Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42049 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752299Ab3CAW1h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 17:27:37 -0500
Message-ID: <1362176856.2116.27.camel@joe-AO722> (sfid-20130301_232742_603278_77802914)
Subject: Re: [PATCH] mac80211: add VHT capabilities station debugfs file
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Fri, 01 Mar 2013 14:27:36 -0800
In-Reply-To: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net>
References: <1362175935-11828-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-01 at 23:12 +0100, Johannes Berg wrote:
> Add a new debugfs file to view a station's VHT capabilities.
[]
> diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
[]
> @@ -325,6 +325,36 @@ static ssize_t sta_ht_capa_read(struct file *file, char __user *userbuf,
>  }
>  STA_OPS(ht_capa);
>  
> +static ssize_t sta_vht_capa_read(struct file *file, char __user *userbuf,
> +				 size_t count, loff_t *ppos)
> +{
> +	char buf[512], *p = buf;

512?  Kinda large don't you think?
You use maybe 128.


