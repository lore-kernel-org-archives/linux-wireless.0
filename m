Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:32369 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754353AbYHNJIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 05:08:25 -0400
To: linux-wireless@vger.kernel.org
Subject: 2.6.27-rc ... iwl3945 regression?
From: David Brownell <david-b@pacbell.net>
Date: Thu, 14 Aug 2008 02:08:18 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808140208.18969.david-b@pacbell.net> (sfid-20080814_110829_210999_7BE5194A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I haven't looked into this yet, maybe it's just a kernel config change
of some kind ...


Userspace is Ubuntu 8.04 with NetworkManager and nm-applet; nothing
changed there recently.

2.6.26 works as expected ... unless I have the RF switch at "off",
when I left-click the applet, I get a list of cells available.  And
it will spontaneously join the right one.  It Just Works (yay!).

But with 2.6.27-rc, that's not true.  Left-click shows me two "Wired"
networks, "Intel Corporation PRO/Wireless 3945ABG Network Connection"
replacing the list of cells I would expect.  Status of RF switch
at boot doesn't matter.

However, "iwlist scan" shows a dozen cells or so ... so the issue
would seem to be that somehow wlan0 or wmaster0 started to look like
wireful links, instead of wireless ones.  (Seen early in RC0, and
just now verified as being in RC3.)


Does this sound familiar to anyone?  Got a fix that's better than
sticking to a 2.6.26 kernel?  :)

- Dave
