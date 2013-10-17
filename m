Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62129 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab3JQPwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 11:52:07 -0400
Received: by mail-ob0-f182.google.com with SMTP id va2so2024255obc.41
        for <linux-wireless@vger.kernel.org>; Thu, 17 Oct 2013 08:52:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382022683.14410.18.camel@jlt4.sipsolutions.net>
References: <1381802911-3921-1-git-send-email-yeohchunyeow@cozybit.com>
	<1381802911-3921-5-git-send-email-yeohchunyeow@cozybit.com>
	<1382022683.14410.18.camel@jlt4.sipsolutions.net>
Date: Thu, 17 Oct 2013 23:52:06 +0800
Message-ID: <CAHS2MGMgTp9homs-moVXTVfyFtcuYPPbHBiiW0XD9kBYJ0hb5w@mail.gmail.com> (sfid-20131017_175211_606674_11A36EC8)
Subject: Re: [PATCH v5 4/5] {nl,cfg,mac}80211: implement mesh channel switch
 userspace API
From: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org,
	"distro11s@cozybit.com" <distro11s@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If this fails, do we leak the CSA settings?
If failed, beacon won't include the CSA settings. But If there is any
other calling mesh_rebuild_beacon and succeed, the it will be included
up if the channel switch count is not expired. At the same time, CSA
action frame is also transmitted, so others may use this to start the
CSA process.

Am I answer your question?

----
Chun-Yeow
