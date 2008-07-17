Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.248]:44145 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbYGQQFE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 12:05:04 -0400
Received: by an-out-0708.google.com with SMTP id d40so170362and.103
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 09:05:03 -0700 (PDT)
Message-ID: <43e72e890807170905h5a261879u9d87963c621b57bf@mail.gmail.com> (sfid-20080717_180514_910751_C1D60348)
Date: Thu, 17 Jul 2008 09:05:03 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Yingying Zhao" <yingying.zhao@linux.intel.com>
Subject: Re: [PATCH]compat-2.6: fix compiling configurations for iwlwifi
Cc: "Tomas Winkler" <tomasw@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890807170621r25616966w1d542e4e235f9a3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080717081554.GA1279@amber-desktop.bj.intel.com>
	 <1ba2fa240807170129w251a95f3i8eab918d50a77f97@mail.gmail.com>
	 <43e72e890807170248v7a873c15oc3aea315a59e9f19@mail.gmail.com>
	 <20080717100449.GB1279@amber-desktop.bj.intel.com>
	 <43e72e890807170307g3310ffcbv51f89c93dfbc64a0@mail.gmail.com>
	 <43e72e890807170621r25616966w1d542e4e235f9a3f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 6:21 AM, Luis R. Rodriguez
<mcgrof@winlab.rutgers.edu> wrote:
> On Thu, Jul 17, 2008 at 3:07 AM, Luis R. Rodriguez
> <mcgrof@winlab.rutgers.edu> wrote:
>> On Thu, Jul 17, 2008 at 3:04 AM, Yingying Zhao
>> <yingying.zhao@linux.intel.com> wrote:
>>
>>>> Also, was this tested with 2.6.22?
>>>>
>>>>   Luis
>>> No. I just tested on 2.6.24.
>>> I'll wait for iwlwifi Kconfig is finalized by Tomas and retest this on
>>> 2.6.22.
>>
>> OK cool -- just a heads up then, I hadn't enabled LEDs or RFKILL
>> options for drivers as the framework needs backporting. Once
>> backported I expect it will compile well for older kernels.
>
> compat-wireless wasn't actually compiling for 2.6.22 anymore. I just
> fixed that. It loads mac80211. Either I did a mistake or we get an
> oops now when loading a driver on 2.6.22.

Yeah ok I can confirm there is a bug there on 2.6.22. We hit:

BUG_ON(!local || local->mdev == dev);

on ieee80211_i.h in IEEE80211_DEV_TO_SUB_IF()

Don't have time to debug this right now though.

  Luis
