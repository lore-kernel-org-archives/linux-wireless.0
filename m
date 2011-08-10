Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab1HJN2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:28:16 -0400
Date: Wed, 10 Aug 2011 15:28:01 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2x00: rt2800usb: fix races in tx queue
Message-ID: <20110810132759.GA5652@redhat.com> (sfid-20110810_152820_244687_6F8D233D)
References: <20110804124653.GB5739@redhat.com>
 <CAOZOX0Xpv9OPqx2Y3GnajhmDvx3GyL1xTAjEOYjOToWcQxB6bA@mail.gmail.com>
 <20110808092914.GA2168@redhat.com>
 <20110808093512.GB2168@redhat.com>
 <4E404D5C.30401@gmail.com>
 <20110809095050.GD2152@redhat.com>
 <20110809112624.GA2281@redhat.com>
 <20110809154540.GB2302@redhat.com>
 <20110810103904.GA8079@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110810103904.GA8079@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 12:39:04PM +0200, Stanislaw Gruszka wrote:
> This patch crashes as well. I have to debug this issue a bit more ...

Figured this out, while(1) change helped in my original patch, without
that we can have ops in rt2800usb_get_txwi. I'm going to post reworked
patches now.

Stanislaw 
