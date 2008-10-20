Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:5343 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYJTIYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 04:24:53 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1840552wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 01:24:52 -0700 (PDT)
Message-ID: <1ba2fa240810200124k2d30b49aqb8e08b70251d3896@mail.gmail.com> (sfid-20081020_102457_538788_BB366F8C)
Date: Mon, 20 Oct 2008 10:24:52 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Power saving on mac80211
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Kalle Valo" <kalle.valo@nokia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1224483339.6324.55.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	 <1224434885.6324.49.camel@johannes.berg> <87myh0a1zd.fsf@nokia.com>
	 <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com>
	 <1224483339.6324.55.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 8:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2008-10-19 at 18:46 -0700, Luis R. Rodriguez wrote:
>
>> I wanted to note intel hardware seems to handle parsing beacons in
>> firmware when is PS mode already and I have no clue when it would
>> inform mac80211 of a beacon miss and if it does it. Tomas?

firmware parses beacons for PS and other purposes. There is beacon notification

struct iwl4965_missed_beacon_notif {
	__le32 consequtive_missed_beacons;
	__le32 total_missed_becons;
	__le32 num_expected_beacons;
	__le32 num_recvd_beacons;
} __attribute__ ((packed));

> It doesn't do anything at all with mac80211.

Nope, currently it's used just as statistics. The major purpose is not
PS but link quality (triggering roaming), but it can be abused for
other good purposes.
Tomas
