Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab2ECTgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:36:36 -0400
Message-ID: <1336073794.5167.15.camel@jlt3.sipsolutions.net> (sfid-20120503_213643_382368_FEA2B261)
Subject: Re: [PATCH v2 1/4] mac80211: Advertise HT protection mode in IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Thu, 03 May 2012 21:36:34 +0200
In-Reply-To: <1335820832-18887-1-git-send-email-ashok@cozybit.com> (sfid-20120430_232127_377222_6BE61350)
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
	 (sfid-20120430_232127_377222_6BE61350)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:

>  		pos = ieee80211_ie_build_ht_oper(pos, &sband->ht_cap,
> -						 chan, channel_type);
> +						 chan, channel_type, 0);

> -	/*
> -	 * Note: According to 802.11n-2009 9.13.3.1, HT Protection field and
> -	 * RIFS Mode are reserved in IBSS mode, therefore keep them at 0
> -	 */
> -	ht_oper->operation_mode = 0x0000;
> +	ht_oper->operation_mode = cpu_to_le16(prot_mode);

Please move the comment to the now correct place instead of deleting it.

johannes

