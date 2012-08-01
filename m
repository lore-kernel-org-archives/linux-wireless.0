Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2659 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2HAT3D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 15:29:03 -0400
Message-ID: <50198370.20304@broadcom.com> (sfid-20120801_212906_348018_4BA77A10)
Date: Wed, 1 Aug 2012 21:28:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Josh Boyer" <jwboyer@redhat.com>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	"Seth Forshee" <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: assert_cfg80211_lock warning with Linux v3.5-8833-g2d53492
References: <20120801131232.GA1785@zod.bos.redhat.com>
 <20120801141810.GB27433@tuxdriver.com> <50194D7A.6060400@broadcom.com>
 <5019506C.6020707@broadcom.com>
 <1343836438.4638.5.camel@jlt3.sipsolutions.net>
 <50196660.8090001@broadcom.com>
In-Reply-To: <50196660.8090001@broadcom.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/01/2012 07:24 PM, Arend van Spriel wrote:
> It seems the API was as it currently is when adding regulatory framework
> changes in brcmsmac so we should have seen this assert flying by. The
> problem is that freq_reg_info() is exposed in cfg80211.h, but as it is
> now it can only be used under the cfg80211_mutex lock, ie. in regulatory
> notify callback (as Seth indicated).
> 
> Gr. AvS

Ah, I see you need to run a LOCKDEP-enabled kernel to get this warning.

Gr. AvS

