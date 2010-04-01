Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45805 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0DAOYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 10:24:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <zajec5@gmail.com>
Subject: Re: [PATCH V3] ssb: do not read SPROM if it does not exist
Date: Thu, 1 Apr 2010 15:23:57 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1270064375-3138-2-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1270064375-3138-2-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004011623.58028.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 March 2010 21:39:35 John W. Linville wrote:
> However I have no idea what PCMCIA tuples are. Do we need similar check for
> some PCMCIA code?

The PCMCIA subsystem fetches the data for us through some mechanism similar
to PCI config space and provides the data via tuples.
See ssb/pcmcia.c -> ssb_pcmcia_get_invariants()

For now I would not recommend touching that code unless we have a device
that needs it.

-- 
Greetings, Michael.
