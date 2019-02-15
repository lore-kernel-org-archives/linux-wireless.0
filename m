Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FDBC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 08:37:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A82442190B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 08:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O2ga5qIK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388926AbfBOIhU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 03:37:20 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:35941 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbfBOIhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 03:37:20 -0500
Received: by mail-yb1-f194.google.com with SMTP id o129so1734862yba.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2019 00:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WB2LdFqFgUjQiIV+try3zOjA6Q+F8Q6N0JiH8XtFT+Y=;
        b=O2ga5qIKoUCQpKhvm49iOxlyUUuzuGPfrly76ECJOD2/2VEe8l6cfs3yJIh9KoxXua
         Pw9FmDVN7LkxGnozfdzhf87dFM5kDALz20FEq1JEme5DtyPm+bdeDjus+mg+VULldRgc
         3eXXV2MmXTl1us52dcGqELcsUx88dlP6yvXL24S8TuUlOZmJKwtqztjc4p+UZ/e8rM67
         NwppbzeRyrz6fNPogdSptVBl/Ze80w398DT1FoTomhziBbGoOlcDJvwX2CnfAeXSTClS
         I5LnSBG3VXpIQq3kaB8YWMCfJep/jBPJZULjWqr/wuHB8x9QvhAAsGeUgXPSDnCD/9GS
         owWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WB2LdFqFgUjQiIV+try3zOjA6Q+F8Q6N0JiH8XtFT+Y=;
        b=Qld0FmLjhbq37uD4kVt2TBLHAeE+SW7Q3EnaiMQvesr01QoxuFp+ksCiUBSfD3fVBo
         HIrDlDmOgTGX7f4CZ+zpAsivbYXEYherPu+2PCmioVsngdiYLeckh7U3Y0Pxy8DHn2ad
         NTOX4MydWsPE5ceMGn7OB2zLkkX+0Z7xODvsuusddQc9ZpGQNIaqcOnjOEaHpzkRaMN+
         RIQrcarfTIRHfl30BgLUgF1JXoLapP86v1rFRqxbUVPyGR0tmJrfLEE6YH2tzid+ZYhq
         sVY6o8PNWh3SfSC0YYI4znvEXiD53595fyOOWRbqQpWFzuRg0nFLh+BRWBUNNhwQ/dTK
         NurQ==
X-Gm-Message-State: AHQUAuZOgD9d72146RlHasMBvFIL/3geycbj+Lk3MYnE2JSVXk5ERg2J
        L06pnKYzL9wkotPltEknzN54nLC7RnoF5vLVvKc=
X-Google-Smtp-Source: AHgI3IZbnQDaaLS9GtmqKc+3FKljTX9TS0N06sdL5r+UUbk1nY65KX2bYLx5fh9DE/hGEDB6Vmc9+IB98o6vOfkvfbU=
X-Received: by 2002:a25:cb0b:: with SMTP id b11mr6834683ybg.375.1550219839517;
 Fri, 15 Feb 2019 00:37:19 -0800 (PST)
MIME-Version: 1.0
References: <20190214125758.11943-1-zajec5@gmail.com> <20190215064345.11946-1-zajec5@gmail.com>
In-Reply-To: <20190215064345.11946-1-zajec5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Fri, 15 Feb 2019 09:37:08 +0100
Message-ID: <CACna6rwiz=Q=ZYj-q69Ak+VAaJhJmtPhnVB_KQvZc0+NZJoCKQ@mail.gmail.com>
Subject: Re: [PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 15 Feb 2019 at 07:43, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This recently added macro provides more meaningful error messages thanks
> to identifying a specific wiphy. It's especially important on systems
> with few cards supported by the same (brcmfmac) driver.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Arend, let me ask one more question before getting this patch pushed.
It's quite late (I spent quite some time on this), but maybe still
better than fixing it later.

It seems the most common struct that is:
1) Often passed as argument
2) Often having it's own variable in functions
3) Used when calling functions from different file
is struct brcmf_pub.

Now I started wondering if we really want to have bphy_err() accept
wiphy. Maybe it would match brcmfmac's design better to have
bphy_err(struct brcmf_pub, fmt, ...)?
