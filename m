Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754982AbeFRH3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 03:29:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: Omer Efrat <omer.efrat@tandemg.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v3 5/5] staging: use BIT_ULL for NL80211_STA_INFO_* attribute types
References: <1529230056-18004-1-git-send-email-omer.efrat@tandemg.com>
        <20180617102424.GA5705@kroah.com>
Date: Mon, 18 Jun 2018 10:29:43 +0300
In-Reply-To: <20180617102424.GA5705@kroah.com> (Greg KH's message of "Sun, 17
        Jun 2018 12:24:24 +0200")
Message-ID: <87wouwa6xk.fsf@purkki.adurom.net> (sfid-20180618_092951_457906_BD69737C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> On Sun, Jun 17, 2018 at 01:07:36PM +0300, Omer Efrat wrote:
>> The BIT macro uses unsigned long which some architectures handle as 32 bit
>> and therefore might cause macro's shift to overflow when used on a value
>> equals or larger than 32 (NL80211_STA_INFO_RX_DURATION and afterwards).
>> 
>> Since 'filled' member in station_info changed to u64, BIT_ULL macro
>> should be used with all NL80211_STA_INFO_* attribute types instead of BIT
>> to prevent future possible bugs when one will use BIT macro for higher
>> attributes by mistake.
>> 
>> This commit cleans up all usages of BIT macro with the above field
>> in cfg80211 by changing it to BIT_ULL instead.
>> 
>> Signed-off-by: Omer Efrat <omer.efrat@tandemg.com>
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Via which tree is this supposed to go?

-- 
Kalle Valo
