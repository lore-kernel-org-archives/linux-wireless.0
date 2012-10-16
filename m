Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35367 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab2JPIEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 04:04:41 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so798530qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2012 01:04:40 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 16 Oct 2012 10:04:39 +0200
Message-ID: <CAJJAcodOQY6PDp6d=jG30u_7B30G3j8xOrtLQVmEJ4TDYjh_xQ@mail.gmail.com> (sfid-20121016_100449_784478_52CE3ED8)
Subject: Question about ieee802_1d_to_ac
From: David Shwatrz <dshwatrz@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I see in net/mac80211/wme.c:
...
const int ieee802_1d_to_ac[8] = {
	IEEE80211_AC_BE,
	IEEE80211_AC_BK,
	IEEE80211_AC_BK,
	IEEE80211_AC_BE,
	IEEE80211_AC_VI,
	IEEE80211_AC_VI,
	IEEE80211_AC_VO,
	IEEE80211_AC_VO
};
...

As I understand, this values stand for queues for different types of traffic:
IEEE80211_AC_BE is  best-effort traffic ,
IEEE80211_AC_BK is background traffic ,
IEEE80211_AC_VI is video traffic,
IEEE80211_AC_VO is voice traffic.

We see that entries 6,7 are  voice and entries 4,5 are video.
Is it not an error that entries 2,3 differ ? and also 0,1 ?

shouldn't it be:
const int ieee802_1d_to_ac[8] = {
	IEEE80211_AC_BE,
	IEEE80211_AC_BE,
	IEEE80211_AC_BK,
	IEEE80211_AC_BK,


Regards,
D Shwartz
