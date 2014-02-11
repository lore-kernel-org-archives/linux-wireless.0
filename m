Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0207.hostedemail.com ([216.40.44.207]:56540 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752916AbaBKROI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 12:14:08 -0500
Message-ID: <1392138837.2511.2.camel@joe-AO722> (sfid-20140211_181437_159895_54CDB74C)
Subject: Re: [PATCH v3] ieee80211: Print human-readable disassoc/deauth
 reason codes
From: Joe Perches <joe@perches.com>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 09:13:57 -0800
In-Reply-To: <20140211163738.GA32043@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
	 <1391661863.30094.56.camel@joe-AO722>
	 <1392030546.4128.11.camel@jlt4.sipsolutions.net>
	 <1392050359.2507.10.camel@joe-AO722> <20140211012523.GA2739@gmail.com>
	 <1392082740.2507.49.camel@joe-AO722> <20140211163738.GA32043@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-02-11 at 10:37 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that in addition to the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.
[]
>  include/net/mac80211.h | 10 +++++++++
>  net/mac80211/main.c    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  net/mac80211/mlme.c    | 12 +++++------
>  3 files changed, 73 insertions(+), 6 deletions(-)

Is there a reason why all of this this shouldn't
be a static function local to mlme.c?

Is this ever going to be used somewhere else?


