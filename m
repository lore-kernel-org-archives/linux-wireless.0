Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:60208 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbZBPP7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 10:59:41 -0500
Date: Mon, 16 Feb 2009 17:00:16 +0100
From: Daniel Wagner <wagi@monom.org>
To: linux-wireless@vger.kernel.org
Cc: networkmanager-list@gnome.org
Subject: NetworkManager and mac80211_hwsim
Message-ID: <20090216160016.GA29509@toronto053.server4you.de> (sfid-20090216_165945_976037_910C9191)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'd like to setup a simple test scenario with mac80211_hwsim in
order to check some corner cases in the scanning behaviour
in NetworkManager. Though the problem is that NM doesn't see
the mac8011_hwsim devices. I found out that the problem is
that hald won't notifiy on dbus there is a new wireless device
available. After a bit debugging I can tell that the problem is
that there isn't a parent device available:

hal/hald/device.c:

hotplug_event_begin_add_dev (..., parent_dev = NULL, ...)
  net_add(..., parent_dev = NULL, ...)
  {
  	if (parent_dev == NULL)
		goto error;
  }

Before I go deeper into that thing, does someone has
an idea what could go wrong here with mac80211_hwsim?

thanks,
daniel
