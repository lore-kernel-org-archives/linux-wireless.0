Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61758 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2GSLLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 07:11:33 -0400
Message-ID: <5007EB60.60705@qca.qualcomm.com> (sfid-20120719_131137_643229_EEC4ABF1)
Date: Thu, 19 Jul 2012 14:11:28 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath6kl: add support for changing contry code
References: <20120712093944.9976.84585.stgit@localhost6.localdomain6> <20120712093952.9976.84033.stgit@localhost6.localdomain6> <CAB=NE6WjW-f=giqEEycNcZqjjB7SuioiMyEbrLcGaz8oD1CPNA@mail.gmail.com>
In-Reply-To: <CAB=NE6WjW-f=giqEEycNcZqjjB7SuioiMyEbrLcGaz8oD1CPNA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2012 10:40 PM, Luis R. Rodriguez wrote:
> On Thu, Jul 12, 2012 at 2:39 AM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> +config ATH6KL_REGDOMAIN
>> +       bool "Atheros ath6kl regdomain support"
>> +       depends on ATH6KL
>> +       depends on CFG80211_CERTIFICATION_ONUS
>> +       ---help---
>> +         Enabling this makes it possible to change the regdomain in
>> +         the firmware. This can be only enabled if regulatory requirements
>> +         are taken into account.
> 
> You will need to add wiphy->features |=
> NL80211_FEATURE_CELL_BASE_REG_HINTS in order to enable the base
> station hints to propagate to the driver and even to the core,
> otherwise this is ignored. This was addressed starting at v4 of my
> onus patches. Given this, I think it makes sense to rename the option
> to enable / disable base station hints and to update the language to
> clearly reflect that is the only type of hint that would be used to
> update the firmware regulatory domain.

I was planning to do this in two phases, first do a simple
implementation (these two patches) and then add support for the cellular
BTS hints.

Kalle
