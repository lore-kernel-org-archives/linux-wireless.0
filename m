Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3569 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab2HBLCS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 07:02:18 -0400
Message-ID: <501A5E24.6010302@broadcom.com> (sfid-20120802_130222_365413_4504C0D3)
Date: Thu, 2 Aug 2012 13:01:56 +0200
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
> As reported by Josh Boyer, brcmsmac is producing lockdep warnings by
> calling freq_reg_info() without holding cfg80211_lock. Currently
> freq_reg_info() is the only way for a wireless driver to tell whether
> OFDM is allowed on the current channel, but cfg80211_lock is outside the
> scope of the wireless drivers.
> 
> Since other regulatory restrictions are communicated in the channel
> definition, it makes sense to do the same for OFDM. These patches add a
> new flag, IEEE80211_CHAN_NO_OFDM, which is set by regulatory to
> indicated OFDM operation is prohibited. brcmsmac is modifified to use
> this flag instead of consuming the regulatory data directly.
> 
> Thanks,
> Seth

I will try the patches on a lockdep-enabled kernel.

Gr. AvS

