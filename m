Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:32781 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZBQVAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 16:00:45 -0500
Received: from localhost ([127.0.0.1] helo=www.phantomjinx.co.uk)
	by vilya.visn.co.uk with esmtpa (Exim 4.69)
	(envelope-from <p.g.richardson@phantomjinx.co.uk>)
	id 1LZX3c-0004uj-Dj
	for linux-wireless@vger.kernel.org; Tue, 17 Feb 2009 21:00:44 +0000
Message-ID: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk> (sfid-20090217_220049_786292_71B04981)
Date: Tue, 17 Feb 2009 21:00:44 -0000 (UTC)
Subject: rtl8187 cannot fix rate
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

More experimentation with my rtl8187. With some playing around with the
access point location, I think I may have stumbled on a good position.

Anyway ...

I noticed that the rate reported by iwconfig only ever gets to 11Mb/s
despite the fact that I now have a signal level of 90/100 - 100/100. I
found that I can do

iwconfig wlan0 rate 54M

but it seems that although the card is still associated networking does=
nt
work (pings fail). If I change it back to auto

iwconfig wlan0 rate auto

then iwconfig reports 11Mb/s again and pinging resumes fine.

Is there any chance that the driver is incorrectly reporting its mode o=
r
something in that the rates it displays bear the hallmarks of a b card
rather than g?

Using the compat-wireless snapshot from 9/2/2009
Mandriva 2.6.27.10-desktop586-1mnb

Any ideas appreciated.

Regards

PGR

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
