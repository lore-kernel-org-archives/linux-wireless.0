Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:55999 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752068Ab1JHXLe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 19:11:34 -0400
Message-ID: <1318115494.1844.44.camel@Joe-Laptop> (sfid-20111009_011141_787931_EF6F9D50)
Subject: Re: [PATCH] ssb: Convert to use crc8 code in kernel library
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, zajec5@gmail.com,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Sat, 08 Oct 2011 16:11:34 -0700
In-Reply-To: <4E90D5F7.6020005@lwfinger.net>
References: <4e90ce9a.89uGF659NNpbpyA3%Larry.Finger@lwfinger.net>
	 <1318113514.1844.34.camel@Joe-Laptop> <4E90D5F7.6020005@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 18:00 -0500, Larry Finger wrote:
> On 10/08/2011 05:38 PM, Joe Perches wrote:
> > On Sat, 2011-10-08 at 17:28 -0500, Larry Finger wrote:
> >> The kernel now contains library routines to establish crc8 tables and
> >> to calculate the appropriate sums. Use them for ssb.
> > []
> >> --- wireless-testing-new.orig/drivers/ssb/pci.c
> > []
> >> +static inline void ltoh16_buf(u16 *buf, unsigned int size)
> >
> > Perhaps a rename and use le16_to_cpup?
> >
> >> +static inline void htol16_buf(u16 *buf, unsigned int size)
> >
> > and cpu_to_le16p?
> 
> I'm sorry, but I don't see any advantage to using a pointer version here. Please 
> enlighten me.

It's just a naming consistency thing,
you already are using a pointer version,
and maybe this should go into byteorder.h

inline void array_cpu_to_le16p(u16 *p, size_t size)
{
	while (size) {
		cpu_to_le16p(p++);
		size--;
	}
}

