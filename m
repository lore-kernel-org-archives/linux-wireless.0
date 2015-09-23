Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:54914 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbbIWLtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 07:49:15 -0400
Date: Wed, 23 Sep 2015 13:42:36 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150923114236.GJ6319@medion.lan> (sfid-20150923_134923_948792_67FB1A3F)
References: <20150923110343.GA19160@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150923110343.GA19160@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Pavel Machek <pavel@ucw.cz> [23.09.2015 13:38]:
> Is there way to manipulate type of service from userland to get
> similar behaviour without patching kernel?

yes, iptables DSCP / DiffServ / Differentiated Services Field

# you have to add some magic for matching your data
e.g. $IPT -t mangle -I OUTPUT -j DSCP --set-dscp-class CS7

also you should consider force the ACK-timing to 450m / Class1
and forbid retransmission in minstrel

bye, bastian
