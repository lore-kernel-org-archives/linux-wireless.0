Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassarossa.samfundet.no ([193.35.52.29]:53921 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445AbaH1Iho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 04:37:44 -0400
Date: Thu, 28 Aug 2014 10:37:38 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Support DTPC IE (from Cisco Client eXtensions)
Message-ID: <20140828083738.GA19530@sesse.net> (sfid-20140828_103748_631824_582930F7)
References: <20140824103728.GA2938@sesse.net>
 <E1XLZxt-0002h9-Um@pannekake.samfundet.no>
 <1409211818.2505.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1409211818.2505.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 28, 2014 at 09:43:38AM +0200, Johannes Berg wrote:
> Can you say *why* we want this? Does it yield better behaviour on a
> Cisco deployment?

Yes. The basic idea is: When your density goes up (many clients, many access
points), the 2.4 GHz band becomes very crowded and you get interference
across cells. The controller observes this (by seeing that the APs see each
other too strongly), and reduces the transmit power to reduce the cell size.
(This might be counterintuitive, because people's initial idea for better
Wi-Fi usually involves turning power _up_, but that only makes the problem
here worse, since the problem is interference, not range.)

It then also asks the clients to do the same (through DTPC), because the
clients' traffic of course also contributes to the interference. We should
honor its request, just as we honor it when it comes through 802.11h or
802.11d. If the controller detects that this creates coverage holes, it will
turn the power back up and just live with the interference.

Like the subject says, this is part of CCX (Cisco's set of wireless
extensions), so as far as I know, any CCX-certified driver, e.g. Intel
drivers on Windows, already support this.

/* Steinar */
-- 
Homepage: http://www.sesse.net/
