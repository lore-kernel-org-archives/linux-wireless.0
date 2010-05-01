Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39810 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0EASP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 14:15:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] ssb: Implement fast powerup delay calculation
Date: Sat, 1 May 2010 20:15:50 +0200
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"b43-dev" <b43-dev@lists.infradead.org>
References: <4BDC56D2.5060605@gmail.com> <201005011919.42294.mb@bu3sch.de> <4BDC6803.9030805@lwfinger.net> (sfid-20100501_174238_035394_CCE48505)
In-Reply-To: <4BDC6803.9030805@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005012015.50601.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 May 2010 19:42:27 Larry Finger wrote:
> I may have gotten the MMIO offset part wrong in the specs, but the
> Broadcom driver definitely writes to offset 0x648 at that point.

I do not think you are right.

First: The write has to happen to the 802.11 core and not to the chipcommon core.

Second: The code that was touched by Gábor is _very_ early in the SSB init.
Way ahead of the wireless core init. The specs state that the delay value has to be written
after the wireless core init is nearly done.
We do _exactly_ that in b43.

The only thing that needs to be done is to add the additional switch statement.
No MMIO writes have to be touched.

-- 
Greetings, Michael.
