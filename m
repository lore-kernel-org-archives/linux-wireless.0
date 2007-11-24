Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:39486 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbXKXUqL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 15:46:11 -0500
Received: by ug-out-1314.google.com with SMTP id z38so700549ugc
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2007 12:46:10 -0800 (PST)
Message-ID: <6995ca080711241246kbb09472k777c2082a41b692a@mail.gmail.com> (sfid-20071124_204618_258917_797DD1EB)
Date: Sat, 24 Nov 2007 15:46:07 -0500
From: "Vadim Peretokin" <vperetokin@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Belin FD7010 v7
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071124143310.a7pta1f4lc0k4ok0@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
	 <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com>
	 <1195784707.11966.38.camel@dv>
	 <6995ca080711230736n54330d30s96831a664d46df1c@mail.gmail.com>
	 <1195879405.7449.62.camel@dv>
	 <6995ca080711241054s4aeca1f9r2496a36f93a9db43@mail.gmail.com>
	 <20071124143310.a7pta1f4lc0k4ok0@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes! Yes there was a new_id thing that we used echo on.

Here is the output of that command:

vadi@vadi-laptop:~$ lspci -n
00:00.0 0600: 8086:3340 (rev 03)
00:01.0 0604: 8086:3341 (rev 03)
00:1d.0 0c03: 8086:24c2 (rev 01)
00:1d.1 0c03: 8086:24c4 (rev 01)
00:1d.2 0c03: 8086:24c7 (rev 01)
00:1d.7 0c03: 8086:24cd (rev 01)
00:1e.0 0604: 8086:2448 (rev 81)
00:1f.0 0601: 8086:24cc (rev 01)
00:1f.1 0101: 8086:24ca (rev 01)
00:1f.3 0c05: 8086:24c3 (rev 01)
00:1f.5 0401: 8086:24c5 (rev 01)
00:1f.6 0703: 8086:24c6 (rev 01)
01:00.0 0300: 1002:4c57
02:00.0 0607: 104c:ac55 (rev 01)
02:00.1 0607: 104c:ac55 (rev 01)
02:08.0 0200: 8086:103d (rev 81)
03:00.0 0200: 1799:701f (rev 20)


The last one is my card, and the devid is "1799:701f" (I remember I
needed to use that with ndiswrapper).

On Nov 24, 2007 2:33 PM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting Vadim Peretokin <vperetokin@gmail.com>:
>
> > Yes, so I believe the problem was that that the rtl8180 driver didn't
> > see, and claim the card. I believe the command I used to get the
> > driver to see the card was "sudo echo -n <some adress here>" - I don't
> > remember it exactly, but if you need it, I can dig it up.
>
> I guess it was adding the PCI ID of the card to the driver using the
> "new_id" mechanism.  Yes, that would be useful.  The ID could be added
> to the driver, so that you would never need to do it again.
>
> Please send the output of "lspci -n"
>
> --
> Regards,
> Pavel Roskin
>
