Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbYFDBlM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 21:41:12 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m541fBaB007558
	for <linux-wireless@vger.kernel.org>; Tue, 3 Jun 2008 21:41:11 -0400
Received: from mail.boston.redhat.com (mail.boston.redhat.com [10.16.255.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m541fAwT006999
	for <linux-wireless@vger.kernel.org>; Tue, 3 Jun 2008 21:41:10 -0400
Received: from [10.11.14.111] (vpn-14-111.rdu.redhat.com [10.11.14.111])
	by mail.boston.redhat.com (8.13.1/8.13.1) with ESMTP id m541fAFi020753
	for <linux-wireless@vger.kernel.org>; Tue, 3 Jun 2008 21:41:10 -0400
Subject: mac80211 ad-hoc mode problems
From: Dan Williams <dcbw@redhat.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=utf8
Date: Tue, 03 Jun 2008 21:41:04 -0400
Message-Id: <1212543664.4237.14.camel@localhost.localdomain> (sfid-20080604_034126_005983_906C2124)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While adding adhoc shared network support to NM, I ran into a few
mac80211 problems.

1) doesn't send SIOCGIWAP event on successful adhoc activation (patch
forthcoming)

2) takes a _really_ long time to create an adhoc network.  This is
controlled by IEEE80211_IBSS_JOIN_TIMEOUT.  Why is that 20 seconds?  Th=
e
problem here is that wpa_supplicant has an association timer shorter
than =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT and will re-try the connectio=
n,
causing mac80211 to reset ifsta->ibss_join_req.  FullMAC drivers will
simply look in their scan list (and optionally perform one scan) and if
the IBSS isn't found, create it.  I'd really like to
take =EF=BB=BFIEEE80211_IBSS_JOIN_TIMEOUT down to 5 or 7 seconds.  This=
 is only
the initial IBSS creation, IBSS merging will still be in effect.  I
simply thing 20 seconds is really too long here.

3) doesn't send NULL SIOCGIWAP disassoc events when the device goes dow=
n
or the module is removed.  Where's the best place to put the event on
module remove?

4) Is the association expected to survive a up->down->up sequence?  If
not, then we should be sending NULL SIOCGIWAP event whenever dev_close(=
)
gets called.

5) mac80211 requires the device to be down when changing modes.  That's
fine; but requires a patch to wpa_supplicant to handle this.  This woul=
d
cause failures when switching AP that were different modes from NM.
See:

http://lists.shmoo.com/pipermail/hostap/2008-June/017894.html

Dan

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
