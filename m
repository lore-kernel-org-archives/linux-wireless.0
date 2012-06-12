Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2FLMDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 08:03:32 -0400
Received: by pbbrp8 with SMTP id rp8so710393pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2012 05:03:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339502090.4531.4.camel@jlt3.sipsolutions.net>
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	<1339463659-10736-2-git-send-email-bzhao@marvell.com>
	<1339502090.4531.4.camel@jlt3.sipsolutions.net>
Date: Tue, 12 Jun 2012 17:33:32 +0530
Message-ID: <CAJwzM1kPXkHcyq3Qu=1xXJ-UGJD+pcBbU6HgBem2Rbm2cj7g8Q@mail.gmail.com> (sfid-20120612_140338_198494_D34650DD)
Subject: Re: [PATCH 2/4] mwifiex: parse WPA IE and support WPA/WPA2 mixed mode
 for uAP
From: Avinash Patil <avinashapatil@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Of course we do use crypto_settings to set WPA/WPA2 mixed mode. IE
parsing is only used for the purpose of setting WPA IE in
beacons/probe responses/assoc responses. Please see changes in
uap_cmd.c where we are using crypto settings for setting mixed mode.

Best Regards,
Avinash

On Tue, Jun 12, 2012 at 5:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-11 at 18:14 -0700, Bing Zhao wrote:
>> From: Avinash Patil <patila@marvell.com>
>>
>> Add support for parsing WPA IE from beacon parameter of
>> cfg80211_ap_settings and set it to FW.
>>
>> WPA/WPA2 mixed mode is supported with this patch.
>
> There's the crypto settings thing -- does that not supported mixed mode?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
