Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:55311 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXIYXYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 19:24:24 -0400
Received: by rv-out-0910.google.com with SMTP id k20so1842219rvb
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 16:24:22 -0700 (PDT)
Message-ID: <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
Date: Wed, 26 Sep 2007 01:24:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: A-MSDU deaggregation support
Cc: "mohamed salim abbas" <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>, "Jouni Malinen" <j@w1.fi>
In-Reply-To: <1190747966.18521.320.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/25/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2007-09-10 at 14:41 +0300, Tomas Winkler wrote:
>
> > There is actually different problem with the A-MSDU deaggregation and
> > this is EPOL filtering. One of the packets might belong to EAPOL
> > handshake
>
> Why do we filter those anyway? What's wrong with having them show up on
> the regular 802.3 framed interface all the time? Isn't that how 802.1X
> was basically designed?
>
EAPOL frames should not be filtered out. Everything else should be filtered out
except EAPOL frames till the port is open.

The problem is the order of the handlers.  First you need to
deaggregated the frame then filtered out non EAPLOL frames if the port
is not open.

Tomas

> johannes
>
>
