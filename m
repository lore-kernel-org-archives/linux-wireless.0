Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:43050 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaDXJEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:04:24 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so1966584wes.32
        for <linux-wireless@vger.kernel.org>; Thu, 24 Apr 2014 02:04:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398329415.4154.1.camel@jlt4.sipsolutions.net>
References: <1398327250-12923-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQkBCGyKYDaOMgdCi4Yw+SXeuRS+t0rGE8o=8+x2q5N74w@mail.gmail.com>
	<1398329415.4154.1.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Apr 2014 11:04:22 +0200
Message-ID: <CA+BoTQkutgixefexBRcTcDBrWpXCy0YFzdDuoY1PdHc3J1Hejw@mail.gmail.com> (sfid-20140424_110437_935817_F4858E11)
Subject: Re: [PATCH] ath10k: don't allow stand alone monitor mode for non-AP firmware
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 April 2014 10:50, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-04-24 at 10:44 +0200, Michal Kazior wrote:
>
>> I think Monitor operation should be performed on a best effort basis.
>> This means monitor_start/stop should be attempted once number of
>> non-monitor vdevs changes.
>>
>> We should probably introduce a ath10k_recalc_monitor() for that purpose.
>
> Doesn't mac80211 do that for you?
>
> See IEEE80211_HW_WANT_MONITOR_VIF.

This is not sufficient in this case.

E.g. If you add a disconnected 4addr sta interface to bridge the
interface enters promisc mode. This attempts to start monitor vdev in
ath10k before sta vdev is started internally. We could probably make
it start earlier (in add_interface) but there still remains a problem
when you stop last non-monitor interface (monitor vif will be created
_after_ last non-monitor is removed which is too late).


Michał
