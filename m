Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38812 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab0KXJt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 04:49:57 -0500
Subject: Re: [PATCH] wl1271: use debugfs_remove_recursive
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1290591333-30453-1-git-send-email-eliad@wizery.com>
References: <1290591333-30453-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 10:49:52 +0100
Message-ID: <1290592192.3790.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-24 at 11:35 +0200, Eliad Peller wrote:

> @@ -524,23 +423,14 @@ int wl1271_debugfs_init(struct wl1271 *wl)
>  {
>  	int ret;
>  
> -	wl->debugfs.rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
> +	wl->rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
>  
> -	if (IS_ERR(wl->debugfs.rootdir)) {
> -		ret = PTR_ERR(wl->debugfs.rootdir);
> -		wl->debugfs.rootdir = NULL;
> +	if (IS_ERR(wl->rootdir)) {
> +		ret = PTR_ERR(wl->rootdir);
> +		wl->rootdir = NULL;
>  		goto err;
>  	}

This looks problematic if you ever have more than one device ... I
suggest moving to using the wiphy's debugfs dir as the parent for the
rootdir.

johannes

