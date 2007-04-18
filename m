Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46480 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964873AbXDRVF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 17:05:57 -0400
Date: Wed, 18 Apr 2007 14:04:51 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wext: allow wext users without rtnl
Message-ID: <20070418140451.075370fc@freekitty>
In-Reply-To: <1176825010.3902.28.camel@johannes.berg>
References: <1176825010.3902.28.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 17 Apr 2007 17:50:10 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> This patch modifies wext adding a flag that allows drivers to specify that
> they do not wish their wext calls made under rtnl. The default is to still
> acquire the rtnl.
> 
> Warning: a device reference is held for the new no_locking API,
> therefore it is not safe to call unregister_netdev on the passed device!
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> 
>

NACK Conditional locking is bad design.
Either lock or not, make up your mind and fix the devices.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
