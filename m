Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44355 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2INNfV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 09:35:21 -0400
Message-ID: <50533297.2030103@openwrt.org> (sfid-20120914_153525_859044_ECBD6ECB)
Date: Fri, 14 Sep 2012 15:35:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT v2] cfg80211: fix possible circular lock on reg_regdb_search()
References: <1347569712-24886-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1347569712-24886-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-09-13 10:55 PM, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> When call_crda() is called we kick off a witch hunt search
> for the same regulatory domain on our internal regulatory
> database and that work gets kicked off on a workqueue, this
> is done while the cfg80211_mutex is held. If that workqueue
> kicks off it will first lock reg_regdb_search_mutex and
> later cfg80211_mutex but to ensure two CPUs will not contend
> against cfg80211_mutex the right thing to do is to have the
> reg_regdb_search() wait until the cfg80211_mutex is let go.
Tested-by: Felix Fietkau <nbd@openwrt.org>

