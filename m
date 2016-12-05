Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43394 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751615AbcLEOwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 09:52:13 -0500
Message-ID: <1480946371.31788.7.camel@sipsolutions.net> (sfid-20161205_155216_110633_5B85386F)
Subject: Re: [PATCH 1/2] mac80211:  Show pending txqlen in debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 05 Dec 2016 14:59:31 +0100
In-Reply-To: <1480442753-6830-1-git-send-email-greearb@candelatech.com> (sfid-20161129_190601_478280_B404B299)
References: <1480442753-6830-1-git-send-email-greearb@candelatech.com>
         (sfid-20161129_190601_478280_B404B299)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+static ssize_t misc_read(struct file *file, char __user *user_buf,
> +			 size_t count, loff_t *ppos)
> +{
> +	struct ieee80211_local *local = file->private_data;
> +	size_t bufsz = 1000;
> +	char *buf = kzalloc(bufsz, GFP_KERNEL);

You need at most IEEE80211_MAX_QUEUES * 16 (==256) which I think you
can put on the stack?

johannes
