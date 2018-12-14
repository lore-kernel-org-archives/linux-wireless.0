Return-Path: <SRS0=OWo+=OX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917E0C43613
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 14:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A8A52070B
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Dec 2018 14:12:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LM0xBlFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730067AbeLNOMu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Dec 2018 09:12:50 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44062 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbeLNOMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Dec 2018 09:12:50 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so2754578pgr.11;
        Fri, 14 Dec 2018 06:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6WGX3SSFa6M4AjpRdCU5Zt+PMMVJgC5t6tDMH8M4gJA=;
        b=LM0xBlFVaB/R/G80qhAL6kvF8SPLTvmUlOeG+nDgYqlMHNbha5PtTwZd3/S5lRTQ/t
         UBDLilWQm4RKMaFOdIh6GlxdEShiME1bB0uEMCB3n07LpMvhMII/bnIIZTk9JSWYVOFp
         nYKEIhzAEh/b/A+/P1RL2051QNrRfzYpvXGXhqORQhUPJK2BpMyNOTwBKS4ALmfQXIso
         oFHWzyNRmSbSR/HWT5ltXT/FDKnh/TwR5PkicoUIm3VBaTzGdDe73z+0lUOzVhdkb91x
         yyKnvs39xskmqtD9Cw1k92usbVrQ72BdCWL6jQOoyS1mQiW+wPzGkgfVMXFH+BwKeVgY
         U+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6WGX3SSFa6M4AjpRdCU5Zt+PMMVJgC5t6tDMH8M4gJA=;
        b=WjB8DD8WhZWOp2fYHYbQ36EsZMKK2O/RknXhsdNEeAMUAlKfkk2cXEBetYBvinRZ0S
         mt587qLFmM/cjTUpacVaF80rPHOwfkGgHVE19UtyfBWUy2hJG100YvA3xPKh8Vs7Ph2d
         8kM8tMnaK/XdK1EcuRNhLFpUmOVqUCcc0djUfgEaWZHJzAa8QXQMyRQFB76MERs7xl/H
         1Io1FO771LzKhIXuoVIRFqmjNvAfUv11jZAxf2ne5oa+uPoeSa9yW6LhxnNz4WuxylgV
         zwqUcAq7n09XAcf9buFGJCKMGDd78HGNAwoF7XAK0Qra48XY0c1NheIlvgJKH2Ag2nbH
         1i0A==
X-Gm-Message-State: AA+aEWbZ149mDily7b475ntEWT264iml8rHjyoXfP8doqYFzxsBfNKgr
        pNeoeefGozmsyeuk2VsVaKo=
X-Google-Smtp-Source: AFSGD/Wo6aIFcIEnDn8+HFAhLz4yYy7u+Bu5VdHDEMTLb5Rla1GLiRAU6UZVbYirBZ47y9vmbVWEyw==
X-Received: by 2002:a62:62c5:: with SMTP id w188mr3041897pfb.160.1544796769341;
        Fri, 14 Dec 2018 06:12:49 -0800 (PST)
Received: from bars (ip-195-182-157-78.clients.cmk.ru. [195.182.157.78])
        by smtp.gmail.com with ESMTPSA id w88sm8284593pfk.11.2018.12.14.06.12.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Dec 2018 06:12:48 -0800 (PST)
Date:   Fri, 14 Dec 2018 17:12:44 +0300
From:   Sergey Matyukevich <geomatsi@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        sergey.matyukevich.os@quantenna.com
Subject: Re: question: ip forwarding and fq/mq qdisc
Message-ID: <20181214141244.7rob5gm245wqbive@bars>
References: <20181214120210.kmeuwvajuiwlp2n7@bars>
 <c3ac480b-2c6c-689a-a39e-75df601e5261@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3ac480b-2c6c-689a-a39e-75df601e5261@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> > Hi all,
> > 
> > I have been running 4.18-rc8 kernel with enabled IP forwarding between
> > wired and wireless interfaces, where both interfaces
> > were configured as fq qdisc.
> > 
> > However after moving to 4.20-rc1 kernel the same configuration does not
> > work anymore: pass-through packets are not forwarded in both directions.
> > Forwarding starts working again only if I change qdisc of _both_ interfaces
> > to anything but fq/mq. For instance any combination of pfifo/fq_codel/noqueue
> > works fine.
> > 
> > Does it look like a regression or it is a known change in behavior ?
> > 
> > Regards,
> > Sergey
> > 
> 
> Hi Sergey
> 
> I guess EDT model broke this use case.
> 
> I was under the impression skb->tstamp was cleared when forwarding packets, maybe I was wrong.
> 
> Can you try the following ?
> 
> diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
> index 06ee4696703c0ce72ea914403b739839e60f1584..00ec819f949b5e76ea96be901a697f4e12d5cf4d 100644
> --- a/net/ipv4/ip_forward.c
> +++ b/net/ipv4/ip_forward.c
> @@ -79,6 +79,7 @@ static int ip_forward_finish(struct net *net, struct sock *sk, struct sk_buff *s
>         if (unlikely(opt->optlen))
>                 ip_forward_options(skb);
>  
> +       skb->tstamp = 0;
>         return dst_output(net, sk, skb);
>  }

Hi Eric,

This patch fixes the issue: ip forwarding works for fq/mq qdisc.

Thanks,
Sergey
