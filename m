Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39560 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbYISUtQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 16:49:16 -0400
Date: Fri, 19 Sep 2008 13:49:01 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Celejar <celejar@gmail.com>, Dan Williams <dcbw@redhat.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: Can't connect to AP with hidden essid with 2.6.27-rc6
Message-ID: <20080919204901.GE7027@tesla> (sfid-20080919_224923_625795_3D8906C1)
References: <20080918015202.8c5f6381.celejar@gmail.com> <48D24911.80101@lwfinger.net> <20080918160957.94ea063d.celejar@gmail.com> <48D2D728.6070105@lwfinger.net> <20080919001050.d9ed273a.celejar@gmail.com> <48D3CFBC.6070504@lwfinger.net> <43e72e890809191105p26841666l50a4a139a7177590@mail.gmail.com> <20080919142740.60e2c0e8.celejar@gmail.com> <48D3FB0F.1000909@lwfinger.net> <20080919160115.c591532c.celejar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20080919160115.c591532c.celejar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 01:01:15PM -0700, Celejar wrote:
> I think the problem I had was that on boot, the b43 / 80211 modules get
> loaded, but they don't seem to be calling CRDA, and I can't access my
> hidden essid AP.  Doing the module removal and reloading that Luis
> suggested causes CRDA to be called, and then things work fine.

b43 drivers don't yet use regulatory_hint() so you get stuck with the
defualt regulatory domain, which is world. To get out of world you
can use iw to set the regulatory domain as follows:

iw reg set US

this would be for the United States regulatory domain. To find your
alpha2 please check:

http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2

Our current database can be viewed here:

Web view:

http://wireless.kernel.org/en/developers/Regulatory/Database

gitweb:

http://git.kernel.org/?p=linux/kernel/git/mcgrof/crda.git;a=blob;f=db.txt;hb=HEAD

(Note: this database will soon be moved to another separate tree apart
from crda)

If you have updates for this database please read this:

http://wireless.kernel.org/en/developers/Regulatory#Sendingupdatestotheregulatorydatabase

Please note though that you *don't have to reload the module* to fix
this issue, all you have to do is to use iw to set the regulatory domain.
Eventually what can be done is userspace networking applets like
NetworkManager can send the same nl80211 request to the wireless core
after bootup. A country can then be configurable by the user through the
applet.

Another alternative is for distributions to call the iw command on the
country alpha2 based on the locale. Basically there's many ways to do
it. Drivers can also just call the regulatory hint based on their
EEPROM, an example driver doing this already is zd1211rw.

  Luis
