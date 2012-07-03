Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61527 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2GCEQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 00:16:20 -0400
Received: by lbbgm6 with SMTP id gm6so8659118lbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jul 2012 21:16:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341241685.19642.15.camel@jlt3.sipsolutions.net>
References: <1341210756-11054-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1341233662.19642.6.camel@jlt3.sipsolutions.net> <1341233919.19642.7.camel@jlt3.sipsolutions.net>
 <5202151.WBzXQarS2v@lx-vladimir> <1341241685.19642.15.camel@jlt3.sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 3 Jul 2012 14:15:59 +1000
Message-ID: <CAGRGNgVMLtOwsHxNsRkNO7tFUv7aQfSsHtw7JeXmLOF4X-oMHg@mail.gmail.com> (sfid-20120703_061625_448299_894E1BCA)
Subject: Re: [PATCH 60g v2 0/5] Infrastructure for 60g (802.11ad)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jul 3, 2012 at 1:08 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-02 at 18:01 +0300, Vladimir Kondratiev wrote:
>
>> So, now I'll focus on the last patch - bitrate calculation.
>>
>> My plan is:
>>
>> - add new element like NL80211_RATE_INFO_BITRATE_HT with u32 data
>> - change nl80211_put_sta_rate() to fill both
>>   NL80211_RATE_INFO_BITRATE (with u16 value)
>>   and NL80211_RATE_INFO_BITRATE_HT (with u32 value)
>> - when bitrate not fit into u16, put 0 for u16 value and fill only u32
>
> I think you should leave out the BITRATE value completely, not fill it
> with 0.

Why not make it 65535?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
