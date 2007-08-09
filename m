Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:34450 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXHIJo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 05:44:26 -0400
Message-ID: <46BAE1E1.9000804@aurel32.net>
Date: Thu, 09 Aug 2007 11:44:01 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Make extif driver compilation depend on extif config
References: <200708071744.40287.mb@bu3sch.de> <200708090202.20267.mb@bu3sch.de> <20070808171046.e6a3f506.akpm@linux-foundation.org> <200708090220.32981.mb@bu3sch.de>
In-Reply-To: <200708090220.32981.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch a =E9crit :
> On Thursday 09 August 2007, Andrew Morton wrote:
>> Still confused.
>>
>> I pull
>> git+ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wirele=
ss-dev.git#mm-master
>> into -mm.  Could be that John puts other things into other trees whi=
ch do
>> not appear in #mm-master, I don't know.
>>
>> Given that you are the developer and maintainer of ssb it is appropr=
iate
>> (especially at this stage) that you run a tree.  Just a plain old qu=
ilt
>> tree like
>> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/greg=
kh-01-driver/
>> would be fine.
>>
>> If that tree is relative to some tree which John is running then tha=
t's OK,
>> as long as someone tells me where to get that tree from.
>>
>> Or just merge all of SSB via John's tree.  I don't think it matters =
that
>> it's not strictly a wireless thing. =20
>=20
> I can live with doing it through John.
> And as bcm43xx depends on ssb we are doomed to go through
> John's tree.
> So if you always pull John's tree, you'll be up to date with
> wireless + ssb.
>=20
> So if you drop everything b44, bcm43xx and ssb related
> and pull John's tree, it will compile again.

I have compared the branches master and mm-master in John's tree. Only
drivers/ssb/driver_extif.c is present in mm-master, other files from th=
e
same directory and files from include/linux/ssb/* are missing. Also the
changes to drivers/Kconfig and drivers/Makefile are also missing in
mm-master.

So in short there is only one file concerning SSB drivers in the
mm-master branch and it is useless without the other files.

On the other side b44 and bcm43xx drivers that use the SSB drivers are
present in the mm-master branch.

--=20
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
