Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54847 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab0HPVnq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 17:43:46 -0400
Subject: Re: nl80211 scanning from userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: Christopher Piggott <cpiggott@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	 <1281986025.3683.31.camel@jlt3.sipsolutions.net>
	 <AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
	 <1281987696.3683.32.camel@jlt3.sipsolutions.net>
	 <AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 23:43:45 +0200
Message-ID: <1281995025.3683.34.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-16 at 17:22 -0400, Christopher Piggott wrote:
> It's hard to figure out what's going on sometimes.  I set up an error handler:
> 
> static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr
> *err, void *arg) {
>     printf("ERROR %s (%d)\n", strerror(err->error), err->error);
>     return NL_SKIP;
> }
> 
> which also returns -95 (operation not supported) just as you said.
> So, I'll have to figure out what you mean by "dumping."
> 
> I did find this:
> 
>         mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "scan");
> 
> in iw:event.c and traced it to some code in iw:genl.c, a file that
> starts out by commenting "This ought to be provided by libnl".  That
> situation doesn't seem to have changed.
> 
> Is this the area of the code you mean when you say "dump" ?  That I
> need to register myself to receive the scan results?

No, you need to use NLM_F_DUMP etc. Really, check wpa_supplicant :)

johannes

