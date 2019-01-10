Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881BFC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 14:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44828214C6
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 14:29:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airfi-aero.20150623.gappssmtp.com header.i=@airfi-aero.20150623.gappssmtp.com header.b="bEnmA+Ct"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfAJO34 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 09:29:56 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:38419 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728843AbfAJO34 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 09:29:56 -0500
Received: by mail-it1-f195.google.com with SMTP id h65so16465665ith.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 06:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airfi-aero.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iKLL5qRT36e5ew/0P8ooUYo4Nvcv72F8pRAT3WLhdR4=;
        b=bEnmA+CtYi3LePNk/cctmO7z03jf5uxNRP/MV6CQ21GAjaZtuVZ7AaDLpCW/2BO+I2
         Gn2F5OTU5jFskgsASFUyRFh02E4i40ieLtggHNYiohyX8fKryIC9pLfBAWlsvcgrYzyc
         OVjf0iN20/WnFBYe/4I0FWGw2xmQqIFTMPoQXP7GTHEr5eb5mO8KLtVPN1+k0alIWmt/
         gCLcYd6DbqpTMGqgEDre0bpzSUohOyatIaT5IbGzCG6Wi6wujnvFWPn0RZUj/Cl83fTx
         DrE9nlP5qN66+N083O0eMbk+G7qaDzaCLFkgSyJxP2ZHl7HhU/WOhQ1lmV9zqwCtpqAM
         bx+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iKLL5qRT36e5ew/0P8ooUYo4Nvcv72F8pRAT3WLhdR4=;
        b=lcod8OAljGJfhxmLufDq7Xwqy0gMOrUcq0FOqa7ePXy8R8OjHUSxJVU6xtn/3u3IHS
         UWERnXFVimal4sLBJ3Mc6yqxLamudJ3+IUasbT9sY0Wq4qO9gUXQa6EwTdOtrFTPW3j2
         2rklW5Api/qbD844p42FljjInxF/zWsqYxvUIKjJij0pCf53HvM6/y/lE96jhdzPI5/d
         ic9YXgGCh/P7f8xFAaq1mwLI+X/zktmyKpWgfSs7+sT09nKFK3A+RiQ6NlsEy6spMnyV
         1W1sjxVQRuuH0nCIlce2ayuaJVSyAWPC8C1CU2UcLbj6PlncfOLrmfNvQxXDDOh5PPOx
         VZyQ==
X-Gm-Message-State: AJcUukeWI4YJlyrxS9Wmc9Nrbq63fEtrWRDNvgs42BqUxASSCT3IqUIQ
        GaWKpixyM8oGiz076BT95SMpmF2dEemOkMs6S8hfxQ==
X-Google-Smtp-Source: ALg8bN5bC3W25nLloMkgAbYmB23/wggiJdrRTxdf7rtp7R12SJbg69iY6JTcqA7PC3fmM3unwQ+9sIwv6F5J600VFEo=
X-Received: by 2002:a02:a906:: with SMTP id n6mr6842631jam.123.1547130594943;
 Thu, 10 Jan 2019 06:29:54 -0800 (PST)
MIME-Version: 1.0
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-2-git-send-email-sgruszka@redhat.com> <CANCHnQoU-PPTotVD-MmCKCjtoVZEx7Nj4+5YGyfYBEKb2+VNdQ@mail.gmail.com>
 <20190107150912.GA9516@redhat.com> <CANCHnQrkB7U2KHd7v6psFaD3cbR+cWj0PaBhRZ8Nk5B6ne7ECw@mail.gmail.com>
 <CAKR_QVLY9ryxUebZD_WWw01Wub9Ue=S3u5YGe2CVk+R8uNgjVw@mail.gmail.com>
 <CANCHnQqe7Y1=h0An0qNQGPONnN-tZ5vMon=-Uoif0GGY5NmPTg@mail.gmail.com>
 <20190109113320.GA15658@redhat.com> <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
In-Reply-To: <CANCHnQp+J56S=PbMTBkAWfrAi_GoTCOk3Wbao=wRm4A8=bbGKQ@mail.gmail.com>
From:   Jeroen Roovers <jer@airfi.aero>
Date:   Thu, 10 Jan 2019 15:29:44 +0100
Message-ID: <CANCHnQrF1u9sxPw3Dx+ZyDLRnZ0Qtn5C3d5Pr4=7tL0YnwtwWw@mail.gmail.com>
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

Aaaaaaand the results are in.

On Thu, 10 Jan 2019 at 08:49, Jeroen Roovers <jer@airfi.aero> wrote:
>
>      Hi Stanislaw,
>
> On Wed, 9 Jan 2019 at 12:33, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> > So would be below patch (on top of this set) be a solution for at
> > least to not kill the kernel. Or we looking for something better
> > i.e. watchdog ?
>
> I'll give it a spin. Thanks!

hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
to inactivity
kernel: [  500.782266] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x07 failed for offset 0x6888 with error -110
kernel: [  500.912237] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x06 failed for offset 0x6888 with error -110
kernel: [  501.042235] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x06 failed for offset 0x6110 with error -110
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
to inactivity (timer DEAUTH/REMOVE)
kernel: [  501.772201] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x07 failed for offset 0x1018 with error -110
kernel: [  501.902177] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x06 failed for offset 0x1018 with error -110
kernel: [  501.972186] ieee80211 phy0: rt2x00usb_vendor_request: Error
- Vendor Request 0x06 failed for offset 0x1910 with error -110
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
to inactivity
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
to inactivity (timer DEAUTH/REMOVE)
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
to inactivity
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
to inactivity (timer DEAUTH/REMOVE)
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
to inactivity
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
to inactivity (timer DEAUTH/REMOVE)
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: disassociated due
to inactivity
hostapd: wlan0: STA xx:xx:xx:xx:xx:xx IEEE 802.11: deauthenticated due
to inactivity (timer DEAUTH/REMOVE)

rt2x00usb_check_usb_error in your patch is set to
clearDEVICE_STATE_PRESENT after ten errors, but in this case only 6
errors were seen. Maybe I should set it to 1 as I have never seen an
RT5592 recover from this.

The system remained relatively stable until after I tried forcibly
removing and then loading the rt2800usb module. A simple `ifconfig`
then triggered a kernel panic. Sadly I couldn't capture it in time but
I did spot that more phyN (up to phy4) devices had been added.


Kind regards,
      jer
