Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbaKMMgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 07:36:09 -0500
Date: Thu, 13 Nov 2014 13:33:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Marcel Holtmann <marcel@holtmann.org>
Subject: Can fb4e156886ce6e8309e912d8b370d192330d19d3 be reverted ?
Message-ID: <20141113123313.GA1926@redhat.com> (sfid-20141113_133628_786084_BDEA3269)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've updated wireless code on RHEL and get complain that now
cfg80211 and rfkill modules are loaded on machines that do not have
wireless hardware. Modules are auto-loaded because NetworkManager send
nl80211 messages to check if there are wireless devices in the system.

Hence my question, can we revert commit fb4e156886ce
"nl80211: Add generic netlink module alias for cfg80211/nl80211" ?

Auto loading nl80211 does not seems to be necessary, if there are
wireless devices nl80211 will be loaded anyway.

Stanislaw

