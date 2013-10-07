Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:44384 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3JGU7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 16:59:50 -0400
Received: by mail-ve0-f175.google.com with SMTP id jy13so4021947veb.34
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 13:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UToY0zeuarb7f_aExCuxqmghCcmdRkxMSWR-CgGjRk6Q@mail.gmail.com>
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
	<20131004234514.GA11128@garbanzo.do-not-panic.com>
	<CAFSJ42YRmwZ-mK5yADsf=sfi7b5rEK9hFdH-waoswrubvyZddA@mail.gmail.com>
	<CAB=NE6UToY0zeuarb7f_aExCuxqmghCcmdRkxMSWR-CgGjRk6Q@mail.gmail.com>
Date: Mon, 7 Oct 2013 21:59:49 +0100
Message-ID: <CAFSJ42bj6Q-O0=+3TK1kwgfct6tN6hf+wRJa_nk3WfCTskQitg@mail.gmail.com> (sfid-20131007_225953_969102_53CEB257)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>,
	wcn36xx <wcn36xx@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

I looked at your patch deeper and couple of questions appeared:

1) The first line in the function ath_regd_init will execute
container_of with "struct ath_common". Do not you think we can try to
access wrong memory area?

2) __ath_regd_init will try to access EEPROM or at least call
functions with eeprom related. It's a bit misleading because
wcn36xx is not using eeprom. If possible could you please explain what
is the connection between ath regd implementation and EEPROM?

On Mon, Oct 7, 2013 at 6:50 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sun, Oct 6, 2013 at 12:30 PM, Eugene Krasnikov <k.eugene.e@gmail.com> wrote:
>>> +static void wcn_reg_notifier(struct wiphy *wiphy,
>>> +                            struct regulatory_request *request)
>>> +{
>>
>> Function should be called wcn36xx_reg_notifier not wcn_reg_notifier.
>> Could you please change that?
>
> Feel free to make that change on your end :D
>
>   Luis



-- 
Best regards,
Eugene
