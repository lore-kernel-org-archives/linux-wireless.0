Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35791 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752598AbZC1AzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 20:55:06 -0400
Date: Fri, 27 Mar 2009 21:55:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rfkill-input: remove unused code
Message-ID: <20090328005501.GB7439@khazad-dum.debian.net> (sfid-20090328_015511_590617_59FA7C78)
References: <1238159804.4452.4.camel@johannes.local> <20090327143608.GB24288@khazad-dum.debian.net> <1238166712.4452.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238166712.4452.11.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
> > Because that codepath is _not_ the most obvious thing in the world to
> > reimplement without hitting a pitfall, so people better look how it was done
> > once in time...
> 
> Works for me. Do we expect it to be needed though?

Well, that depends.  Did anyone produce a device with a
switch/push-button labelled "bluetooth", "wimax", "uwb" (instead of
just using a normal key)?  Because if anyone does, we need EV_SW
SW_<whatever>, and that code to handle it in rfkill-input.

I *certainly* don't know of any such device, or I'd have asked for the
EV_SW SW_foo codepoints already, and uncommented that code :-)  People
like the "kill all radios" push-button/switch, but one for a specific
type of transmitter I haven't seen yet.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
