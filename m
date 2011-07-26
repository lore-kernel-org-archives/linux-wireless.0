Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43802 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1GZCmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 22:42:25 -0400
Received: by qyk9 with SMTP id 9so2749542qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 19:42:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UYwvDZm49vaXZGQy93Ga2jO8-e5wb1YbojxPATmiK0hw@mail.gmail.com>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <CAB=NE6WoKhvR7AVcwaGkijkph+UAts9h-=L4oPwhE=b6gW8eDg@mail.gmail.com>
 <CAB=NE6X=ykO6fX1+vrYyjHt0V1z8hN7HY3p7cEaeXw13z2aKnA@mail.gmail.com>
 <201107260213.16509.chunkeey@googlemail.com> <CAB=NE6UYwvDZm49vaXZGQy93Ga2jO8-e5wb1YbojxPATmiK0hw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jul 2011 19:42:05 -0700
Message-ID: <CAB=NE6U+rNm_o9gNDi0VNjYdLCuiSyqMP1tCt=yPkxk6HY=43A@mail.gmail.com> (sfid-20110726_044229_906629_DE09B56C)
Subject: Re: problem on ACS
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: MingAnn Ng <devil_eddie01@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2011 at 7:21 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>> [now if only acs would stop freezing]
>
> Is it freezing with the patch? gdb ./acs
> run <args>

BTW I think this may because for some channels there is no data yet,
for hostapd I solved this by issuing a scan prior to running the ACS
stuff, this seems to force some data collection. The same can be done
with the acs code but I've been lazy to add the full scan request
command into the code, you can however issues  scan manually before
running acs, let me know if that cures your woes, if so then we know
what we need to do. In fact we may want to just do a pasive scan on
each channel instead of an offchannel operation, but we can do that
later.

 Luis
