Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33214 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967475AbaLLMnu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:43:50 -0500
Message-ID: <1418388225.2470.35.camel@sipsolutions.net> (sfid-20141212_134353_491541_89D24CF5)
Subject: Re: [PATCH v3] wireless: Supporting of IFLA_INFO_KIND rtnl attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Vadim Kochan <vadim4j@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Fri, 12 Dec 2014 13:43:45 +0100
In-Reply-To: <1418163666-9206-1-git-send-email-vadim4j@gmail.com> (sfid-20141209_233056_303190_4BCE8A35)
References: <1418163666-9206-1-git-send-email-vadim4j@gmail.com>
	 (sfid-20141209_233056_303190_4BCE8A35)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 00:21 +0200, Vadim Kochan wrote:
> It allows to identify the wlan kind of device for the user application,

Applied,
 
> +static struct rtnl_link_ops wireless_link_ops __read_mostly = {
> +	.kind = "wlan",
> +};

but I've made this const. It only needs to be non-const (__read_mostly)
when used with rtnl_link_register() and friends.

johannes

