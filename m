Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:41798 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaIBIPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 04:15:24 -0400
Received: by mail-qg0-f54.google.com with SMTP id q107so6055424qgd.41
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 01:15:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409644993.1808.4.camel@jlt4.sipsolutions.net>
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b> <1409644993.1808.4.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Tue, 2 Sep 2014 10:15:03 +0200
Message-ID: <CAGnRvuogOXpLLbm4bLgE46Xu6C3y6hrGPQej0Mh2_dyA8w_Ubw@mail.gmail.com> (sfid-20140902_101531_172447_87E02F58)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 2, 2014 at 10:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2014-09-01 at 13:26 +0200, Henning Rogge wrote:
>> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
>> allows to query the content of the 'mesh proxy path' table of mac80211s via
>> 'get' or 'dump'  operation.
>
> Is this really something that should be a generic nl80211 operation,
> rather than say debugfs?

No, this should be (in my opinion) a nl80211 operation.

It is directly comparable to "station get/dump" and "mpath get/dump".

> Could this be useful to other devices implementing the 11s, or is it
> more of a mac80211 implementation detail?

Yes, this could be relevant to all 11s implementations. Without this
data you cannot determine where your data packages will be going
(similar to the routing table/fib, just layer-2).

In my case I need this feature to correlate the layer-2 data I got
from a "station dump" with the mac addresses of bridged devices.

I am trying to implement a DLEP-style radio/router system (see
http://tools.ietf.org/html/draft-ietf-manet-dlep-06), which combines a
IP router with a bridged radio (both connected via ethernet). The
routers can talk directly to each other, but to map the layer-2 data
from the radio (which refers to the wifi MAC addresses) to the router
communication, I need the mapping table.

Henning Rogge
