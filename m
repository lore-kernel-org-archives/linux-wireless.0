Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FROM,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAD2DC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 20:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69D6021927
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 20:24:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V3gHXdAV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388481AbeLUUYP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 15:24:15 -0500
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46296 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbeLUUYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 15:24:15 -0500
Received: by mail-lf1-f52.google.com with SMTP id f23so4740666lfc.13
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2018 12:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=8SFZQjIAlMDHf1HBs6ZSPgpsdWc2OofMX6ApfLAVcog=;
        b=V3gHXdAVwgaZPt2v1qi/9B+lFaxQZSCzEJVkoBiU571sEx+Rgg1ckn+kX61wRRL/Fr
         b3kJ9UueXsTNMP236nNURN4chkpptT91R8MbNAg1CPf94de0MDjxGvuR8hFeeZrs8opc
         ke2Gdr1fcx/Plnb/TXo2fxYQCzynTJyF70J+c8KfNojUZgGK9/8JHjNw/jItjxoa81Cf
         mko2KFvZcbn54CJr0BQPUzsBgSjAy9jKubyHF4oggOmwO9CsWLWpodufQa1dx8gk3zEy
         vBabfJr95ET2tqjmH3bzU0ZdRfCANbv1cwYNC/ZVxnd4k+RkHVbARtsJQDoa3kiRM+/6
         0o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8SFZQjIAlMDHf1HBs6ZSPgpsdWc2OofMX6ApfLAVcog=;
        b=R26jy3IHnPn5LwyZoQqQ6bJ6T3Xj4WRwsF0md0RDAVSkwGP8NLJ64Km6tcl7dKc8xS
         e8YYS+Y4J8fDF8xRyBhs3ihydzh30IJ6bhM42ovKkWVr25MvH3oWLcTD2yv+vpItl945
         yTWFmikxePF6/P4WTh+VvL0GBww0y6t58ccOkID0Pc6VlTEZiXVa01Mf5frHHZlQI3QO
         iTqNSCPSqSeVB5uid0iY07M6A/3VAbI3JDE1Yg0z30FO/MHFYSBHcnVN8UQqcIGhbP8t
         rvfp7R3tciXlfLm07CHqCovKVsd56/cf1mkdFUy4kAkA4v5xvZsHq7BzDTIEFFWGSrjL
         aMPg==
X-Gm-Message-State: AA+aEWbECYIHnwYOoxdUHkn5QrZeyQ3WLg9Bsva2u1Q9dzA/1oWBLgMA
        1pJcGvRzEy0gRrncPRR9sBEAmYqqP1e+rWZSVO+zIIALSyY=
X-Google-Smtp-Source: AFSGD/XEmlacAXU7/Vf64xxMxSpc96Ru+R8iFtgo9/SWKatpPB8Qpqu8OE1I50yO/UMU4VWVupgm2UkX+GR6OqjoLnk=
X-Received: by 2002:a19:a7c1:: with SMTP id q184mr2136763lfe.4.1545423852443;
 Fri, 21 Dec 2018 12:24:12 -0800 (PST)
MIME-Version: 1.0
References: <20181221101756.GA19960@x1.vandijck-laurijssen.be>
In-Reply-To: <20181221101756.GA19960@x1.vandijck-laurijssen.be>
From:   Marcin Sielski <marcin.sielski@gmail.com>
Date:   Fri, 21 Dec 2018 21:24:01 +0100
Message-ID: <CANWiEci9pCaxmSd30QMBY1gC5cFsDM8xeDyeq+C3_mxy7NP=qg@mail.gmail.com>
Subject: Re: question concerning Japan regulation and NO-OUTDOOR
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I think indoor/outdoor hint is currently only set by hostapd (see
phy_info_freq function at driver_nl80211_capa.c).
The entire implementation is based on US FCC regulations which allows
passive scanning.
https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=3D327&tn=3D5=
28122
I am curious how it is defined in EU RED.

Best Regards

Marcin Sielski

pt., 21 gru 2018 o 17:25 Kurt Van Dijck
<dev.kurt@vandijck-laurijssen.be> napisa=C5=82(a):
>
> Hey all,
>
> I work on a project for an outdoor device equipped with a Ralink wifi
> key. In order to get certified in Japan, we should be able to proof that
> the device is not using the 5.2GHz bands since this band is limited to
> indoor use only in Japan.
> As I understood, 5.4GHz and up are allowed.
>
> My first, rather rough, approach is to specify all 2.4GHz bands in
> wpa_supplicant's global 'freq_list' parameter.
> We found that our device still connect to 5GHz networks, I believe
> because passive scanning allows 5GHz networks to be detected anyway.
>
> 2nd attempt, on top of the 1st, is to patch wpa_supplicant with:
>
> diff --git a/wpa_supplicant/events.c b/wpa_supplicant/events.c
> index 37d429d..c32aa1a 100644
> --- a/wpa_supplicant/events.c
> +++ b/wpa_supplicant/events.c
> @@ -1223,6 +1223,13 @@ struct wpa_ssid * wpa_scan_res_match(struct wpa_su=
pplicant *wpa_s,
>                         continue;
>                 }
>
> +               if (!freq_allowed(wpa_s->conf->freq_list, bss->freq)) {
> +                       wpa_msg(wpa_s, MSG_INFO,
> +                               "frequency %u excluded", bss->freq);
> +                       wpa_dbg(wpa_s, MSG_DEBUG,
> +                               "   skip - avoid this frequency");
> +                       continue;
> +               }
>                 if (!freq_allowed(ssid->freq_list, bss->freq)) {
>                         if (debug_print)
>                                 wpa_dbg(wpa_s, MSG_DEBUG,
>
> In short, this enforces wpa_supplicant to honor the global freq_list
> parameter for joining accesspoints, as it does for per-network
> freq_lists.
>
> Is this sufficient to avoid our chip to send on 5GHz band?
>
> I also noticed some NO-OUTDOOR specifiers in the wireless regdb,
> but not on the 5.2GHz bands for Japan.
> I'm in the position to find out those details, and I'm willing to amend
> in the upstream repository.
> I do not yet see however how I can tell the kernel that it should limit
> wifi regulation to outdoor use only. There seems no simple 'iw reg set
> outdoor' or similar command. How is this done?
>
> Thanks for your responses in advance,
> Kurt
