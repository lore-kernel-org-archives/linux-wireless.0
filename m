Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46459 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbYGZOtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 10:49:35 -0400
Message-ID: <488B3969.4050405@openwrt.org> (sfid-20080726_164938_618398_B91C3452)
Date: Sat, 26 Jul 2008 16:49:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?C=E9dric_Auger?= <cedric@grisbi.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
References: <20080726161140.59041730@grisbi.org>
In-Reply-To: <20080726161140.59041730@grisbi.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

C=E9dric Auger wrote:
> hello
> i've a problem for iwl3945 and didn't find on google something about
> that. i have the kernel 2.6.26 and use the kernel's driver. when i wa=
s
> with the ipw3945, i could download with a speed of at least 600k/s, a=
nd
> sometimes more.
> it's some time i changed for iwl3945 and didn't see some difference
> exept it works better in several ways, but some times ago, i noticed
> that dowloading big images was slow.
> i checked to transfer a file between 2 computer by wifi, and the
> download is limited to about 130-140k/s. when i plug a cable, i go
> directly to 900kb/s.
I don't know if it helps with debugging this issue, but I've seen the s=
ame
on a laptop from a friend of mine (same card).

After some searching I found that setting the AP to g-only mode instead=
 of
b+g mixed made it work at decent speeds. Another symptom of this slowdo=
wn is
that there is typically an unnaturally high number of retransmissions o=
n the
air, which eats up a lot of airtime.

I've spent some time looking through the code to find the reason for th=
is
but couldn't find anything yet (maybe somebody from Intel could help).

- Felix

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
