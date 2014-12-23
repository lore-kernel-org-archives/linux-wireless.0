Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20290 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbaLWKRf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 05:17:35 -0500
From: Avinash Patil <patila@marvell.com>
To: "janusz.dziedzic@tieto.com" <janusz.dziedzic@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 23 Dec 2014 02:13:32 -0800
Subject: RE: [PATCH] cfg80211: do not check for carrier during
 start_radar_detect
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC66736E7A37@SC-VEXCH2.marvell.com> (sfid-20141223_111739_781726_3D3051F6)
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
 <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com>,<5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951B160B81A7@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Janusz,

Any further update on this?

Thanks,
Avinash

-----Original Message-----
From: Janusz Dziedzic [mailto:janusz.dziedzic@tieto.com]
Sent: 01 December 2014 12:44
To: Avinash Patil
Cc: Johannes Berg; Simon Wunderlich; Amitkumar Karwar; linux-wireless@vger.kernel.org; Cathy Luo; John W. Linville
Subject: Re: [PATCH] cfg80211: do not check for carrier during start_radar_detect

On 28 November 2014 at 17:35, Avinash Patil <patila@marvell.com> wrote:
> Yes; beats me as well.
>
> That's why I added original authors - Simon and Janusz.
>
> -Avinash
>
> On Nov 28, 2014 8:41 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>
>> On Fri, 2014-11-28 at 16:58 +0530, Avinash Patil wrote:
>> > Radar detection happens before starting AP; so netdev carrier may
>> > be dormant at this time. Remove this check from cfg80211_start_radar_detection.
>>
>> Looks fine to me, but I wonder how it ever worked?
>>
radar detection starts before we setup AP, so woks fine

Seems this patch unlock off-channel CAC (we are connected/ap started and detect radar on other channel), but seem mac80211 don't support this correctly now.
So, at least we should move if (netif_carrier_ok(dev)) check to
mac80211 otherwise we might change channel of the running interface (via vif_use_channel).

BR
Janusz

>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-wireless" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
