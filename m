Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3JQQCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 12:02:49 -0400
Message-ID: <1382025750.14410.20.camel@jlt4.sipsolutions.net> (sfid-20131017_180252_662918_197A7631)
Subject: Re: [PATCH v5 4/5] {nl,cfg,mac}80211: implement mesh channel switch
 userspace API
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Date: Thu, 17 Oct 2013 18:02:30 +0200
In-Reply-To: <CAHS2MGMgTp9homs-moVXTVfyFtcuYPPbHBiiW0XD9kBYJ0hb5w@mail.gmail.com> (sfid-20131017_175208_552032_89AFFCB3)
References: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381802911-3921-5-git-send-email-yeohchunyeow@cozybit.com>
	 <1382022683.14410.18.camel@jlt4.sipsolutions.net>
	 <CAHS2MGMgTp9homs-moVXTVfyFtcuYPPbHBiiW0XD9kBYJ0hb5w@mail.gmail.com>
	 (sfid-20131017_175208_552032_89AFFCB3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 23:52 +0800, Chun-Yeow Yeoh wrote:
> > If this fails, do we leak the CSA settings?
> If failed, beacon won't include the CSA settings. But If there is any
> other calling mesh_rebuild_beacon and succeed, the it will be included
> up if the channel switch count is not expired. At the same time, CSA
> action frame is also transmitted, so others may use this to start the
> CSA process.

That part makes sense. But we propagate the error up, and then we
probably never call the finish function?

johannes

