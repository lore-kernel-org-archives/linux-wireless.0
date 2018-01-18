Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34044 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752100AbeARVUO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 16:20:14 -0500
Message-ID: <1516310411.410.57.camel@sipsolutions.net> (sfid-20180118_222018_850187_5BDA602E)
Subject: Re: [PATCH] cfg80211: stop demanding lots of new stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hughd@google.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Jan 2018 22:20:11 +0100
In-Reply-To: <alpine.LSU.2.11.1801181242280.14771@eggly.anvils> (sfid-20180118_220757_478148_167925B3)
References: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils>
         (sfid-20180117_235601_216213_A3BA62CE) <1516258057.410.55.camel@sipsolutions.net>
         <alpine.LSU.2.11.1801181242280.14771@eggly.anvils>
         (sfid-20180118_220757_478148_167925B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-01-18 at 13:07 -0800, Hugh Dickins wrote:

> Perhaps you did not try on a system without SYSTEM_DATA_VERIFICATION
> already enabled - that "select SYSTEM_DATA_VERIFICATION" seems to be
> taking effect even when CFG80211_REQUIRE_SIGNED_REGDB is not enabled,
> and pulls in a boatload.

I kinda know actually.

> In fact, I cannot even build the resulting config, without scurrying
> around to update userspace with stuff I never needed before:
> 
>   HOSTCC  scripts/extract-cert
> scripts/extract-cert.c:21:25: fatal error: openssl/bio.h: No such file or directory

Fun.

I think the only thing we can do is make REGDB_AS_FW a (new) Kconfig
option that you can then turn off.

johannes
