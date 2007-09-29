Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:10082 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbXI2AZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 20:25:37 -0400
Received: by py-out-1112.google.com with SMTP id u77so5564720pyb
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 17:25:36 -0700 (PDT)
Message-ID: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
Date: Fri, 28 Sep 2007 20:25:36 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Michael Wu" <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Kernelspace --> Userspace MLME move and related items
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I was discussing with johill earlier we should probably lay down
the overal layout of what our communication path will look like down
the road between userspace, userspace MLME, cfg8021, nl80211 and
drivers both FullMAC and SoftMAC, This conversation spawned over
implementing the next console userspace configuration utility, iw.

This is necessary so we don't write userspace utilities we later have
to replace or simply start with bad design from the beginning. I think
it will also help set our pace on what items we need to prioritize in
the short term for kernel releases and also on the long run.

What really puzzles me right now is the communication path between
userspace and the userspace MLME, and even if this communication
should exist. I've edited some draft stuff about this and
communication paths. I'd like to ask those of you working on this to
please help fix and update it.

For now I've stashed here:

http://linuxwireless.org/en/developers/todo_list#userspacemlme

Other items which we should consider:

* Should umlme be optional or is this desired mandatory down the road?
* How long should we wait to swich to a umlme?

  Luis
