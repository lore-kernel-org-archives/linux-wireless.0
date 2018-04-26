Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754039AbeDZJ0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 05:26:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Eyal Reizer <eyalreizer@gmail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "robh\@kernel.org" <robh@kernel.org>,
        "sre\@kernel.org" <sre@kernel.org>,
        "tony\@atomide.com" <tony@atomide.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH v2] wlcore: sdio: allow pm to handle sdio power
References: <1524721631-5983-1-git-send-email-eyalr@ti.com>
        <87po2m7573.fsf@kamboji.qca.qualcomm.com>
        <4750eeeedcde47d39cd207a8c21ef802@ti.com>
Date: Thu, 26 Apr 2018 12:26:06 +0300
In-Reply-To: <4750eeeedcde47d39cd207a8c21ef802@ti.com> (Eyal Reizer's message
        of "Thu, 26 Apr 2018 08:37:35 +0000")
Message-ID: <87lgda71zl.fsf@kamboji.qca.qualcomm.com> (sfid-20180426_112649_809869_9DA41390)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

>> 
>> > pm_runtime handles sdio power on and power off transitions.
>> > An old workaround for trying to control the power explicitly from the
>> > driver was in fact causing failures on suspend/resume as the mmc layer
>> > already power the module on resume.
>> >
>> > In case of resume pm_runtime_get sync returns a positive device's usage
>> > count causing the driver to try an re-initialize an already initialized
>> > device. This was causing sdio bus failure on resume.
>> >
>> > Remove this manual power on/off sequence as it is in-fact not needed.
>> >
>> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
>> > Acked-by: Tony Lindgren <tony@atomide.com>
>> 
>> No changelog.
>> 
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingp
>> atches#changelog_missing
>> 
>> No need to resubmit because of this, I guess you just fixed the title
>> and added Tony's Acked-by?
>
> Yes, this is correct. No change in the actual patch hence there was no change 
> Log.

_Always_ include a change log, even if you didn't actually change
anything. Otherwise the maintainer has no clue what has changed and why
a new version was submitted.

-- 
Kalle Valo
