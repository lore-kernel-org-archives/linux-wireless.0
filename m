Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47252 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaJSKXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2014 06:23:07 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so4151255wid.13
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2014 03:23:06 -0700 (PDT)
Date: Sun, 19 Oct 2014 12:22:55 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] mac80211: minstrels: fix buffer overflow in HT debugfs
 rc_stats
Message-ID: <20141019102255.GA30711@magnum.frso.rivierawaves.com> (sfid-20141019_122312_558628_5957BC75)
References: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413570840-27679-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

If that's not too late I'd like to fix some coding style, replace:

On Fri, Oct 17, 2014 at 08:34:00PM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> @@ -102,6 +102,8 @@ minstrel_stats_open(struct inode *inode, struct file *file)
>  			mi->sample_packets);
>  	ms->len = p - ms->buf;
>  
> +	WARN_ON(ms->len > 2048 - sizeof(*ms));

with:
	WARN_ON(ms->len + sizeof(*ms) > 2048);
and,

> @@ -118,6 +119,8 @@ minstrel_ht_stats_open(struct inode *inode, struct file *file)
>  		MINSTREL_TRUNC(mi->avg_ampdu_len * 10) % 10);
>  	ms->len = p - ms->buf;
>  
> +	WARN_ON(ms->len > 8192 - sizeof(*ms));

with:
	WARN_ON(ms->len + sizeof(*ms) > 8192);

This would require rebasing "[PATCH v3 4/4] mac80211: minstrel_ht: add
basic support for VHT rates <= 3SS@80MHz", and send 

[PATCH v2] mac80211: minstrels: fix buffer overflow in HT debugfs
[PATCH v4 1/4] mac80211: minstrel_ht: Increase the range of handled
[PATCH v4 2/4] mac80211: minstrel_ht: macros adjustments for future
[PATCH v4 3/4] mac80211: minstrel_ht: include type (cck/ht) in rates
[PATCH v4 4/4] mac80211: minstrel_ht: add basic support for VHT rates

Is it ok ?
 
Karl
