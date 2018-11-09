Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFAEC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 06:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 655322086C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 06:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAeeqN5+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 655322086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727748AbeKIPwf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 10:52:35 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:34007 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbeKIPwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 10:52:34 -0500
Received: by mail-vs1-f67.google.com with SMTP id y27so432327vsi.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Nov 2018 22:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/cBHalX9FfHUH6C469tp34FRGr6iMtcAwSCSexw+Yo=;
        b=mAeeqN5+I5DZV1UGc+IkwHcUzv+4s0lEghIctWBJIO8K8jwB2aZcWGBJd7xa6ox7Wf
         o6/rikLDBROW/5qUhO/0RBF7+4moh717jYty9er0Yj7ozcW46KQwSoYgTXVzYp9IyXD/
         HVkdPQ6eDFRgUfyqDMxHEPG3n7PkaoTJ8/tBC2BnmNRFWpnHJWFe13QMXx1bdCh6S6Io
         fYHuUJtQhzgvJ0Q2AXGiEq4RStvVZQnafqONcOlOpOL1qPX6E4v6aKadKW1Pm4Z/UotO
         eKy+nkwUaXRVTDP9iUBfYO0VZRf36hnCJO4JMcJAVKx+ipB8OjIalwvyV/9gZR3vL7Wa
         6L2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/cBHalX9FfHUH6C469tp34FRGr6iMtcAwSCSexw+Yo=;
        b=Imk3yMsBGjcda6S2pyXb4s0GG3w51L4S8eyA+/q6W8LYNnLrq3fI2DVxa8xlpQ5P0B
         9snBTDAqliEOFaYXmOu8/UJgK/2bZ2uJ/57aFsPI1BCkLKLqsGlN7voV30Wv7J9fJUP3
         NfxgUGrmAGnt4VdEVy9LJPRSolREPxeyEt/YwTAenTMEygMLlZwcyhHr8AomG7Xk/SYe
         aSYA02n4nZtnMn9zeHL4G4uBgrM88lmbVd23SqbwN+UL+RS52D0wD35zPDNKtf+QAJ3O
         wl0R615yxu80pfxLaBjUpyJ+5xDKqPPC8jXeMU9/85tVft7sSnTCpwWmF4K2GOGqa24x
         4JgA==
X-Gm-Message-State: AGRZ1gKHNteSMbrgsn/uXf08aPYGzQoWyE6zpymyVGSrVKe8OnVMAIPf
        pe4scvuc6OIUxRr9jCTsKiMS/Qwetr18BVWlQus=
X-Google-Smtp-Source: AJdET5cpgJpaKtWqVKxt7K+pM7AAq64A/UZg4q2smM4+lHssErb5N1ZvnNED5n3bVxlpEGt142nrxI8vNEiaF5KLaVM=
X-Received: by 2002:a67:2f81:: with SMTP id v123mr3278038vsv.12.1541744011947;
 Thu, 08 Nov 2018 22:13:31 -0800 (PST)
MIME-Version: 1.0
References: <20181018083547.23262-1-johannes@sipsolutions.net> <CANGSkXRMOK7dJwyRZOgBZbypvAPyV6DUEtE+2LGodtiN5=BqmQ@mail.gmail.com>
In-Reply-To: <CANGSkXRMOK7dJwyRZOgBZbypvAPyV6DUEtE+2LGodtiN5=BqmQ@mail.gmail.com>
From:   Siva Rebbagondla <siva8118@gmail.com>
Date:   Fri, 9 Nov 2018 11:48:09 +0530
Message-ID: <CANGSkXSox2BquGzhXzALtLxVe8nY67iOfe-kHtRnhg2FEFE6Pg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: allow hardware scan to fall back to software
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Wireless <linux-wireless@vger.kernel.org>,
        sushant kumar mishra <sushant2k1513@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>,
        johannes.berg@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
Gentle Remainder..!!!.
Any update required for this patch?. If not, When can i expect this
patch to be available in wireless-next?.

Thank you,
Siva Rebbagondla

On Thu, Oct 18, 2018 at 5:21 PM Siva Rebbagondla <siva8118@gmail.com> wrote:
>
> On Thu, Oct 18, 2018 at 2:06 PM Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > In some cases, like in the rsi driver hardware scan offload, there
> > may be scenarios in which hardware scan might not be available or
> > desirable.
> >
> > Allow drivers to cope with this by letting them fall back to software
> > scan by returning the special value 1 from the hardware scan method.
> >
> Acked-and-Tested-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
