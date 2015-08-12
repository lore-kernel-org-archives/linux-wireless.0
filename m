Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f54.google.com ([209.85.192.54]:36049 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbHLSoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 14:44:23 -0400
Received: by qgdd90 with SMTP id d90so16629936qgd.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2015 11:44:22 -0700 (PDT)
MIME-Version: 1.0
From: Kobi Cohen-Arazi <kobi.cohenarazi@gmail.com>
Date: Wed, 12 Aug 2015 11:36:04 -0700
Message-ID: <CAF7g2RHhY_aEHF7nr4VdzVrUf+_cdoKxXbUkajQcx_LxpvvFSA@mail.gmail.com> (sfid-20150812_230539_080974_AF144C33)
Subject: iw coalesce show - disabled at init?
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When loading a wifi driver that supports set_coalesce and running "iw
show" command:
$ iw ... coalesce show
It would always show coalesce as disabled.
I think the reason for this is that there are no coalesce rules cached
in cfg/netlink layers yet. (empty set of rules).

Is my understanding correct? if yes, Is this by design?
Ideally, at startup, 80211 should query the driver for the current
coalesce rules and use it as the initial state.

Thank you,
- Kobi
