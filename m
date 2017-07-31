Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44560 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750979AbdGaJvU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Jul 2017 05:51:20 -0400
From: Xinming Hu <huxm@marvell.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>
CC: Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: Re: [PATCH] mwifiex: correct IE parse during association
Date: Mon, 31 Jul 2017 09:51:13 +0000
Message-ID: <1501494673195.15931@marvell.com> (sfid-20170731_115149_481545_2984CA8E)
References: <1500263187-1167-1-git-send-email-huxinming820@gmail.com>,<87mv7owrqi.fsf@purkki.adurom.net>
In-Reply-To: <87mv7owrqi.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Thanks for the review, I have refactor code to avoid ugly indent in v2.

Regards,
Simon
________________________________________
From: Kalle Valo <kvalo@codeaurora.org>
Sent: Friday, July 28, 2017 22:39
To: Xinming Hu
Cc: Linux Wireless; Brian Norris; Dmitry Torokhov; rajatja@google.com; Zhiyuan Yang; Tim Song; Cathy Luo; Xinming Hu
Subject: Re: [PATCH] mwifiex: correct IE parse during association

Xinming Hu <huxinming820@gmail.com> writes:

> From: Xinming Hu <huxm@marvell.com>
>
> It is observed that some IEs get missed during association.
> This patch correct the old IE parse code. sme->ie will be
> store as wpa ie, wps ie, wapi ie and gen ie accordingly.
>
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>

[...]

> +             } else {
> +                     if (pvendor_ie->element_id ==
> +                         WLAN_EID_VENDOR_SPECIFIC) {
> +                             /* Test to see if it is a WPA IE,
> +                              * if not, then it is a gen IE
> +                              */
> +                             if (!memcmp(pvendor_ie->oui, wpa_oui,
> +                                         sizeof(wpa_oui))) {
> +                                     /* IE is a WPA/WPA2 IE so call
> +                                      * set_wpa function
> +                                      */
> +                                     mwifiex_set_wpa_ie(priv,
> +                                                        (u8 *)pvendor_ie,
> +                                                        cur_ie_len);

The indentation is getting ugly here. A helper function or similar would
really make this more readable.


[...]

> +NEXT_IE:

Goto labels in lower case, please.

--
Kalle Valo
