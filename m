Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3662 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab2HBLjf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 07:39:35 -0400
Message-ID: <501A66DE.3000500@broadcom.com> (sfid-20120802_134016_563943_8CA660C0)
Date: Thu, 2 Aug 2012 13:39:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"Josh Boyer" <jwboyer@redhat.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 0/2] Fix lockdep warning in brcmsmac
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2012 10:58 PM, Seth Forshee wrote:
> Seth Forshee (2):
>   cfg80211: add channel flag to restrict OFDM
>   brcmsmac: use channel flags to restrict OFDM
> 
>  drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    5 +----
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 ++-
>  include/net/cfg80211.h                             |    2 ++
>  net/wireless/reg.c                                 |    2 ++
>  4 files changed, 7 insertions(+), 5 deletions(-)

Does the trick. No more warnings on lockdep kernel. For both you can add

Tested-by: Arend van Spriel <arend@broadcom.com>

Gr. AvS


