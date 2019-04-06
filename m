Return-Path: <SRS0=AXTt=SI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B5A3C10F06
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 10:24:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 594BF218C3
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Apr 2019 10:24:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cogentembedded-com.20150623.gappssmtp.com header.i=@cogentembedded-com.20150623.gappssmtp.com header.b="bh7mqx4D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfDFKYg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Apr 2019 06:24:36 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45903 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfDFKYf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Apr 2019 06:24:35 -0400
Received: by mail-lf1-f66.google.com with SMTP id t15so2273908lfl.12
        for <linux-wireless@vger.kernel.org>; Sat, 06 Apr 2019 03:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0B2T93URAhgkJumCufvQgsIA73utiusJRcpc3egwJ3w=;
        b=bh7mqx4Dk6f8JGmWpEyE1WEoykl+7YYcpjdshasbN5gUWF1DQkQ+saSf5pYKspd0ks
         9lzneFQTxPofVNeIlAyPVH0i5m5wMYgkVes8wNDoFp7BoFm9U4f7HPH5etAGHhXCapgi
         nQKVpD6sPyRH0mmUqHoEhwtN0sY2olKexpbyi8n2YKDOMzAf6Y9WxWz/nMy0iIHtP+x2
         rEGTLwsLvUR3a8nNdAKClh8PJgZrUd1GpKk255faE0gAr03ez+oFKn1sPURrjP6jad5K
         JqqMjFeVrSJxnPBjr06IwXzL5Cw5E050prXoXpMeAvcc1NkszCowLyg5Snut4t954yFZ
         /dAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0B2T93URAhgkJumCufvQgsIA73utiusJRcpc3egwJ3w=;
        b=NP94TazVlath1Ba6633RpEzwvGxO+6VTegli40rbbT95ICqjy2j/DoyWqhMEAwVgfu
         rnO/Fav2Ql5zXaEq/i0z23J8Yol4bcoNTgK4F3ebzK6YUcFphtzW+8IBerLzTbpW2ycu
         ir6qpCQDmHC+a1C1YKszRfvcMJ8vYl535pZXTvKBcnqTed6pSMxQQFIlnyzc9OZworOP
         3xwO56ojrtaHdfGGAhJIzZmPy2c4dScr6pmDu0rcSJxKRouJaux44IN9vB8zRrxowrWV
         eXwWFSkztrcFwzqYknYb9xL4HDqIdbcpDd7Y8TA4hohk2L4XyWJtuCVkU5CAyucIAYjb
         PRYA==
X-Gm-Message-State: APjAAAW781YgwbCy/dHu4sP9ZurD20eTnlkSIhKeDWbeyRpsSYTf7w5i
        M3vqaQsHZdnZi8Jcr8SELX/Hfw==
X-Google-Smtp-Source: APXvYqxPg2maS6hIFXQrqgAZHG5hl6JCOOnw2lWbLYw42o3CcmK36QiKAT3Au6HlUb4wVR3vdqDlcQ==
X-Received: by 2002:ac2:5082:: with SMTP id f2mr9991211lfm.71.1554546273571;
        Sat, 06 Apr 2019 03:24:33 -0700 (PDT)
Received: from [10.102.31.166] ([81.16.143.135])
        by smtp.gmail.com with ESMTPSA id q5sm4914656lfm.16.2019.04.06.03.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Apr 2019 03:24:32 -0700 (PDT)
Subject: Re: [PATCH 06/12] net: stmmac: sun8i: force select external PHY when
 no internal one
To:     megous@megous.com, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Icenowy Zheng <icenowy@aosc.io>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Mark Rutland <mark.rutland@arm.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Naveen Gupta <naveen.gupta@cypress.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, linux-gpio@vger.kernel.org
References: <20190405234514.6183-1-megous@megous.com>
 <20190405234514.6183-7-megous@megous.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <36e1e65b-5a8f-f8ae-6c33-07c30beada17@cogentembedded.com>
Date:   Sat, 6 Apr 2019 13:24:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190405234514.6183-7-megous@megous.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello!

On 06.04.2019 2:45, megous@megous.com wrote:

> From: Icenowy Zheng <icenowy@aosc.io>
> 
> The PHY selection bit also exists on SoCs without an internal PHY; if
> it's set to 1 (internal PHY) then the MAC will not make use of any PHY.
> 
> This problem appears when adapting for H6, which has no real internal
> PHY (the "internal PHY" on H6 is not on-die, but on a co-packaged AC200
> chip, via RMII interface at GPIO bank A), but the PHY selection bit is
> set.
> 
> Force the PHY selection bit to 0 when no external PHY to select this
> problem.

    "Select this problem" sound weird...

> Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> ---
>   drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> index e3e3dc44b33b..bd340e77b2ea 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -908,6 +908,11 @@ static int sun8i_dwmac_set_syscon(struct stmmac_priv *priv)
>   		 * address. No need to mask it again.
>   		 */
>   		reg |= 1 << H3_EPHY_ADDR_SHIFT;
> +	} else {
> +		/* For SoCs without internal PHY the PHY selection bit should be
> +		 * set to 0 (external PHY).
> +		 */
> +		reg &= ~(H3_EPHY_SELECT);
    No () should be needed here, add () around the macro body if still needed.

[...]

MBR, Sergei
