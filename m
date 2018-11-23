Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A0E2C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 21:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BE1F20664
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 21:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="POp6K3Tv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BE1F20664
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbeKXHx6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 02:53:58 -0500
Received: from mail-it1-f176.google.com ([209.85.166.176]:54695 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbeKXHx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 02:53:58 -0500
Received: by mail-it1-f176.google.com with SMTP id a205-v6so20044465itd.4
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2018 13:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LlBZtsIFdqAB2UEV4WzCB6iiPQA2X4gH/55YOT5Q05E=;
        b=POp6K3TviHXpAs4508S4q5wO2lAneMBHaX/8k0rrgI9jqpMrhEMbDERrmIUx0H47vC
         vNtBkNkml6PW2/DGuMDxb0ySp0z+genDyPuZKhm2tGu7XHjwXdGQpRoaJZEV9tZmnXUK
         QiNNlOm7/eo8nNA3zTavVD2lQmmOYZPa94iHgzMcR+XDjfp3fVZE+hmtgq9MrOWUT0/n
         uCo/P74VFpFflg0yqu0sDAkBNWWDxvspVgzO8QdMAK5+JEUj7j+EnVgdj8BDfI0alEiW
         tZ1RRLKrbKflwdr/RurCalFG/qCNhvH9kM5t6B7076xqSDrS0gP3OyH7KpwolWmvJCLE
         ZfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LlBZtsIFdqAB2UEV4WzCB6iiPQA2X4gH/55YOT5Q05E=;
        b=X8DLI4kEVUFjBoNEePJzTPsgrhX1hc7UnMMAXxMFRr26CicjBlM1Nvx8qgp6aIf66H
         vjRSEXBXDKeZKL5NU1AnRjCsrX9BI3nrtm8p0yZXZylwhaHFJfhfOII/8E80kTc5x6Zb
         BP5v39dmRT5hQD7iU3iaPsN2JurPWNu8CNaOQC6JnnNEGubrvbBhdapnZKwidP09XkBD
         gAjuKorlG3foUY+dnHWXRmyM5ReNedxpvszTU6iVQCd9hjUHmSMjOB7tXdpX6DILMYii
         ujqkfcVSLLPT0uxozeBvmFN3q+uTULggd5gS1Nyi/S92r+HP2vxuU6KjVNrzr1i5fkEL
         TDdw==
X-Gm-Message-State: AGRZ1gJxZG+PksyoUCTlwGA2T+bia+CZqAPRax4TcwiwzoUWJCbZU+Mp
        SzXdBFokbfWfUNHt+K/SLw4+OwEbN0g=
X-Google-Smtp-Source: AJdET5d4nqvSKGw+YkEHAb+GjdrJ8Zk+VK/qPLsvrLc5mHzEL4earikk8FaMvPerAspIyGCnKw7IQw==
X-Received: by 2002:a24:b345:: with SMTP id z5mr14475243iti.153.1543007284432;
        Fri, 23 Nov 2018 13:08:04 -0800 (PST)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id r139sm8122708ior.53.2018.11.23.13.08.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 23 Nov 2018 13:08:03 -0800 (PST)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gQIgE-0005Jk-AD; Fri, 23 Nov 2018 16:08:02 -0500
Date:   Fri, 23 Nov 2018 16:08:02 -0500
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ramon Fontes <ramonreisfontes@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim: multiple antennas
Message-ID: <20181123210802.byslqv26ua6lptvv@localhost>
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
 <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
 <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 21, 2018 at 01:30:40PM +0100, Johannes Berg wrote:
> On Wed, 2018-11-21 at 09:26 -0300, Ramon Fontes wrote:
> > Sorry. I meant throughput.
> 
> Yeah, well. There's no actual medium (access) simulation in hwsim, so
> the actual throughput you get only depends on the performance of your
> CPU. 33Mbps seems quite low, but of course I don't know where you're
> running this.
> 
> Then again, you say you're using wmediumd, so perhaps that *does* have
> some sort of medium simulation these days? I didn't think it has it but
> I may very well be wrong on that.

wmediumd does simulate the medium, but it only ever handled simple OFDM
PHY rates, not MCS or aggregation or anything else from the last decade :)

-- 
Bob Copeland %% https://bobcopeland.com/
