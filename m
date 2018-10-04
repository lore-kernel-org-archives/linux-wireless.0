Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618EEC64EBC
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 06:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 263682098A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 06:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGk4ZYBp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 263682098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbeJDNtI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 09:49:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34391 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbeJDNtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 09:49:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id k19-v6so2918612pfi.1;
        Wed, 03 Oct 2018 23:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W/aJB4CDKepmf+nTK2KN68zVTtYD6k3/U7624cOERLI=;
        b=nGk4ZYBpxMasPe8lIcIApoqyLPwBcoyIqE+dVOUFX9MdISmleoTifkIWO++jeTHdnP
         fuXRMu8gbA3mVeyDQupbQ4bTDyRjpNqgKZPS6WBe09SVHJgq70LsrDUHzLCuwGv2hFfM
         /XlRDCm5s9ubye2lmS8JS7bt3aw/eyNjNwbRchqYlkIgbEsojaWvY441R8nhu1kV+eb7
         OeyAg1sVfF7QdD7RTOhPDMZKSv9sB8felD2IW8TnMydjgeVXIZ+7c2T/wJQzOg3HhvnU
         TLdufajZtCEz3wHJn9FyycIALk0MMXE++6DCMbrs9ikWKeLJiCqntIHoFZV95FXyw1mh
         NzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=W/aJB4CDKepmf+nTK2KN68zVTtYD6k3/U7624cOERLI=;
        b=kaSXykLRZhidy7geBpS8Ej6VlApiAZKaE0ZErOvmIUhRwN+LL7m5tg+kuwi4ErzNPJ
         lxKLVqZuEt/dbuLM2RGNQWXvoAtC5ME+5+WVmAijv8a3e+n1+7yGNe3Vo5TjcEFfphJZ
         7X94Y7b3nSZpYj9I3H/IJsxNqRXSVRJwRzoSFTHtNZxGSA5Ab0hyGb0NncK+VWosZFPY
         OP30kYe0YJPT9fzwceLbBYmZUxgeZ4I0wof0nnTJ+uQVx+HN4WdZy/TWQetoyghKeTLN
         c9iZLWOXMsqkiIXwhQD9uBU7yofTpyK6duTh1+IBxgGUO3zcV1mx8ydo/BgiHgHno5M/
         mjLg==
X-Gm-Message-State: ABuFfohO4C/Rwwa+FqSYv3/4dwH8b3WgA1OIrafpnvrdlRj6bd38qByQ
        W82fDxXuJ/bS8hvSFERxhtM=
X-Google-Smtp-Source: ACcGV60RP5+YEwOa/f51OxPnuNMZbcRwCcr5ZqqyUfamd33iCi2rjVnfFLTykKvonSos6S+BQd53Jw==
X-Received: by 2002:a63:d749:: with SMTP id w9-v6mr4389249pgi.415.1538636240785;
        Wed, 03 Oct 2018 23:57:20 -0700 (PDT)
Received: from E570.localdomain (c-24-21-68-121.hsd1.or.comcast.net. [24.21.68.121])
        by smtp.gmail.com with ESMTPSA id u77-v6sm6885942pfj.40.2018.10.03.23.57.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 23:57:20 -0700 (PDT)
Received: by E570.localdomain (Postfix, from userid 1000)
        id A2029160683; Wed,  3 Oct 2018 23:57:20 -0700 (PDT)
Date:   Wed, 3 Oct 2018 23:57:20 -0700
From:   Lance Roy <ldr709@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/16] wireless: Replace spin_is_locked() with lockdep
Message-ID: <20181004065720.GE896@E570.localdomain>
References: <20181003053902.6910-1-ldr709@gmail.com>
 <20181003053902.6910-9-ldr709@gmail.com>
 <877eizjt5j.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877eizjt5j.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 03, 2018 at 12:06:48PM +0300, Kalle Valo wrote:
> Lance Roy <ldr709@gmail.com> writes:
>
> > lockdep_assert_held() is better suited to checking locking requirements,
> > since it won't get confused when someone else holds the lock. This is
> > also a step towards possibly removing spin_is_locked().
> >
> > Signed-off-by: Lance Roy <ldr709@gmail.com>
> > Cc: Daniel Drake <dsd@gentoo.org>
> > Cc: Ulrich Kunitz <kune@deine-taler.de>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: <linux-wireless@vger.kernel.org>
> > Cc: <netdev@vger.kernel.org>
> > ---
> >  drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Should I take this or is it going through some other tree?
Sure you can take this if you like. If not, Paul McKenney will take it in his
tree.

Thanks,
Lance

> If it goes to via some other tree:
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
> --
> Kalle Valo
