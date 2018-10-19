Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CFEECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:23:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68DC21470
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:23:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C68DC21470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbeJSR2u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:28:50 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:35424 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbeJSR2u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:28:50 -0400
Received: by mail-io1-f68.google.com with SMTP id 79-v6so2835510iou.2
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 02:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7rwOk6Da9UGpFku0/ObN3UZU9WR004a0VJo3CMMptaY=;
        b=EeBBuw0HGYQapIh6Ap/gH+07Rr3yl+I1Bqqg9yTedl87D6I4WUsho72AqnaueVo8ew
         Spn+zl3XZCyGWluToKMZzdwhrhMddyGdP5tZEGb7XD90Iie70JKqE8hnHDVTD67b5mA6
         yqeXN8sSDdKYSMRaBLzAsIONZDciPMZoZPLTBqme6yJucqUWufGjE4qnZj81GCrf462e
         KT20q1QPGLywBjxe/0n29/4IlKc8Wk0qXkWpyshdRJk5eMJp8mUYxHhXWqX3Fg8ldvSh
         9DzjZoWwz9ucUgLnj3K6q+MHJms4FHq4Gt0tiGkaSSdB3/rYVLc0D6x9ERstFyOk7qwi
         CWTw==
X-Gm-Message-State: AGRZ1gI1kZviyRkr40SfgDH7uqv3/bBAeOHJZq9L5wfRrLIGqBJ+ENfw
        7Ztlb0O7rFRYX0uI/UMZJvyPDsFGmj+1sSPbI7Gyaw==
X-Google-Smtp-Source: AJdET5cUw5uVdryxBqXndlyZKDMjwk7ancQaFC5Q8WZCYemu4dh6X9Pk0WUYrKUqLhoeHBHqDeB7yaRHOUwQ0UC/oLs=
X-Received: by 2002:a5e:9419:: with SMTP id q25-v6mr2137734ioj.228.1539941014740;
 Fri, 19 Oct 2018 02:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539938482.git.lorenzo.bianconi@redhat.com>
 <bd30d8b3853395565d5e81acb98ae3d43ddc1f6e.1539938482.git.lorenzo.bianconi@redhat.com>
 <4d7f5be8-9413-b93d-f54f-5d6a10e293d6@nbd.name>
In-Reply-To: <4d7f5be8-9413-b93d-f54f-5d6a10e293d6@nbd.name>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 19 Oct 2018 11:23:23 +0200
Message-ID: <CAJ0CqmU85e6g8iwbinjszbgAgWMN1ipko6X2=kPcA_6j4ar0Ew@mail.gmail.com>
Subject: Re: [PATCH] mt76x0: align mt76x0u and mt76x0e fw version
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On 2018-10-19 10:58, Lorenzo Bianconi wrote:
> > Unify firmware version used on mt76x0e and mt76x0u drivers.
> > Fallback to mt7610u fw if mt7610e one is not available
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> > this patch is based on top of:
> > https://patchwork.kernel.org/patch/10648399/
> > ---
> >  .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 ++
> >  .../net/wireless/mediatek/mt76/mt76x0/usb.c   |  2 ++
> >  .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 23 +++++++++++++++----
> >  3 files changed, 23 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> > index a9f14d5149d1..b57c2a11146f 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
> > @@ -22,7 +22,6 @@
> >
> >  #define MCU_FW_URB_MAX_PAYLOAD               0x38f8
> >  #define MCU_FW_URB_SIZE                      (MCU_FW_URB_MAX_PAYLOAD + 12)
> > -#define MT7610U_FIRMWARE             "mediatek/mt7610u.bin"
> >
> >  static int
> >  mt76x0u_upload_firmware(struct mt76x02_dev *dev,
> > @@ -75,6 +74,24 @@ mt76x0u_upload_firmware(struct mt76x02_dev *dev,
> >       return err;
> >  }
> >
> > +static int mt76x0_get_firmware(struct mt76x02_dev *dev,
> > +                            const struct firmware **fw)
> > +{
> > +     int err;
> > +
> > +     /* try to load mt7610e fw if available
> > +      * otherwise fall back to mt7610u one
> > +      */
> > +     err = request_firmware(fw, MT7610E_FIRMWARE, dev->mt76.dev);
> > +     if (err) {
> > +             dev_info(dev->mt76.dev, "%s not found, switching to %s",
> > +                      MT7610E_FIRMWARE, MT7610U_FIRMWARE);
> > +             return request_firmware(fw, MT7610U_FIRMWARE,
> > +                                     dev->mt76.dev);
> > +     }
> > +     return 0;
> > +}
> You should use firmware_request_nowarn for the first request.
>
> - Felix

Ack, will do in v2.

Regards,
Lorenzo
