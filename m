Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab2A1Ek2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jan 2012 23:40:28 -0500
Message-ID: <4F237C16.5050100@sipsolutions.net> (sfid-20120128_054031_448458_2A381995)
Date: Fri, 27 Jan 2012 20:39:50 -0800
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Do not scan for IBSS merge with a fixed BSSID.
References: <1327581394-15368-1-git-send-email-cavallar@lri.fr> (sfid-20120126_133659_805161_39F32A75)
In-Reply-To: <1327581394-15368-1-git-send-email-cavallar@lri.fr> (sfid-20120126_133659_805161_39F32A75)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/26/2012 4:36 AM, Nicolas Cavallari wrote:

> -	if (ifibss->fixed_channel)
> +	if (ifibss->fixed_bssid)
>   		return;
>
>   	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
>   	       "IBSS networks with same SSID (merge)\n", sdata->name);

Just from the looks of it, this doesn't seem right. If you're fixing the 
BSSID, you're still asking for automatic channel selection and merging 
with other peers using the same BSSID on different channels, so I 
disagree with your commit message quite completely.

johannes
