Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42518 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaHLABv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 20:01:51 -0400
Received: by mail-pa0-f45.google.com with SMTP id eu11so11881668pac.4
        for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2014 17:01:51 -0700 (PDT)
Message-ID: <1407801666.28221.84.camel@chimera> (sfid-20140812_020156_060132_7FEAEBC3)
Subject: Re: [PATCH] allow setting wiphy.perm_addr after driver probe
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org Wireless"
	<linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Network Development <netdev@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Date: Mon, 11 Aug 2014 17:01:06 -0700
In-Reply-To: <52896C9C-8560-4CE4-A1FB-C896D766EC87@holtmann.org>
References: <1407780269.28221.63.camel@chimera>
	 <54DF22CF-59D7-4633-A625-896F58C26A64@holtmann.org>
	 <1407789645.28221.68.camel@chimera>
	 <37210DB5-2911-4FA3-9299-7701C5003945@holtmann.org>
	 <1407791075.28221.74.camel@chimera>
	 <28066DB2-9EA9-4748-9C89-D3FBD3EC51F5@holtmann.org>
	 <1407798738.28221.81.camel@chimera>
	 <52896C9C-8560-4CE4-A1FB-C896D766EC87@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-08-11 at 16:56 -0700, Marcel Holtmann wrote:
> the way I read the nl80211 code is that the NL80211_CMD_NEW_INTERFACE
> requires a wiphy device to be specified. And that is actually just a
> number. So I have no idea what the MAC has to here.
> 
OpenWrt finds a wiphy by its MAC.

> Why does the wiphy need to know the MAC if it is always specified from
> userspace when actually creating the new netdev interface. Works for
> P2P devices, so why wouldn't it work for access point and station
> mode?
> 
A MAC can be specified for the netdev, but it is assigned to a wiphy
identified by its MAC.

