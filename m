Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49925 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1GTRAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 13:00:35 -0400
Received: by pvg12 with SMTP id 12so332866pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 10:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311115936.3872.3.camel@jlt3.sipsolutions.net>
References: <1311115936.3872.3.camel@jlt3.sipsolutions.net>
Date: Wed, 20 Jul 2011 19:00:34 +0200
Message-ID: <CACna6rwz3YLahb0t4CCfmUK7HFdyYFmEpCNuWWDe+zmg0LbxsQ@mail.gmail.com> (sfid-20110720_190038_732323_DB408F44)
Subject: Re: [PATCH] cfg80211: fix scan crash on single-band cards
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/20 Johannes Berg <johannes@sipsolutions.net>:
> From: Johannes Berg <johannes.berg@intel.com>
>
> commit 58389c69150e6032504dfcd3edca6b1975c8b5bc
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Mon Jul 18 18:08:35 2011 +0200
>
>     cfg80211: allow userspace to control supported rates in scan
>
> made single-band cards crash since it would always
> access all wiphy->bands[]. Fix this and reject any
> attempts in the new helper ieee80211_get_ratemask()
> to do the same, rejecting rates configuration for
> unsupported bands.
>
> Reported-by: Pavel Roskin <proski@gnu.org>
> Tested-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Just confirming the fix from my Broadcom cards and b43.

-- 
Rafał
