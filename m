Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46229 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbZHAKkY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 06:40:24 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
Date: Sat, 1 Aug 2009 12:40:16 +0200
Cc: johannes@sipsolutions.net, linuxrocks123@netscape.net,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
References: <4A72A462.6060107@netscape.net> <1249029583.29587.46.camel@johannes.local> <20090731.222350.254918321.davem@davemloft.net>
In-Reply-To: <20090731.222350.254918321.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908011240.17229.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 August 2009 07:23:50 David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri, 31 Jul 2009 10:39:43 +0200
> 
> > On Fri, 2009-07-31 at 01:59 -0600, Patrick Simmons wrote:
> >> I'm running zd1211rw on SPARC64 and was getting a lot of "unaligned 
> >> access" messages in dmesg.  I tracked the problem down to this line, and 
> >> changing the cast to a memcpy fixes the issue.
> >>  
> >> -       fc = *(__le16 *)buffer;
> >> +       memcpy(&fc,buffer,sizeof(__le16));
> >>         need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
> > 
> > Please use get_unaligned instead.
> 
> And, more specifically, one of the endian get_unaligned variants.

No. fc is supposed to be LE.

-- 
Greetings, Michael.
