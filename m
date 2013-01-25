Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:53964 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab3AYVSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 16:18:51 -0500
Received: by mail-vb0-f45.google.com with SMTP id p1so623911vbi.4
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 13:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOE46e7Bg=7ow33GAr0R-Zd1SCzR31ukVZ3fyb2y6LV6w=1tJw@mail.gmail.com>
References: <CAOE46e7Bg=7ow33GAr0R-Zd1SCzR31ukVZ3fyb2y6LV6w=1tJw@mail.gmail.com>
Date: Sat, 26 Jan 2013 10:18:50 +1300
Message-ID: <CAOE46e5t15xtyD9fZrU_T8=E4ZaPezQTb3tLDmuEppqr0Ny9Cw@mail.gmail.com> (sfid-20130125_221855_105036_418120B6)
Subject: Understanding power rules where a max antenna gain is specified
From: Dean Armstrong <dean.armstrong@virscient.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All,

I had some uncertainties about the regulatory framework that I
documented in mail sent to the wireless-regdb list a few weeks back -
see below. It seems that list is a bit quiet, so I'm posting it here.
Any insight/thoughts would be very much appreciated.

Many thanks,
Dean.

---------- Forwarded message ----------
From: Dean Armstrong <dean.armstrong@virscient.com>
Date: 5 January 2013 19:54
Subject: Understanding power rules where a max antenna gain is specified
To: wireless-regdb@lists.infradead.org


Hello All,

I'm trying to understand the Linux wireless regulatory framework but
am having trouble figuring out how the regulatory database is derived
from the actual regulations. I think I've read the relevant
documentation, and have been looking at various bits of source code,
but I am still at a loss and was hoping that someone might be generous
enough to answer a question or two on how it is all supposed to work.

In particular, I am looking at the version of db.txt that is visible
at [1] (this being the head of that branch as I write). For the
example I want to query I'm contemplating the following two lines
(and, specifically, the power rule - "(3, 27)" on the second line).

country US: DFS-FCC
        (2402 - 2472 @ 40), (3, 27)

After reading [2], I interpret this rule as defining an EIRP limit of
27 dBm and a "maximum antenna gain" of 3 dBi.

The confusion I have is over how this reconciles with the actual FCC
regulations for this band. The concise description at [3] tallies with
my understanding (but, of course, this may be where I'm mistaken), and
I paraphrase it thus for non-"fixed point-to-point links" (which, I
assume, is what we are talking about):

 - Total Power Output (TPO) limit of 30 dBm
 - Effective Isotropic Radiated Power (EIRP) limit of 36 dBm

The first point of confusion for me is the "maximum antenna gain"
number in the regulatory database (the "3" in "(3, 27)"). I wasn't
aware that FCC imposed an explicit limit on the gain of antennas used
in this band (and certainly not a limit of 3 dBi as db.txt suggests),
so I don't understand why this is named what it is in the
documentation. I'm therefore left wondering whether the "maximum
antenna gain" number (where) specified in db.txt is actually giving a
conversion from the EIRP limit given, to a TPO limit.

If this were true it would make some sense to me, but even if I assume
this the numbers still don't reconcile with FCC. Basically, given the
30 dBm TPO limit and 36 dBm EIRP limit of FCC for 2.4-2.5 GHz ISM, I
would have expected to see a rule like:

country US: DFS-FCC
        (2402 - 2472 @ 40), (6, 36)

i.e., a 36 dBm EIRP limit, with TPO limit 6 dB below this.

Obviously I am grossly misunderstanding something and I would very
much appreciate it if someone on this list could enlighten me.

Many thanks,
Dean.

References
---
[1] http://git.kernel.org/?p=linux/kernel/git/linville/wireless-regdb.git;a=blob_plain;f=db.txt;hb=1e7bf666e34e30e13238879ee76b58449be2f9fd
[2] http://wireless.kernel.org/en/developers/Regulatory/processing_rules
[3] http://www.afar.net/tutorials/fcc-rules/

--
Dean Armstrong | Virscient Limited | www.virscient.com
