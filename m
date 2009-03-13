Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f175.google.com ([209.85.218.175]:53519 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZCMMQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 08:16:22 -0400
Received: by bwz23 with SMTP id 23so96268bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 05:16:19 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
Date: Fri, 13 Mar 2009 13:10:44 +0100
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
References: <1236939917.5235.7.camel@johannes.local> <1236941339.5235.14.camel@johannes.local> <1236941444.5235.16.camel@johannes.local>
In-Reply-To: <1236941444.5235.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903131310.44757.helmut.schaa@gmail.com> (sfid-20090313_131624_136834_19860C82)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 13. M=E4rz 2009 schrieb Johannes Berg:
> On Fri, 2009-03-13 at 11:48 +0100, Johannes Berg wrote:
> > On Fri, 2009-03-13 at 11:44 +0100, Johannes Berg wrote:
> > > When mac80211 resumes, it currently doesn't reconfigure the inter=
faces
> > > entirely and also doesn't reconfigure BSS information -- fix this=
=2E
> > >=20
> > > Also, to be able to test this, add a debugfs file that just calls
> > > the suspend/resume code to see what happens when we go through th=
at,
> > > without needing the time-consuming suspend/resume cycle.
> > >=20
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > > v2: rebased on top of "stop queues across suspend/resume"
> > >=20
> > > zd1211rw currently doesn't survive this properly, I'm not sure wh=
y,
> > > but it keeps saying
> > > 	zd1211rw 1-1:1.0: error ioread32(CR_REG1): -11
> > >=20
> > > Please test with other hardware, we need to figure out whether or
> > > not something is missing in mac80211.
> >=20
> > ath9k survives ping -f without even blinking.
>=20
> So does iwlwifi.

Mine does not. I got:

mac80211-phy2: failed to set key (0, XX:XX:XX:XX:XX:XX) to hardware (-2=
2)

iwconfig still shows signal strength etc. but no packets are transmitte=
d
anymore.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
