Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C384DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 01:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDC0206DF
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 01:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nuLL4saY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfCZBy1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 21:54:27 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40784 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730575AbfCZBy1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 21:54:27 -0400
Received: by mail-oi1-f193.google.com with SMTP id 3so8669973oir.7
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 18:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=6Zs8gZag/meP4ZAkU73p19cQhIVmC9ENLmBInZ6UuoQ=;
        b=nuLL4saY9hA1Zq2seIlkD817mJCaPT5LSrDC20vx77kqSsfRg42ldfhYocK1JuJcqb
         acPLlr3d2YXny7apf41qr1YuGe/TZ0D41n0JEf4GQ0D7w51iMdRFz6TiyH4pjuJCWxh5
         9vOZqIh787W0iD40UZ/4pwRIDCyUfBjgXkz9/d6O1GYjszxwJJyJOh40Zzv/GYhClO2D
         pTcNPUJ1E0OLwgAwmGNv/t3Zoy/kqy8kMB22nX6haYo+VXzMP2IZEmav6eBlPWhGZKRO
         b0zETVS/o3EByAS72wByY1qJRu/q7SMYG/sTqnlpxV/7BIVyiVdSKBE9V/8SBsZrnXm2
         knBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=6Zs8gZag/meP4ZAkU73p19cQhIVmC9ENLmBInZ6UuoQ=;
        b=qt7kNfXGipeDEvniZtKTTfX5fVCjvjFYxlBX4uj0wg/ETNyGlrlLOGv3qU1+oSOld9
         Jsam5OChPsPjQCoe/eSlUzVcvnaoYN5gW4hO9QKd60K+Ek6MNyEwiS+BgjjCLjptGj+d
         gNlHOl5dnb2+SnPkxAKQfPcxZY/p8zCpUKnFiVHrrg/kPSaSg9MmO7O0HdaZFXCzy4Pe
         QHmVRfbaTWIQSFWxf0uM7eDV+7DD74//Hs/GdpECFlhAnLaIZ4ZXPdQnh4eH2OGTLovN
         ENYWAhlfDIOLVmMGRNxui8MxlWttRjqPi1RkWIj2pRZC9OHGxNgNRoOErrP+85UUUIX/
         o/AQ==
X-Gm-Message-State: APjAAAVyq5DStufzG9XsUkDu3OaLSEvx6iC9j4Pmkv1z3VjYK1vdK1ju
        cwuvTBJplxbZwTKgUPoIQY2m4uds1cDKmH4MPdU=
X-Google-Smtp-Source: APXvYqx+7cuChaFZUEgCOyDf/4H5D2NHxa1ZVNJVy8Jq9cd/cjmRNsm4YpD0TBegy3Ra3niA5foOeSRRSYZFSCy4vIA=
X-Received: by 2002:aca:5757:: with SMTP id l84mr14553433oib.155.1553565266291;
 Mon, 25 Mar 2019 18:54:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Mon, 25 Mar 2019 18:54:25
 -0700 (PDT)
In-Reply-To: <20190325142537.GA13884@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com> <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com> <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com> <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <20190313155028.GB5302@redhat.com> <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
 <20190325142537.GA13884@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 26 Mar 2019 02:54:25 +0100
Message-ID: <CAKR_QV+zUBKk=8UHiCnWQg9XCdB8zbMEcVSKEO7vFOR0Q2Yesw@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 25/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Mar 14, 2019 at 03:02:14PM +0100, Tom Psyborg wrote:
>> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>> >
>> > There should be no difference between enabling MFP with nohwcrypt and
>> > without nohwcrypt,
>>
>> well there is. do you still want me to resend this with MFP enabled
>> unconditionally for all chips?
>
> Please share your hostapd config file with MFP enabled.
>
> Stanislaw
>
>

ctrl_interface=/var/run/wpa_supplicant
eapol_version=1
ap_scan=1
fast_reauth=1
pmf=2
network={
	ssid="OpenWrt"
	proto=WPA2
	key_mgmt=WPA-PSK
	pairwise=CCMP
	group=CCMP
	ieee80211w=2
	psk="u7e5hwh46uz7ergv"
	wpa_ptk_rekey=60
}
