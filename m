Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56093 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab0LGIKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:10:43 -0500
Received: by iwn9 with SMTP id 9so1268530iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:10:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19709.59888.682471.11803@gargle.gargle.HOWL>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL> <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL> <AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
 <19709.46740.86437.390791@gargle.gargle.HOWL> <AANLkTinJLRMSSvLHgPP1Dw5BXsC3utAudJ=oSAsUUD8T@mail.gmail.com>
 <19709.59888.682471.11803@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Dec 2010 00:10:21 -0800
Message-ID: <AANLkTimq7F1UmRV=thdyRy1TozDGc4RbfniDYvBr2KUK@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: Sujith <m.sujith@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 12:01 AM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> Oh right, I see. Should we not wait to turn the radio until we get a
>> non-idle config() call?
>
> Ideally, yes. But that would require extensive changes in ath9k_hw.
> Initialization has to be pruned, powering up the chip has to be deferred ...
>
> Which is why I decided to settle for a simple band-aid for now. :)

Hm, well I was thinking more along the lines of what
ath9k_htc_config() already does with IEEE80211_CONF_CHANGE_IDLE when
enabling the radio. That seems right.

  Luis
