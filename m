Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-11.dex002.intermedia.net ([64.78.21.77]:34444 "EHLO
	dhost002-11.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755745AbXEJRY6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:24:58 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 10 May 2007 10:25:10 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kumar Gala <galak@kernel.crashing.org>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: support for bridging ethernet and 802.11
Message-ID: <20070510172510.GE24712@devicescape.com>
References: <CCA1D7C0-D44A-450D-A76E-DAE792E0CB37@kernel.crashing.org> <1178816781.3806.31.camel@johannes.berg> <20070510171213.GD24712@devicescape.com> <1178817575.3806.36.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1178817575.3806.36.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2007 at 07:19:35PM +0200, Johannes Berg wrote:

> Ah forgot about that, I had only thought about AP/wired bridging. How
> would the prism driver actually do bridging in STA mode though?

If that is referring to Host AP driver, there is support for using WDS
in client mode. If the AP understands this, the client could use
standard frames for its own packets (i.e., SA=own MAC addr) and WDS
frames for frames from all other addresses. There are some experimental
modes in Host AP driver that (if I remember correctly ;-) may allow this
to be used on a single netdev (i.e., no additional netdev needed for the
WDS link) and as such, this would look like working layer 2 bridging
between wlan0 and eth0 even in managed mode.

-- 
Jouni Malinen                                            PGP id EFC895FA
