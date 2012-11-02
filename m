Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50442 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab2KBSqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2012 14:46:34 -0400
Received: by mail-vb0-f46.google.com with SMTP id ff1so4089747vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2012 11:46:34 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Nov 2012 14:46:33 -0400
Message-ID: <CA+7oygeOHQLcdEWpedbXDnBoAHrXddkrmNd3-PNQOKzoyNkn6w@mail.gmail.com> (sfid-20121102_194647_409070_5FC1958E)
Subject: bug in compat-wireless 3.6, rt2x00 iftype is wrong
From: George Nychis <gnychis@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm still trying to track down the cause for this, but starting in
compat-wireless-3.6 (including early RCs and the most recent 3.6.2),
rt2x00 devices register with the wrong iftype.  They register as
NL80211_IFTYPE_MONITOR instead of NL80211_IFTYPE_STATION, for example.
 I checked cw-3.5, 3.4, 3.2, and 3.1 and none of these versions have
this bug.

This breaks the ability to set channels, etc.  Hoping to track down
the bug, but wanted to report it in the meantime and see if anyone
else has run in to it.

- George
