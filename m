Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:35986 "HELO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751112AbaICCG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 22:06:59 -0400
Received: by mail-pd0-f171.google.com with SMTP id y13so9935873pdi.30
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 19:06:59 -0700 (PDT)
Message-ID: <540675F2.1030308@miraclelinux.com> (sfid-20140903_040704_968178_B6552A53)
Date: Wed, 03 Sep 2014 10:59:14 +0900
From: YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: hideaki.yoshifuji@miraclelinux.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [RFC] net: ipv4: drop unicast encapsulated in L2 multicast
References: <1408641747-22199-1-git-send-email-johannes@sipsolutions.net>	 (sfid-20140821_192515_304437_37E734D5) <1408642331.4388.2.camel@jlt4.sipsolutions.net>	 <1409125114.11976.14.camel@localhost>	 <1409130313.2505.3.camel@jlt4.sipsolutions.net>	 <1409133238.26515.13.camel@localhost> <1409650573.1808.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1409650573.1808.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> As long as IPv6 doesn't mandate it in the RFCs I'm not really sure we
> should just drop it, even if we think it won't cause any problems?
>
> CLUSTERIP seems like a special configuration, but I'm not sure it can be
> detected and automatically allowed?

Please do not "drop" L2 multicast/broadcast for L3 unicast and
vice versa, unless it is explicitly specified by RFC.

Upper-layer needs to cope eith situation of seeing packets with
"incorrect" L2 header anyway (e.g., in promiscous mode).
I do not see much advantage to drop them here.

-- 
Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Technical Division, MIRACLE LINUX CORPORATION
