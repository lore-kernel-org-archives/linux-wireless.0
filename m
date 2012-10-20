Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:53145 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab2JTRRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Oct 2012 13:17:22 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so754055wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2012 10:17:20 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Javier Lopez <jlopex@cozybit.com>
Subject: Re: Receive BlockAckReq and BlockAck on carl9170 driver
Date: Sat, 20 Oct 2012 19:17:15 +0200
Cc: linux-wireless@vger.kernel.org
References: <CAMr9ZPkS3TXg7XDNzeor7zXED7cUUqcGdrb53OFGtr0N8Hh5Ng@mail.gmail.com> <201210191000.41350.chunkeey@googlemail.com> <CAMr9ZPnqjyqhoRuafBu=uxrQSxGNSe3oQYMX+--2aoLv4OW=BQ@mail.gmail.com>
In-Reply-To: <CAMr9ZPnqjyqhoRuafBu=uxrQSxGNSe3oQYMX+--2aoLv4OW=BQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210201917.16213.chunkeey@googlemail.com> (sfid-20121020_191725_972176_359BFFA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Javier,

On Saturday 20 October 2012 18:51:37 Javier Lopez wrote:
> Thanks for your comments, they helped a lot.
Really? But how, all I did was "ask questions"?

> Now we are able to receive the frames on
> carl9170_handle_mpdu on mesh mode.
ok, I never got around and tested mesh mode
operation with carl9170 properly.
 
> After setting the monitor interface we noticed that
> the traps were not called but the frames were received.
> So we checked the traps and we saw that they were
> placed before the frame was correctly aligned.
Well, ok. So the code is confusing :-/. I guess
the _mpdu should be split into to parts so it's
more obvious when a trap handler can be inserted.
 
> Then removing the CARL9170_RX_FILTER_CTL_OTHER did the rest.
Ok, maybe the terminology is a bit odd in this case. Normally
when I think of the word filter, then I think of something which
prevent things from going trough. However mac80211's 
"configure_filter" is sort of the opposite, e.g.: if FIF_CONTROL
is set, then control frames like BA/ACKS/BARS/RTS/CTS/... should
"pass-through". But I've already updated the fwcmd.h include,
so when the next fw release comes along it should hit the driver
as well.

Regards,
	Chr
