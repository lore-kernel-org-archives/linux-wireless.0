Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8205BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 22:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 491BA22513
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 22:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZez2+1X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 491BA22513
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbeKOI1v (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 03:27:51 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40644 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbeKOI1v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 03:27:51 -0500
Received: by mail-lf1-f66.google.com with SMTP id v5so12718054lfe.7;
        Wed, 14 Nov 2018 14:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mudOypxtGS7u6RwPveAGdLhPQ6hhKSNLP/q3nn8s1uc=;
        b=CZez2+1XVjyb6fQps6GWVnCVieYo0foGoeWWxoaNP+dCsxL92OlIDADLpD397rRCX3
         msRWLNa2zjqs8CbazHeJ+zpojMSsrDG/ANPyxbdYy/ZIyZaXre4aqTV9zGPMTXgBawb3
         bQy11ka6TKpH64HZlmVHzBQI/RfZXNYX3ysxgWgyFOyzuARMcWPAHsypIGnqUy9MD3kB
         J1ZzJc5K6ybF3eoTGqVLCj+Dne6W+5YVAlhruDTWIRfACRzbU5WBp336wkOxINUG69Zh
         5WfT2eSZEDBSSrjuB5OVrQ2Cy/t4yiv0iFiQjZXq53HzVcaeWTfMeWNMN/laMdDNH/Tc
         80hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mudOypxtGS7u6RwPveAGdLhPQ6hhKSNLP/q3nn8s1uc=;
        b=qiksflNzBfnHT4gORUCNcazER33Z+HBqWITlnacR+KQJBhfxtlon59dMO4o1TDE9Kk
         ALkPTrfejtG0/kOoDatK4aeBURAouTd9tmNY2EKffNYWeQAb1lTHbcL3ZRfSte0Zc9nw
         q18ay5bMePbMXjmh1jEGpfEZOM3Pz16Ja6feOT/oF4ZI/VNzMmOrcEdWrDbw0n/6qmmi
         j88P5WqsnZH0iBxFDOw1/wTt1qvzA6O2Ql3/xdaY6gCWWmF9oKS8DU5t2MYR9Rk1USMn
         NxqIlEHeC92w44GcquuSW3VJmu3VIMq6+iCbBICpVhP5IGCjJ3K+wKqrDRzgEMln4ewm
         H4OQ==
X-Gm-Message-State: AGRZ1gLZMd7hvGEIihZWflp8/Ok1HP1XZeCGPasVy05Rm6Ffx5ir8Jgg
        ae4LCbZYM7JUzx4b2+GoQtp3I4nzPYzOp9gtZA==
X-Google-Smtp-Source: AJdET5cLDPiYn8SDq/UVtZvs2rFNU/dAl0uFjBFJcicJ28GoM3uh5Z752Ujz1QKOqgqCD6ZAlDY1sg2Oelvr7iQKXEM=
X-Received: by 2002:a19:c954:: with SMTP id z81mr1935461lff.150.1542233845866;
 Wed, 14 Nov 2018 14:17:25 -0800 (PST)
MIME-Version: 1.0
References: <CAEJqkgiKzYTZQTGWNAPTeOPFWz658FWqDsAhyoxVDP1VKWSukg@mail.gmail.com>
 <CAEJqkgh7xksO7tmPHGkOXvWftc2AcCgi4j3S3C88CorV53+Hgw@mail.gmail.com>
In-Reply-To: <CAEJqkgh7xksO7tmPHGkOXvWftc2AcCgi4j3S3C88CorV53+Hgw@mail.gmail.com>
From:   Gabriel C <nix.or.die@gmail.com>
Date:   Wed, 14 Nov 2018 23:16:59 +0100
Message-ID: <CAEJqkghgyYMxRc8-wnF-J1CGhuYD2vfVDSiLU1A0fwpXKN7Huw@mail.gmail.com>
Subject: Re: atk10k Unknown eventid and WARN() on resume with kernel 4.19
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, dex77@frugalware.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am Sa., 3. Nov. 2018 um 21:11 Uhr schrieb Gabriel C <nix.or.die@gmail.com>:
>
> Am Sa., 3. Nov. 2018 um 21:01 Uhr schrieb Gabriel C <nix.or.die@gmail.com>:
> >
> > Hello,
> >
> > starting with kernel 4.19 we noticed  'Unknown eventid: xxxx' warnings
> > on our Laptops.
> >
> > ...
> >
> > crazy@devnull:~$ dmesg | grep Unknow
> > [    7.144998] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [    7.147758] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > [    9.441654] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [    9.444446] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > [   11.770997] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [   11.773787] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > [320339.374108] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [320339.377020] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > [320342.128664] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [320342.131447] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> > [320344.452864] ath10k_pci 0000:03:00.0: Unknown eventid: 118809
> > [320344.455696] ath10k_pci 0000:03:00.0: Unknown eventid: 90118
> >
> > ....
> >
> > Both boxes also hits the following WARN*() on resume from S3:
> >
>  Uh sorry .. Gmail doesn't like long lines it seems.
> There the WARN() message:
>
> http://ftp.frugalware.org/pub/other/people/crazy/warn.txt
>
> >
> > Please let me know if you need an dmesg or any other informations.


Added pm list maybe someone there got some idea ?

Also same issue reported there :
https://bugzilla.kernel.org/show_bug.cgi?id=201499

BR,

Gabriel C
