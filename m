Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98408C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 17:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60C6B21019
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 17:32:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="FMbS3cXb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726010AbfAVRcT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 12:32:19 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:38187 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfAVRcR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 12:32:17 -0500
Received: by mail-io1-f66.google.com with SMTP id l14so19750007ioj.5
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 09:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKZYR4XIqRJaJkUwLrM2N4U8AnnykXUGRp6q+kPQgR0=;
        b=FMbS3cXbQaOEIXwLvkqrx+vWU1lHHWbtf/1OcqhcJ6IC8wwzNvR0Tcy5kIdHqHUwaF
         p8fqB4UXHCjbZ7RQQ1NTCzmq/hfKl3IB0ffgEKNmh9lJVCqqokvq3IzqHQ831vi/3/su
         1kQfTNA/alEt0Kbd/UOZuO5LfqLF1S/BNbN/EE4FoG2vH52cUyrw75jo3vIkj5CeFvS4
         EDtZhlW/CU+vkbc+kj45UPufWj0omGdWVOMRYG/jg4sUQDaXDJ3tEc5ABkRiB9199SmH
         U9buCh4a0Trp2jXJApSwkfPT+oAh+0ufrkpqyhxSMw7H6pgrvela8lIysDJiVYJW6gSS
         0ZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKZYR4XIqRJaJkUwLrM2N4U8AnnykXUGRp6q+kPQgR0=;
        b=NvYPJ6W5b4cZvI6jNH7Ra+wG3u5807YgOE3cj/om8ddzDtoW6OLmDviHn5oUUdusre
         pwmyEsrsFQlguTDVlSP2UaW+jPw5oz+ttR+lKozrqLQu+UPHZ0bBUjy7V3FMiTa3hc9W
         e/UZ8jF5befgi4hnuZgdrLLkUOT8uHOVY6Gl+5Uqlf3W38jcevkJSUAK+9hOdeiE0sHn
         De2scuJcP0+Ktyp8ELHrda60D+dQ250vWdwtM5x2XsabZV7zg0G1+m45wnP3Z0eTILg+
         CE4mLvEPsPBV6ZWbIhvElUbpn4OU9SFPtfMOz8yh8vpElNy5ul3c3xi9BEDN5oBN74kI
         q7Lg==
X-Gm-Message-State: AJcUukdJ7VVEuKr0W2xJr0m/QAP2Dk0C9RBS3kLm6c+aCLjh+qfq+xJY
        8pNa7EE+NEQsGgw9Doce6Hf5R6WLm9hDf7thS+iWYA==
X-Google-Smtp-Source: ALg8bN6Ory6AvZCZfDrDGJ48LYVP8UdCZShnefNKd/4OJ6BRao3j7570s6E8HmNdsZ4Y4WxPJBcal0uIwhFXnowGN3o=
X-Received: by 2002:a5d:85c5:: with SMTP id e5mr18110671ios.125.1548178336605;
 Tue, 22 Jan 2019 09:32:16 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
 <20190109113320.GA15658@redhat.com> <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
 <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
In-Reply-To: <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Tue, 22 Jan 2019 18:32:05 +0100
Message-ID: <CANCHnQrb57bUCj_kftD+5_gRZFeruFxaXWR8B_feEcpyF-6rVw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 10 Jan 2019 at 15:29, Jeroen Roovers <jer@airfi.aero> wrote:
>
> Aaaaaaand the results are in.
>
> On Thu, 10 Jan 2019 at 08:49, Jeroen Roovers <jer@airfi.aero> wrote:
> >
> >      Hi Stanislaw,
> >
> > On Wed, 9 Jan 2019 at 12:33, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > > So would be below patch (on top of this set) be a solution for at
> > > least to not kill the kernel. Or we looking for something better
> > > i.e. watchdog ?
> >
> > I'll give it a spin. Thanks!
>
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> kernel: [  500.782266] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x07 failed for offset 0x6888 with error -110
> kernel: [  500.912237] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x6888 with error -110
> kernel: [  501.042235] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x6110 with error -110
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> kernel: [  501.772201] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x07 failed for offset 0x1018 with error -110
> kernel: [  501.902177] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x1018 with error -110
> kernel: [  501.972186] ieee80211 phy0: rt2x00usb_vendor_request: Error
> - Vendor Request 0x06 failed for offset 0x1910 with error -110
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
> to inactivity
> hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
> to inactivity (timer DEAUTH/REMOVE)
>
> rt2x00usb_check_usb_error in your patch is set to
> clearDEVICE_STATE_PRESENT after ten errors, but in this case only 6
> errors were seen. Maybe I should set it to 1 as I have never seen an
> RT5592 recover from this.
>
> The system remained relatively stable until after I tried forcibly
> removing and then loading the rt2800usb module. A simple `ifconfig`
> then triggered a kernel panic. Sadly I couldn't capture it in time but
> I did spot that more phyN (up to phy4) devices had been added.

Yes, even when some rt2x00usb_vendor_request starts to fail but keeps
on trying, the WLAN modules remain unrecoverable except by removing
power, so the 10 retries are usually not reached and the device is
never removed. Could it be that some operations do succeed, perhaps
because the MCU was reset and is now capable of responding to some
"vendor requests" but not others?

Checking for num_proto_errs > 1 would then make as much sense as
num_proto_errs > 10 when running an AP. Maybe it's different for an
STA?


Kind regards,
       jer
