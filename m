Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44754 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0HXKPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 06:15:05 -0400
Subject: Re: [PATCH 3/3] nl80211: New command for setting TX rate mask for
 rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <4C6F07AA.3080606@redfish-solutions.com>
References: <20091229105945.GD18493@jm.kir.nu>
	 <4C6DA19B.7010606@redfish-solutions.com>
	 <1282296004.3785.25.camel@jlt3.sipsolutions.net>
	 <4C6EAE6C.50001@redfish-solutions.com>
	 <4C6F07AA.3080606@redfish-solutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 12:16:34 +0200
Message-ID: <1282644994.3695.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-20 at 15:54 -0700, Philip Prindeville wrote:

> What I'm trying to say is that even though the driver handles the
> condition of nla_type == 0 when it generates the message, the
> condition isn't handled correct when the message finally gets passed
> up into user-space, because the above sequence in the netlink library
> gets hit both for "iw" and "hostapd".
> 
> So it's not enough to handle it correctly in the driver: it needs to
> be handled in libnl as well.
> 
> There are 3 potential solutions:
> 
> (1) go with a 1-based enum for the band, instead of 0-based;
> (2) remove the test for nla_type == 0 in nla_parse() in libnl;
> (3) use a way to convey the band that doesn't involve overloading
> nla_type;
> 
> What's the correct fix?

You managed to totally throw me off course ... The problem is completely
unrelated to this, see the patch I just sent :-)

johannes

