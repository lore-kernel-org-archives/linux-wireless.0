Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:50018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752080AbeABNaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Jan 2018 08:30:06 -0500
Message-ID: <1514899804.2024.5.camel@sipsolutions.net> (sfid-20180102_143010_359264_E32CA8D8)
Subject: Re: [RFC 4/4] nl80211: Implement TX of control port frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Tue, 02 Jan 2018 14:30:04 +0100
In-Reply-To: <20171228175832.3253-5-denkenz@gmail.com> (sfid-20171228_185853_252453_1C65EE95)
References: <20171228175832.3253-1-denkenz@gmail.com>
         <20171228175832.3253-5-denkenz@gmail.com>
         (sfid-20171228_185853_252453_1C65EE95)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-12-28 at 11:58 -0600, Denis Kenzior wrote:
> This commit implements the TX side of NL80211_CMD_CONTROL_PORT_FRAME.
> Userspace provides the raw EAPoL frame using NL80211_ATTR_FRAME.  A
> skbuf is built and then injected onto the netdev of the wireless device.
> The CONTROL_PORT_ETHERTYPE_NO_ENCRYPT will still in theory be honored by

You mean CONTROL_PORT_NO_ENCRYPT :-)

> the underlying TX path code.

I think this isn't good enough.

There are cases where CONTROL_PORT_ETHERTYPE_NO_ENCRYPT should be
unset, but specific frames still shouldn't be encrypted.

So I think for this particular path it would be better to deprecate
CONTROL_PORT_ETHERTYPE_NO_ENCRYPT entirely, and have a separate per-
frame flag.

That also means that we can't really implement it fully in cfg80211,
but have to provide some functionality for the driver to do things to
be able to honour such flags.

Perhaps a new operation, where we pass a pre-built SKB and control
flags?

johannes
