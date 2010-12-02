Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51285 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab0LBR7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 12:59:54 -0500
Received: by bwz15 with SMTP id 15so7495750bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 09:59:53 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs
Date: Thu, 2 Dec 2010 18:58:45 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1291311849-13086-1-git-send-email-helmut.schaa@googlemail.com> <1291311968.3481.52.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291311968.3481.52.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012021858.46044.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 02 Dezember 2010 schrieb Johannes Berg:
> On Thu, 2010-12-02 at 18:44 +0100, Helmut Schaa wrote:
> > mac80211 doesn't handle shared skbs correctly at the moment. As a result
> > a possible resize can trigger a BUG in pskb_expand_head.
> 
> Could monitor_start_xmit have the same issue?

Hmm, good point. Are we expecting shared skbs on monitor interfaces somehow?

To be honest I don't know in which situations shared skbs are used (despite
the pktgen case I've run into) and thus cannot make a qualified statement :)

pktgen only generates 802.3 frames AFAICS and not arbitrary frames, so this
is not usable for monitor interfaces (yet?).

Helmut
