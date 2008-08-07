Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:41321 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYHGP6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:58:12 -0400
From: Chr <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
Date: Thu, 7 Aug 2008 18:00:57 +0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net> <200808071727.19129.chunkeey@web.de> <1218122834.3630.6.camel@johannes.berg>
In-Reply-To: <1218122834.3630.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200808071800.58356.chunkeey@web.de> (sfid-20080807_175816_098376_640E1C26)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 07 August 2008 17:27:14 Johannes Berg wrote:
> On Thu, 2008-08-07 at 17:27 +0200, Chr wrote:
> > +       u32:24;
> > +       u32:32;
> > +       u16:16;
>
> That piece looks just wrong though. Bitfields, and in a hw struct?
well, this is a crude way to silence gcc... without the ":32"
it complains "warning: declaration does not declare anything".

Of course we/I can make lot's of u8 paddingZ[X] arrays,
but we'll run out of Z and X in the long run ;-).

Regards,
	Chr.
