Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:37845 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767366AbXDEV6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2007 17:58:11 -0400
Date: Thu, 5 Apr 2007 23:53:53 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Theo de Raadt <deraadt@cvs.openbsd.org>
Cc: Jeff Garzik <jeff@garzik.org>, Michael Buesch <mb@bu3sch.de>,
	Marcus Glocker <mglocker@openbsd.org>,
	Jon Simola <jsimola@gmail.com>,
	Theo de Raadt <deraadt@theos.com>,
	Martin Langer <martin-langer@gmx.de>,
	Danny van Dyk <kugelfang@gentoo.org>,
	Andreas Jaggi <andreas.jaggi@waterwave.ch>,
	Larry Finger <larry.finger@lwfinger.net>, Quaker.Fang@sun.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Joseph Jezak <josejx@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	Greg kh <greg@kroah.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org,
	license-violation@gpl-violations.org
Subject: Re: OpenBSD bcw: Possible GPL license violation issues
Message-ID: <20070405235353.09e1e68d@localhost>
In-Reply-To: <200704052056.l35KuTIr025210@cvs.openbsd.org>
References: <46155E82.2040808@garzik.org>
	<200704052056.l35KuTIr025210@cvs.openbsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 05 Apr 2007 14:56:29 -0600
Theo de Raadt <deraadt@cvs.openbsd.org> wrote:

> The Italian dude in particular was complaining bitterly in private
      ^^^^^^^^^^^^
Should this be considered an offense? What else?

> mail about the whitespace similarities... good grief, not whitespace
> similarities.  How SCO of him.

I want to show an example.

Commit message for bcw revision 1.78:
Read the whole SPROM content with a single routine to a own sprom struct.

For those people who have reported about broken MAC address at attach
time, this should fix the problem.

An excerpt of bcw code:
uint8_t bcw_sprom_crc(const uint16_t *sprom)
{
         int word;
         uint8_t crc = 0xff;

         for (word = 0; word < BCW_SPROM_SIZE - 1; word++) {
                 crc = bcw_sprom_crc8(crc, sprom[word] & 0x00ff);
                 crc = bcw_sprom_crc8(crc, (sprom[word] & 0xff00) >> 8);
         }
         crc = bcw_sprom_crc8(crc, sprom[BCW_SPROM_VERSION] & 0x00ff);
         crc ^= 0xff;
 
         return (crc);
}

An excerpt of bcm43xx code:
static u8 bcm43xx_sprom_crc(const u16 *sprom)
{
        int word;
        u8 crc = 0xFF;

        for (word = 0; word < BCM43xx_SPROM_SIZE - 1; word++) {
                crc = bcm43xx_crc8(crc, sprom[word] & 0x00FF);
                crc = bcm43xx_crc8(crc, (sprom[word] & 0xFF00) >> 8);
        }
        crc = bcm43xx_crc8(crc, sprom[BCM43xx_SPROM_VERSION] & 0x00FF);
        crc ^= 0xFF;

        return crc;
}

Diff here:
http://www.openbsd.org/cgi-bin/cvsweb.cgi/src/sys/dev/ic/Attic/bcw.c.diff?r1=1.77&r2=1.78&f=h
(here you can see that Marcus wrote some code for reading SPROM before this
commit, but then here he replaces what he wrote with bcm43xx code.)

I would like a precise answer here. Do you think that this specific case is
a "mistake"?


--
Ciao
Stefano
