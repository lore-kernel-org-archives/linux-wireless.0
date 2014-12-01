Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36325 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaLAHNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 02:13:36 -0500
Received: by mail-ig0-f181.google.com with SMTP id l13so8929510iga.14
        for <linux-wireless@vger.kernel.org>; Sun, 30 Nov 2014 23:13:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
References: <CBACCFA0AEB13A41977475BCF3E896FC66736E7972@SC-VEXCH2.marvell.com>
Date: Mon, 1 Dec 2014 08:13:35 +0100
Message-ID: <CALhHN=qA7icuY_MNvBebDsOMOkh6hEsWNkrZoGDGsQg+-f6Xog@mail.gmail.com> (sfid-20141201_081339_655815_23846C70)
Subject: Re: [PATCH] cfg80211: do not check for carrier during start_radar_detect
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Avinash Patil <patila@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
>> > Radar detection happens before starting AP; so netdev carrier may be dormant
>> > at this time. Remove this check from cfg80211_start_radar_detection.
>>
>> Looks fine to me, but I wonder how it ever worked?
>>
radar detection starts before we setup AP, so woks fine

Seems this patch unlock off-channel CAC (we are connected/ap started
and detect radar on other channel), but seem mac80211 don't support
this correctly now.
So, at least we should move if (netif_carrier_ok(dev)) check to
mac80211 otherwise we might change channel of the running interface
(via vif_use_channel).

BR
Janusz

>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
