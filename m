Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58123 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab0AKAxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 19:53:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/6] b43: N-PHY: add RSSI functions: poll and set 2055 vcm
Date: Mon, 11 Jan 2010 01:53:08 +0100
Cc: bcm43xx-dev@lists.berlios.de,
	=?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
References: <op.u6b70ig59lhzdc@linux-g0th.site> <201001102332.22954.mb@bu3sch.de> <4B4A7084.8010309@lwfinger.net>
In-Reply-To: <4B4A7084.8010309@lwfinger.net>
MIME-Version: 1.0
Message-Id: <201001110153.09503.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 11 January 2010 01:27:48 Larry Finger wrote:
> On 01/10/2010 04:32 PM, Michael Buesch wrote:
> > On Sunday 10 January 2010 23:13:20 Rafał Miłecki wrote:
> >> +		buf[0] += (s8)(((s[0] & 0x3F) << 2) >> 2);
> >> +		buf[1] += (s8)((((s[0] >> 8) & 0x3F) << 2) >> 2);
> >> +		buf[2] += (s8)(((s[1] & 0x3F) << 2) >> 2);
> >> +		buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2);
> > 
> > I suggest buf[3] += (s8)((((s[1] >> 8) & 0x3F) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2) << 2) >> 2)
> > ;)
> > No, seriously, why shift left and then shift right? Is this a translation error?
> > I _guess_ it's some mistranslation of the sign extension going on.
> > Or alternatively a compiler going insane on sign extension.
> > 
> > The question is: Do we want these integers to be signextended or not?
> > 
> > What we currently do is this:
> > buf[3] += (s8)((s[1] >> 8) & 0x3F);
> > 
> > which will always result in a positive 8bit integer, as far as I can see.
> > Which smells fishy.
> 
> We do want sign extension of the signed 6-bit quantities into an 8-bit word. The
> translation is correct. Do you know of a better way to extend the signs?

Well, I think you got the parenthesis and cast wrong then.
I think what we want is the following:

+		buf[3] += (s8)(((s[1] >> 8) & 0x3F) << 2) >> 2;

The code is different and the specs, too.

-- 
Greetings, Michael.
