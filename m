Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55049 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756048AbZAWSBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 13:01:17 -0500
Message-ID: <497A05DC.4040101@lwfinger.net> (sfid-20090123_190121_939304_65875625)
Date: Fri, 23 Jan 2009 12:01:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: integration of opensource firmware with b43 kernel driver
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
In-Reply-To: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco Gringoli wrote:
> Hello,
> 
> we have been testing the firmware for a week now and it seems stable. I
> personally tested it also on a Linksys WRT54GL and it works both in
> station and in AP modes. I collected the feedbacks that some of you sent
> and it seems that the firmware now runs on these board:
> 
> - 4306, 4311, 4318, 4320

As a point of clarification, I think this is restricted to the 4311/1
as the 4311/2 uses ucode13, not ucode5. If you need a tester for an
open-source version of the 13 firmware, I'm available.

> I was considering the suggestions you all gave me a few days ago and
> other questions related to the possible integration of this firmware
> into the kernel, and I came to these conclusions/questions (please
> forgive me for this long message :-) )
> 
> - change the name of the initvals for the opensource firmware: this
> seems a little bit complicated as now the decision about the
> initval-files' names and the detection of the firmware type are
> respectively based on the phy type and on the firmware date. This means
> that initval-files' names can be determine as soon as the hardware type
> has been probed, while the firmware needs to be started before the
> kernel can determine if it is opensource or not: at this time, however,
> the initvals have already been uploaded. What can we do?

The driver can certainly be coded to look for the open-source firmware
names before trying to load vendor firmware. That way there will not
be any confusion.

> - detection of the opensource firmware capabilities: are you really sure
> we cannot use a shm location that the bcm proprietary firmware uses for
> some other purpose? Once, in fact, the kernel has determined that the
> firmware is opensource it can also use a given location in a different
> manner than it would do for a proprietary firmware. However this is not
> a problem at all :-) as we can use one location in the "high" shm-memory
> area, let's say > 0xb00, just choose one.

I think it best to choose an unused location.

Larry
