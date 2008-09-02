Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:11318 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYIBXOO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 19:14:14 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2217525fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 16:14:13 -0700 (PDT)
Message-ID: <1ba2fa240809021614t4dfb1422sa82efeae8869ff6b@mail.gmail.com> (sfid-20080903_011418_840353_82DB2635)
Date: Wed, 3 Sep 2008 02:14:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: [PATCH] p54usb: support LM87 firmwares
Cc: linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
In-Reply-To: <200809022139.12969.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200809022139.12969.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 2, 2008 at 10:39 PM, Christian Lamparter <chunkeey@web.de> wrote:
> This patch adds the necessary changes to support LM87 firmwares.
>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> John,
>
> this one should go into wireless-next.
> ---
> diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
> --- a/drivers/net/wireless/p54/p54common.c      2008-09-01 22:25:35.000000000 +0200
> +++ b/drivers/net/wireless/p54/p54common.c      2008-09-02 21:29:47.000000000 +0200
> @@ -93,7 +93,10 @@ int p54_parse_firmware(struct ieee80211_
>                u32 code = le32_to_cpu(bootrec->code);
>                switch (code) {
>                case BR_CODE_COMPONENT_ID:
> -                       switch (be32_to_cpu(*(__be32 *)bootrec->data)) {
> +                       priv->fw_interface =
> +                               be32_to_cpu(*(__be32 *)bootrec->data);
what about be32_to_cpup?
Tomas
