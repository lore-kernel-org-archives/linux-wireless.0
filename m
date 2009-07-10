Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419AbZGJT5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 15:57:25 -0400
Message-Id: <20090710195131.504091075@sipsolutions.net>
Date: Fri, 10 Jul 2009 21:51:31 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, tgraf@suug.ch,
	"Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 0/4] generic netlink namespace awareness
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series makes generic netlink network namespace
aware, in some way, paving the way for making wireless
completely netns aware (which I will submit to John's tree).

The required changes are basically some preparations in
core netlink, a change to make it possible to iterate net
namespaces under just RCU (which may be useful elsewhere in
the future), the actual genetlink patch and finally also
exporting get_net_ns_by_pid() which wireless will need.

The last patch (for get_net_ns_by_pid) could go through
the wireless tree as well, but I've put it in here since
it touches core code. The others probably shouldn't go
through the wireless tree since they touch more than that.

The first patch in this series fixes the last remaining
problem I had with the generic netlink one, the patches
are actually unchanged from the previous submission other
than adding patch 1 in front.

johannes

