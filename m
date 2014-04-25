Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56226 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaDYOrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 10:47:10 -0400
Message-ID: <1398437216.4152.7.camel@jlt4.sipsolutions.net> (sfid-20140425_164718_713823_B9649C88)
Subject: Re: [PATCH] cfg80211: Fix GO Concurrent relaxation on UNII-3
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Fri, 25 Apr 2014 16:46:56 +0200
In-Reply-To: <1398234178-24685-1-git-send-email-ilan.peer@intel.com> (sfid-20140423_092926_556077_B4B8B67A)
References: <1398234178-24685-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140423_092926_556077_B4B8B67A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-04-23 at 09:22 +0300, Ilan Peer wrote:
> At some locations, channels 149-165 are considered a single
> bundle, while at some other locations, e.g., Indonesia, channels
> 149-161 are considered a single bundle, while channel 165 belongs
> to a different bundle. This means that:
> 
> 1. A station interface connection to an AP on channel 165 allows
>    the instantiation of a P2P GO on channels 149-165.
> 2. A station interface connection to an AP on channels 149-161
>    does NOT allow the instantiation of a P2P GO on channel 165.
> 
> Fix this.

I'll apply this, but I'm not a big fan of it. Please work with Luis to
get some information into the regulatory database.

Luis pointed this out originally [1] when you were adding the UNII-1/2/3
things to the kernel that he didn't think they'd be universally
applicable, but you said they were ... I guess Luis also thought it was
true though, and it doesn't seem to be (which seems to be because of the
80MHz thing with channel 165 I guess)

johannes

[1] http://mid.gmane.org/CAB=NE6VQXQPRK9_Q-Nh+ripRa
+PdCd=4_EZvPxeghBjc32ejyQ@mail.gmail.com


