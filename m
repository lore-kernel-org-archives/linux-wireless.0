Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56841 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbaJWRTN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 13:19:13 -0400
Message-ID: <1414084745.1926.8.camel@jlt4.sipsolutions.net> (sfid-20141023_191916_796252_D1337B65)
Subject: Re: mac80211-hwsim question
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 23 Oct 2014 19:19:05 +0200
In-Reply-To: <54493276.4030007@candelatech.com> (sfid-20141023_185314_774672_09890850)
References: <54493276.4030007@candelatech.com>
	 (sfid-20141023_185314_774672_09890850)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-23 at 09:53 -0700, Ben Greear wrote:
> From what I can tell, when hwsim sends frames to wmediumd using netlink sockets,
> it does not include any channel/frequency information in the netlink packet.
> 
> Any reason not to add that?

I guess it wasn't needed, and when you "RX" a frame from netlink it uses
the current channel that the radio is tuned to.

That, however, will actually fail with the multi-channel option, so more
work is clearly needed for that.

johannes

