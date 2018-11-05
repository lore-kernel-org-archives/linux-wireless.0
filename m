Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C841C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 12:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 041DE20819
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 12:10:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Azdx8rEW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 041DE20819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbeKEVaM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:30:12 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:46564 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbeKEVaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:30:12 -0500
Received: by mail-oi1-f193.google.com with SMTP id k64-v6so7177837oia.13
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 04:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zZJ+p3Eu9x7vN2Oob13WSBH3yjP+d1GS1HGLv7RkmGk=;
        b=Azdx8rEWx1iElHkQFdqHz3GIp1GzRSRcOtxeefuhJHZzPUEJjHHNky4k5MHYS0ElTt
         bCHNQ/whG7aN9G8M6o6rX6aNAV63b4KW7yWPPHkgAIuRMhYj3EMYkKwgdWfe6oLSi0qw
         hhCU6nxk8Ynyhla62RpZIMNQm3jm342jjLPcnwSoo2fXfM8MALE8ikVM+JN9gfa5XZ/o
         p+SxSV0xv79tcT3d1olFehI9iBUOoxPhHih++NVUeQEUFwuo+p9CPMV2ihniJ4aPa8p9
         LrWsln2wPtps0wxn28S2NU3N3BZ91oRzgoLPBW/EmO5ZKhELCmOjaS9EjtUIPRE/Cfe/
         /xTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zZJ+p3Eu9x7vN2Oob13WSBH3yjP+d1GS1HGLv7RkmGk=;
        b=P4rvUw7elKMAq6AIxz0HLrZ35iIsP16SJraQIdrf7EeuJPruB1qHfZPNvhGxpDjDtg
         bclq7Bs5Xia+lbWXrkq8ND942man3D1hlU7qiEY7UvrPUtnagxeBKnZYHNcvWZnVnWyi
         wI2IF/tHQpnGxDb1+ibtJ9spwAQpEn64i3y130kt45MoAC6FAtwkLe/zkvShLIddxua9
         2h6YNwPiVq9dLVDQMKQkvuBOonlMcGPQQLxQsr4mzog/hgo4FXpS075N/2B9ZLajqqGx
         4fx95rjJh0mTrSN7wtAn+iFEHLXE5R/XbkTJ9chTyVeu3kH2G9wplHNq6k918hKc1T2j
         b+rQ==
X-Gm-Message-State: AGRZ1gJAPvE9GmNPfhiVOqFQDFpBLrYo9xLvHKS/Jjf1tFh1PY7dw+rO
        dnxZcwiApy66pVEb3uOqVR/eD/fYC7DlMFd3fk57Cw==
X-Google-Smtp-Source: AJdET5eCqIfTVmb+aVsMR5A5acaFLGAyDR84JBZLeGwYlNGKk0zSoamHdkHqKJGgBCaCNEgn730T7KSH6ex2I8HAhtE=
X-Received: by 2002:aca:905:: with SMTP id 5-v6mr12663914oij.163.1541419844789;
 Mon, 05 Nov 2018 04:10:44 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:2ea6:0:0:0:0:0 with HTTP; Mon, 5 Nov 2018 04:10:44 -0800 (PST)
In-Reply-To: <DM5PR02MB3656089F61C0AD9C4D5E5FBCD4CA0@DM5PR02MB3656.namprd02.prod.outlook.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
 <1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com> <DM5PR02MB3656089F61C0AD9C4D5E5FBCD4CA0@DM5PR02MB3656.namprd02.prod.outlook.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Mon, 5 Nov 2018 13:10:44 +0100
Message-ID: <CAKR_QVKgGhoDhR+JJVW5Ndh38Wia+LGZYDpZqwu_28i1S1kKrw@mail.gmail.com>
Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
To:     Craig Matsuura <cmatsuura@vivint.com>
Cc:     "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 05/11/2018, Craig Matsuura <cmatsuura@vivint.com> wrote:
> Tom,
>
>
> I see my name and email in some urls but could not see what you are
> referring too?
>
>
> Craig
>
>
> Craig Matsuura =E2=80=A2 Technical Director, Embedded Software Architectu=
re
>
> cmatsuura@vivint.com<mailto:cmatsuura@vivint.com> =E2=80=A2 P: 801.229.60=
05
>
>
>
> simply smarter =E2=80=A2 vivint.com
>
> 3401 N Ashton Blvd. Lehi, UT 84043
>
>
>
> [1497369905956_vivint-logo-orange.png]
>
> ________________________________
> From: linux-wireless-owner@vger.kernel.org
> <linux-wireless-owner@vger.kernel.org> on behalf of Tomislav Po=C5=BEega
> <pozega.tomislav@gmail.com>
> Sent: Thursday, October 4, 2018 5:51:42 PM
> To: sgruszka@redhat.com
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 0/5] rt2800mmio txdone/interrupts/flush rework
>
> Hi
>
> As suspected this changeset causes throughput regression.
>
> Below screenshots show iperf test from MS150N (RF5370) device connected t=
o
> RT3070 adapter running AP mode:
>
> This is with standard openwrt build without any rt2x00 changes:
>
> [url=3Dhttps://postimg.cc/BtYQLf6r][img]https://na01.safelinks.protection=
.outlook.com/?url=3Dhttps%3A%2F%2Fi.postimg.cc%2FBtYQLf6r%2Fshot-2018-10-04=
_17-23-56.jpg%5B%2Fimg%5D%5B%2Furl&amp;data=3D01%7C01%7Ccmatsuura%40vivint.=
com%7C4b957a380bc24ebda1f708d62a546496%7C54cc98ca024a470185483741e3b8d59d%7=
C0&amp;sdata=3DFsq5PtjbTx3vuXrNyicoVMVyk59dlXin0SecZTKCcOY%3D&amp;reserved=
=3D0]
>
> And this printscreen show iperf test with your changes:
>
> [url=3Dhttps://postimg.cc/D8Sf1p48][img]https://na01.safelinks.protection=
.outlook.com/?url=3Dhttps%3A%2F%2Fi.postimg.cc%2FD8Sf1p48%2Fshot-2018-10-04=
_17-42-09.jpg%5B%2Fimg%5D%5B%2Furl&amp;data=3D01%7C01%7Ccmatsuura%40vivint.=
com%7C4b957a380bc24ebda1f708d62a546496%7C54cc98ca024a470185483741e3b8d59d%7=
C0&amp;sdata=3Dw9eslvFB%2F13VBHGG7n48C2KH4ceyk1Acb5G3wEoPdEc%3D&amp;reserve=
d=3D0]
>
> Atheros card connected to RT3070 iperf test difference was negligible (1M=
bps
> or less) on bodhi system, but
> it started to throw out reorder messages on my standard ubuntu after your
> changes:
>
> [url=3Dhttps://postimg.cc/SjJbP2SP][img]https://na01.safelinks.protection=
.outlook.com/?url=3Dhttps%3A%2F%2Fi.postimg.cc%2FSjJbP2SP%2FScreenshot.png%=
5B%2Fimg%5D%5B%2Furl&amp;data=3D01%7C01%7Ccmatsuura%40vivint.com%7C4b957a38=
0bc24ebda1f708d62a546496%7C54cc98ca024a470185483741e3b8d59d%7C0&amp;sdata=
=3D7AfQGKReywwEYrVZzYOxpLqbmg8kBdCbNE6Mj0%2BmGRM%3D&amp;reserved=3D0]
>
> My advice: stop sending low-quality patches and do some testing before
> submission.
>

Hi

No idea where did you got that message from, some safelink protection
seem to be added somewhere in the mailing process. You can check my
original mail here:
https://www.mail-archive.com/linux-wireless@vger.kernel.org/msg49652.html
. If interested in links you should open them manually as the URL
formating seems inappropriate.
