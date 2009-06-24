Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbZFXMJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:29 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIA-0002y5-D6
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:09:30 +0200
Message-Id: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/11] cfg80211 connect API + wireless extension move
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This finally introduces nl80211 and cfg80211 connect API,
and makes wireless extensions entirely self-contained in
cfg80211.

YES.

The last four patches still need more work:
 * the combine patches require getting iwm ported
 * the internalise patch requires getting orinoco
   and rndis ported.

Samuel, who also worked a lot on the first three bits of   
this series, is working on getting iwm ported, and then    
we can stick this into the tree except for the last patch, 
and gradually work on the rest. Maybe we even decide to    
not internalise it this way because orinoco wants to keep  
some ioctls that we'll not offer in cfg80211, not sure yet.

Also, this still needs a bit of work for auth algorithms.  
Currently, the series breaks shared key auth. For iwm, the 
device will only try the auth algorithm you ask it to use, 
but mac80211 is able to select the algorithm automatically.
It might make most sense to make cfg80211 try different 
algorithms if userspace didn't specify which one to use.

Anyway, comments welcome!

johannes

