Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37670 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab0HPVXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 17:23:00 -0400
Received: by vws3 with SMTP id 3so3821703vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2010 14:22:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281987696.3683.32.camel@jlt3.sipsolutions.net>
References: <AANLkTi=ZGn0Rt7zYxBJB0jJ-EY=gPpxtBN2bA9svkq99@mail.gmail.com>
	<1281986025.3683.31.camel@jlt3.sipsolutions.net>
	<AANLkTiniqFJzrWFzNJTxsF31EZfSTei89dbS2Ak4YDjH@mail.gmail.com>
	<1281987696.3683.32.camel@jlt3.sipsolutions.net>
Date: Mon, 16 Aug 2010 17:22:59 -0400
Message-ID: <AANLkTi=ALaGb=UcWAuB_N8E9j95f0Hgxtw0Dhh7xaPh2@mail.gmail.com>
Subject: Re: nl80211 scanning from userspace
From: Christopher Piggott <cpiggott@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's hard to figure out what's going on sometimes.  I set up an error handler:

static int error_handler(struct sockaddr_nl *nla, struct nlmsgerr
*err, void *arg) {
    printf("ERROR %s (%d)\n", strerror(err->error), err->error);
    return NL_SKIP;
}

which also returns -95 (operation not supported) just as you said.
So, I'll have to figure out what you mean by "dumping."

I did find this:

        mcid = nl_get_multicast_id(state->nl_sock, "nl80211", "scan");

in iw:event.c and traced it to some code in iw:genl.c, a file that
starts out by commenting "This ought to be provided by libnl".  That
situation doesn't seem to have changed.

Is this the area of the code you mean when you say "dump" ?  That I
need to register myself to receive the scan results?

--C
