Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbXCYS3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2007 14:29:13 -0400
Subject: Re: [PATCH] bcm43xx: Fix machine check on PPC for version 1 PHY
From: David Woodhouse <dwmw2@infradead.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
In-Reply-To: <4606BE34.7000705@lwfinger.net>
References: <46067d12.1uF8l72xIYAG6Vyb%Larry.Finger@lwfinger.net>
	 <200703251613.23880.mb@bu3sch.de>
	 <1174841628.20505.244.camel@pmac.infradead.org>
	 <4606BE34.7000705@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 Mar 2007 19:29:11 +0100
Message-Id: <1174847351.20505.275.camel@pmac.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-03-25 at 13:23 -0500, Larry Finger wrote:
> There aren't any. Joseph is making the changes to the V4 specs, most
> of which are valid for V3 as well. If I have any questions, I ask him
> privately.

There is an important difference between the v3 and v4 specs in this
respect. Looking at http://bcm-v4.sipsolutions.net/802.11/PHY/Init/G I
see in =C2=A77a that we're only supposed to set PHY register 0x4cc if t=
he A
PHY revision is 5. The v3 specs seem to suggest that we should do that
whenever the revision is below 6 and not equal to 3.=20

The A PHY revision in my case is 2, and it's the access to PHY register
0x4CC which triggers the machine check.

--=20
dwmw2

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
