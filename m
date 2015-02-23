Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34953 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbBWPil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 10:38:41 -0500
Received: by pabrd3 with SMTP id rd3so21190953pab.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 07:38:40 -0800 (PST)
From: Rohan Joyce <rojoyce.github@gmail.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] nl80211: add NL80211_CMD_GET_TSF
Date: Mon, 23 Feb 2015 23:38:05 +0800
Message-Id: <1424705885-20987-1-git-send-email-rojoyce.github@gmail.com> (sfid-20150223_163850_184453_2191BE55)
In-Reply-To: <1424701880.3075.0.camel@sipsolutions.net>
References: <1424701880.3075.0.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The motivation for this patch is to assist using a WiiU Gamepad with Linux. 
The WiiU Gamepad is an input device that also contains an LCD touchscreen,
speakers and a variety of sensors. The Gamepad connects to an access
point (usually the WiiU console itself, but it can be coerced to connect
to a properly configured hostap). The Gamepad provides five services over
UDP. Two of the services that are provided (audio and video streaming to
the device) use the TSF as a timestamp in the application layer. The
firmware on the Gamepad checks to make sure that incoming packets for
these services have timestamps within 1000us of its own internal clock,
which is synced to the TSF of the access point.

At the moment, users who want to use this device have to manually apply 
a kernel patch similar to that which was first posted to this list a year
ago. This patch is my attempt to implement the functionality using a more
conventional API and make it easier for end users.

Should I include protocol implementation details specific to this device in
the documentation of the NL80211_CMD_GET_TSF command?

Thanks for your time,

Rohan
