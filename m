Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2JJVad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 17:30:33 -0400
Message-ID: <1349904667.19068.0.camel@jlt4.sipsolutions.net> (sfid-20121010_233036_396942_B59C52D2)
Subject: Re: p2p question
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 10 Oct 2012 23:31:07 +0200
In-Reply-To: <5075E771.2090101@broadcom.com>
References: <5075E771.2090101@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-10 at 23:24 +0200, Arend van Spriel wrote:
> Hi Johannes,
> 
> Reading the comment on .add_virtual_intf() callback I am a bit confused.
> 
> =====
>   * @add_virtual_intf: create a new virtual interface with the given name,
>   *	must set the struct wireless_dev's iftype. Beware: You must create
>   *	the new netdev in the wiphy's network namespace! Returns the struct
>   *	wireless_dev, or an ERR_PTR. For P2P device wdevs, the driver must
>   *	also set the address member in the wdev.
> =====
> 
> The last sentence refers to the "address member in wdev", but at least 
> in my tree struct wireless_dev does not have an address member. Missing 
> something here?

It does in my tree?

struct wireless_dev {
...
        u8 address[ETH_ALEN] __aligned(sizeof(u16));

maybe you missed it?

johannes

