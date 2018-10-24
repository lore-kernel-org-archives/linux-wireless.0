Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C27BC67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 15:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79DE207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 15:15:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lEuXVPwF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C79DE207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbeJXXoU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 19:44:20 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33068 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbeJXXoU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 19:44:20 -0400
Received: by mail-io1-f68.google.com with SMTP id l25-v6so3378847ioj.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 08:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=57TAnftpY+tlk9zWBujv0Sj6tFHer8NG4ks/OBC5uwM=;
        b=lEuXVPwFr1xSMFivsR94wqJ2fVfGLBedDIjLuicS6qP3rDtPJYF63NwWPSryLqB+p6
         iLezsHg9wGhCMBZvbDXGcOTyZaEHZcP1i8kctRc3LHN5kFqKKePUPsJ1TBgLqXlZTbWj
         Q72OhQlgibX+DeOBCrcWVKJfibFE0+jtBnJ1AkXpmO8PjxFCgKBKQvOq9t/ehPZWyE+f
         tgUtk2vfc9O5+Zyfa53o17FBSWcUWkgCfxcv0Whyedtm/s2Yu9IHMy/SAtPV4bfV8yJE
         DpUO/cuRADtYYY3kRlIiJL9LQQ+ycxS6o3SbScn6IOoveK4RFidzBB2yQQ19wM5e40PB
         RPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=57TAnftpY+tlk9zWBujv0Sj6tFHer8NG4ks/OBC5uwM=;
        b=Bng5kaN8ZotI6XXD/ac93nh7lswSdVYj86ocVmcVQ8DV7gkR5YDRWKh9SG6GFKfO+a
         c1bgkRWvKiN5XBXb/rpHvqnaLBnHCr2OYLoVdaUMclcF9Q9y/2Yi4YoAFz5LPgMr3HHz
         +by+SADNZ4XAi1mpAuI4ID1vYefrYUzv+fCRcoiLJgmhTVGLBu8zJNuRLPTEQxg5merp
         JRYpIrbjzecengZqnx8kVuBXxLLUAP+Nzd3UDOfzB4BBKCmMnvMtQgjErMYeeYbKYsYC
         J5MavGMJris3Yc0djg26IcplfD9XdMlKHG2pkjlpuVpaO09ebDrMVSlHwQVSDah7xCrl
         KZjA==
X-Gm-Message-State: AGRZ1gJ9su9/C18OkN3PoZ4wPIu6KXL0ntoEDh4/vehMDRb+I0G6ceCj
        HT+pu25I/b1Nlgmpyt5d1Ip2FYvHCoqEmmEnBE4=
X-Google-Smtp-Source: AJdET5fwpOWCKlYRrthoD1GETnK43Tk2Ztx9WyBcDtXtoYJktUx9RAAyguBUBYihVeX6vsCNpPohoJwOCXSVs8E4EOg=
X-Received: by 2002:a6b:4006:: with SMTP id k6-v6mr13687806ioa.277.1540394149068;
 Wed, 24 Oct 2018 08:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20181024070436.4466-1-johannes@sipsolutions.net> <20181024112219.GA23126@redhat.com>
In-Reply-To: <20181024112219.GA23126@redhat.com>
From:   Joonwoo Park <joonwpark81@gmail.com>
Date:   Wed, 24 Oct 2018 10:15:37 -0500
Message-ID: <CAEfc+QkEbVPjoekqUkLf0n1vUa3yY2wjtCuA3ujZ-yvVvK84vQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
To:     sgruszka@redhat.com
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        luto@amacapital.net, rajatja@google.com, kirtika@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Acked-by: Joonwoo Park <joonwpark81@gmail.com>

On Wed, Oct 24, 2018 at 6:22 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Wed, Oct 24, 2018 at 09:04:36AM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > These files have a long history of code changes, but analysing
> > the remaining code leads to having only a few changes that are
> > not already owned by Intel, notably from
> >  - Andy Lutomirski <luto@amacapital.net>
> >  - Joonwoo Park <joonwpark81@gmail.com>
> >  - Kirtika Ruchandani <kirtika@chromium.org>
> >  - Rajat Jain <rajatja@google.com>
> >  - Stanislaw Gruszka <sgruszka@redhat.com>
> > remaining in the code today.
> >
> > Note that
> >  - I myself was working for Intel and for any possibly code
> >    that might be before my employment there give permission
> >  - Wizery employees were working for Intel
> >
> > More specifically, we identified the following commits that
> > (partially may) remain today:
> >
> > 25c03d8e8c13 Joonwoo Park <joonwpark81@gmail.com>      ("iwlwifi: do not schedule tasklet when rcv unused irq")
> > f36d04abe684 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: use dma_alloc_coherent")
> > 387f3381f732 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix dma mappings and skbs leak")
> > 2624e96ce16b Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix possible data overwrite in hcmd callback")
> > bfe4b80e9f73 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: always check if got h/w access before write")
> > d536c32b45d2 Andy Lutomirski <luto@amacapital.net>     ("iwlwifi: pcie: log when waking the NIC for hcmd submission fails")
> > a6d24fad00d9 Rajat Jain <rajatja@google.com>           ("iwlwifi: pcie: dump registers when HW becomes inaccessible")
> > fb12777ab59b Kirtika Ruchandani <kirtika@chromium.org> ("iwlwifi: Add more call-sites for pcie reg dumper")
> > 3a73a30049f2 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: cleanup/fix memory barriers")
> > aa5affbacb24 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: dump stack when fail to gain access to the device")
> >
> > Align the licenses with their permission to clean up and to
> > make it all identical.
> >
> > CC: Joonwoo Park <joonwpark81@gmail.com>
> > CC: Stanislaw Gruszka <sgruszka@redhat.com>
> > CC: Andy Lutomirski <luto@amacapital.net>
> > CC: Rajat Jain <rajatja@google.com>
> > CC: Kirtika Ruchandani <kirtika@chromium.org>
> > Acked-by: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
