Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2LNNqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 08:46:25 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TjVap-0001YU-7T
	for linux-wireless@vger.kernel.org; Fri, 14 Dec 2012 14:46:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mac80211: bss_info_changed cleanups
Date: Fri, 14 Dec 2012 14:46:42 +0100
Message-Id: <1355492806-31673-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_144629_183869_9F7A9072)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recalculations going on in the function are rather odd
and hard to follow, replace them with explicit interface
type dependent handling where needed at all, overall this
makes the code simpler and little bit smaller:

   text	   data	    bss	    dec	    hex	filename
 610582	  38811	    720	 650113	  9eb81	net/mac80211/mac80211.ko (before)
 610415	  38812	    720	 649947	  9eadb	net/mac80211/mac80211.ko (after)

johannes

