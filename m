Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:63531 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3LCQfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:35:50 -0500
Received: by mail-we0-f170.google.com with SMTP id w61so13982392wes.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 08:35:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1386077130.4393.21.camel@jlt4.sipsolutions.net>
References: <1384198356-427-1-git-send-email-rajeshc@qca.qualcomm.com> <1386077130.4393.21.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 3 Dec 2013 17:35:28 +0100
Message-ID: <CAB=NE6Xa-bdLQm8uAg9wCE0fdp4KPBZ46d5FHVHp6wCvN5=dUA@mail.gmail.com> (sfid-20131203_173559_996913_A65B7396)
Subject: Re: [PATCHv3] cfg80211: add support for frequency interference event
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Rajesh Chauhan <rajeshc@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	Jeff Johnson <jjohnson@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>, sameert@qca.qualcomm.com,
	c_arifh@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 3, 2013 at 2:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> + * @interference_source: enum nl80211_freq_interference_source_type
>> + *   is used to specify source of interference.
>
> Do we expect that different sources would be treated differently? If
> not, what use is this?

That was because of my nagging, without such a field the type of
interference would be completely ambiguous and we'd have no users on
the Linux kernel of this API, making anyone wonder WTF this is used
for, except for those poking on some random non upstream driver.
Additionally from a technical perspective having this information is
purely informative at this point given that hostapd would be expected
to be treating the cellular based source of interference as avoidance
hints. It does leave open, for example, drivers with other types of
future sources of advisories to simply piggy on top of this when the
source of interference is coming from the 802.11 devices somehow.

  Luis
