Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49325 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1A3LZM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 06:25:12 -0500
Received: by gxk9 with SMTP id 9so1635323gxk.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 03:25:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110126140444.GA30373@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net> <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
 <20110126140444.GA30373@jm.kir.nu>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 30 Jan 2011 13:24:56 +0200
Message-ID: <AANLkTi=AWanc8+JK7hQnRMpPEC+2hK0aTn0xenru7Ryw@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
To: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey Jouni, Johannes,

After discussing this with the wl12xx FW guys, it seems that:
- WPS2 and P2P special cases are currently not handled in FW - the
default template is always returned for probe requests
- The AP currently always responds to a probe request
- The AP currently never passes up probe requests

In light of this new info, this might be a possible solution:
- Implement a capability flag for
ap-supports-offloading-of-basic-probe-reqs. With "basic" I mean WPS1/2
and P2P IEs are not included.
- Hostapd will configure a probe-resp template only when it supports
probe-resp offloading (currently when WPS and P2P are off) and the
driver supports it (using the capability flag).
- Support a "pass and and don't reply to probe requests" mode in FW
(this will take some time to implement).

For now the wl12xx driver must operate in a "compatibility" mode,
since the FW doesn't support passing-up probe requests. When the
probe-resp template is not available we will use the beacon template,
as currently used now. There are currently no plans for intelligent
filtering of probe requests in FW - its all or nothing.

Should hostapd reply to probe requests when offloading is configured?
This is a moot point for wl12xx since probe-requests are not passed
up. Do you have a preference here?

I'd appreciate your comments on this.

Arik
