Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:33121 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbCFIEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 03:04:40 -0500
Received: by wghb13 with SMTP id b13so58419930wgh.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 00:04:38 -0800 (PST)
MIME-Version: 1.0
From: Henning Rogge <hrogge@gmail.com>
Date: Fri, 6 Mar 2015 09:04:17 +0100
Message-ID: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com> (sfid-20150306_090443_682749_CB8CE461)
Subject: State of DFS with Mac80211/ath9k
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am working with a co-worker on DFS-support for the 802.11s
implementation of the mac80211 stack.

As a test we just removed the test for "DFS not supported" from
net/mac80211/mesh.c, but we are still facing two problems.

First, we cannot open a Mesh interface on a DFS channel unless we open
an AP interface first (and closing the AP interface before activating
the mesh). Are we missing some special initialization?

Second, we are seeing a huge amount of radar events on some nodes, but
not on a node on the same channel in the next room. What is the status
of the DFS detector in ath9k, is it reliable or is it still
"experimental".

Henning Rogge
