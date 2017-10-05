Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out4.electric.net ([192.162.216.185]:61489 "EHLO
        smtp-out4.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751380AbdJEPMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 11:12:10 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Joe Perches' <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
CC: Pavani Muthyala <pavani.muthyala@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rsi: fix integer overflow warning
Date: Thu, 5 Oct 2017 15:12:05 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DD008ACEE@AcuExch.aculab.com> (sfid-20171005_171234_671632_C3733126)
References: <20171005120547.328687-1-arnd@arndb.de>
 <1507205947.4434.23.camel@perches.com>
In-Reply-To: <1507205947.4434.23.camel@perches.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Joe Perches
> Sent: 05 October 2017 13:19
> On Thu, 2017-10-05 at 14:05 +0200, Arnd Bergmann wrote:
> > gcc produces a harmless warning about a recently introduced
> > signed integer overflow:
> >
> > drivers/net/wireless/rsi/rsi_91x_hal.c: In function 'rsi_prepare_mgmt_desc':
> > include/uapi/linux/swab.h:13:15: error: integer overflow in expression [-Werror=overflow]
> >   (((__u16)(x) & (__u16)0x00ffU) << 8) |   \
> >    ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~
> > include/uapi/linux/swab.h:104:2: note: in expansion of macro '___constant_swab16'
> >   ___constant_swab16(x) :   \
> >   ^~~~~~~~~~~~~~~~~~
> > include/uapi/linux/byteorder/big_endian.h:34:43: note: in expansion of macro '__swab16'
> >  #define __cpu_to_le16(x) ((__force __le16)__swab16((x)))
> 
> []
> 
> > The problem is that the 'mask' value is a signed integer that gets
> > turned into a negative number when truncated to 16 bits. Making it
> > an unsigned constant avoids this.
> 
> I would expect there are more of these.
> 
> Perhaps this define in include/uapi/linux/swab.h:
> 
> #define __swab16(x)				\
> 	(__builtin_constant_p((__u16)(x)) ?	\
> 	___constant_swab16(x) :			\
> 	__fswab16(x))
> 
> should be
> 
> #define __swab16(x)				\
> 	(__builtin_constant_p((__u16)(x)) ?	\
> 	___constant_swab16((__u16)(x)) :	\
> 	__fswab16((__u16)(x)))

You probably don't want the cast in the call to __fswab16() since
that is likely to generate an explicit and with 0xffff.
You will likely also get one if the argument is _u16 (not unsigned int).

	David
