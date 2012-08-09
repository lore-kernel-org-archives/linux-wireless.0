Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37638 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2HIV2j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 17:28:39 -0400
Message-ID: <50242B80.4060509@openwrt.org> (sfid-20120809_232842_695507_CBB60F33)
Date: Thu, 09 Aug 2012 23:28:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Pavel Roskin <proski@gnu.org>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com> <20120809173435.GQ3745@lenteja.do-not-panic.com> <CAA2SeNKbBCxPbJmXMyo4-nK2SXL-WcOFQaKDrEM-cxbVrzt7Ew@mail.gmail.com> <CAB=NE6V6T0RMSiMZCsUdr85vWMgs4VfJ6HTYHwf+kDQUwQ-mhg@mail.gmail.com> <20120809170757.748b68bf@mj> <CAB=NE6UracUuvGhQcnkfDsi1peNMgvagS0jyYgSvamim4tiLWA@mail.gmail.com>
In-Reply-To: <CAB=NE6UracUuvGhQcnkfDsi1peNMgvagS0jyYgSvamim4tiLWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-08-09 11:21 PM, Luis R. Rodriguez wrote:
> On Thu, Aug 9, 2012 at 2:07 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Thu, 9 Aug 2012 11:10:38 -0700
>> "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com> wrote:
>>
>>> And this would lead to .. what? How did you realize this? Can you
>>> please resend and add all this information to the commit log message?
>>
>> Also please use a better subject.  For example:
>>
>> ath9k: fix decrypt_error initialization in ath_rx_tasklet()
>>
>> "issue" is too vague.
> 
> Also -- what I was getting at is to evaluate whether or not this is an
> important fix or critical. To determine if its critical it helps to
> understand exactly what negative behavior was observed. If its
> critical it can go to stable but I have a feeling this is not
> critical. If its not critical and only important although it won't go
> to stable I'll still cherry pick it for the stable compat-wireless
> releases.
I think it's critical enough for stable. I think when using CCMP
encryption, high CPU load can get the connection stuck (because of CCMP
PN corruption when the issue occurs).

- Felix

