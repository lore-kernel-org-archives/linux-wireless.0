Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36183 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab2LLPN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 10:13:28 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so432010bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 07:13:27 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Date: Wed, 12 Dec 2012 16:13:12 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steev Klimaszewski <steev@genesi-usa.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1330720003-15866-1-git-send-email-dmitry.tarnyagin@stericsson.com> <20120706201839.GE1879@tuxdriver.com> <20121211232311.GA9080@shaftnet.org>
In-Reply-To: <20121211232311.GA9080@shaftnet.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201212121613.12750.chunkeey@googlemail.com> (sfid-20121212_161331_384926_400113B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, December 12, 2012 12:23:11 AM Solomon Peachy wrote:
> On Fri, Jul 06, 2012 at 04:18:40PM -0400, John W. Linville wrote:
>
> IIRC it's because mac80211 doesn't provide a way of pre-allocating MIC 
> space at the tail end of the frame -- the hardware performs the work but 
> still needs the space in the payload.  The code I'm maintaining has 
> workarounds for this; not the most efficient solution but I'd rather see 
> the code merged as-is, and then we can incrementally improve things 
> (perhaps by enhancing mac80211 as needed)

Mac80211 already reserves at least 18 bytes tailroom [which can be
allocated by a simple skb_put]. In fact p54 uses this tailroom to
pass the MIC (8 bytes) + ICV (4 bytes) to the firmware. Do you need
more than 18 bytes?

Regards,
	Chr
