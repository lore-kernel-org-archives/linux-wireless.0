Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71E86C43470
	for <linux-wireless@archiver.kernel.org>; Mon, 10 May 2021 13:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5299E61288
	for <linux-wireless@archiver.kernel.org>; Mon, 10 May 2021 13:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhEJNc1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 May 2021 09:32:27 -0400
Received: from mail-0201.mail-europe.com ([51.77.79.158]:58793 "EHLO
        mail-02.mail-europe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233966AbhEJMHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 May 2021 08:07:43 -0400
Date:   Mon, 10 May 2021 12:06:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1620648387;
        bh=Ei22Qdqy0/xxKHttj6zeuzsoK4OdLUs5FIjKuDVEnYY=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:From;
        b=eP2+SPZCKVXrHoYIBCGX6OMIO82BZGcoVW8Ql1DDlioB+nF26aA/qrPaKmrlQjNi+
         esVhA8w+ocR66D3A0W4BEQdUn+Gdg2m6bBnRwcwa5ml4hVPZn3QkwmFeysckfOHSpD
         MsmU5tizAYiCPh7rQpdZW/gQpepmuTaLYswCbyBI=
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>
Reply-To: rtl8821cerfe2 <rtl8821cerfe2@protonmail.com>
Subject: Re: rtw88: Guaranteed system freeze with RTL8821CE with RFE 2 type
Message-ID: <1jmF9EMZn2ywrHSGrNCzOUSAzllw9ox-Da2zfbSTnTULlX8Ha8F211TfKuxITBBtkfxiU_R0w7zUeFLdtDj4ejp6qPnCIhFj2U-rsCVNlMg=@protonmail.com>
In-Reply-To: <65c86fe7-f1f1-445f-40c2-25ceaa4e4fb6@lwfinger.net>
References: <vWuRjLpNOkVGXHNeCL6phN5YDcd6Oljm1WgEMO4vA9aufK8MxzN5itvDnRjPBWHZN0geAbRLAzgIj36kAiNtdHh5vg2RjUH_TzuqZ7WSYeE=@protonmail.com> <65c86fe7-f1f1-445f-40c2-25ceaa4e4fb6@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, May 10, 2021 4:16 AM, Larry Finger <Larry.Finger@lwfinger.net> w=
rote:
> The only splat that shows in either attachment is due to you not installi=
ng the
> regulatory database that sets the channels etc. for your domain. I do not=
 know
> what it is called for your distro - it is wireless-regdb on mine. It is u=
nlikely
> that this is the cause of your problem, but who knows?
>
> Larry

I installed the wireless-regdb package. The error message about
regulatory.db went away, but the system still froze.

I'll try the rtw_core parameter disable_lps_deep=3D1 now.
