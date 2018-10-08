Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DDEC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:16:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FB2A2086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB2A2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbeJHQ0u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:26:50 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55496 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726123AbeJHQ0u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:26:50 -0400
Received: by mail-wm1-f66.google.com with SMTP id 206-v6so7365955wmb.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2018 02:16:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DIJv+yZKE52f0A6IO3wdlj9sz7NaIdiVUVIfM8ii56E=;
        b=ieOh7fmIoesAnsdOJ6yTR/4tCE6L3RyGs89izdQpc/Bv6D5iiba++7GE8EE7paT2MS
         WnF/jm1HDE9327/oNvG0oO3JiQ1ELXhN34RrOI9DRl+b2XA7V9UdLWV3KvuoCf/Lwv/e
         dm01nnI2WawRgbZcYJTUuVXRnDTStaWZJXblDTcazaBAb4/etHRGBQDxzx6kgmAuJ6bo
         +2h8lxI9Y3qYsdcrTKeSJBjpEf+qt69TeWWu0TW76ZdlzWdjx764xVYIRrRxFuJCwWjZ
         32820kSBHukRfNtxi+awxC2i7mzkxa2qSAHODk6Se7bU+IKEjbCCqH9gZETe3NBvasjV
         qDrA==
X-Gm-Message-State: ABuFfohW4Fdh1PI7DTqu/R5wcW5y/EBMilbRBR1yi9rIMVbwyxHoY+xL
        TrUdQsQOlEhITaN56c/PQszPMA==
X-Google-Smtp-Source: ACcGV63LRP1GEJtOCUI/mD3mvLFZuBkf7DaC9x+1+GWKblUAT1cVmH+U2l7oTW3qYPBEZw0RFWGI8Q==
X-Received: by 2002:a1c:84cd:: with SMTP id g196-v6mr14715827wmd.38.1538990165136;
        Mon, 08 Oct 2018 02:16:05 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id q16-v6sm12836169wrn.41.2018.10.08.02.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Oct 2018 02:16:04 -0700 (PDT)
Date:   Mon, 8 Oct 2018 11:16:02 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] split code in mt76x02_util.{c,h}
Message-ID: <20181008091601.GA15297@localhost.localdomain>
References: <20181001223429.21061-1-lorenzo.bianconi@redhat.com>
 <1538987449.3687.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538987449.3687.1.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Lorenzo,
> 

Hi Johannes,

> It would help - also for patchwork tracking - if you could thread your
> patch series properly.
> 
> FWIW, that should be the default in git send-email, so I think you need
> to either update your version or change its configuration. Unless you
> weren't using --compose option and sent the 0/N manually beforehand or
> something?
> 

I sent this series from a different machine so I guess it is not configured
properly, I will double check. Thx for the info.

Regards,
Lorenzo

> johannes
> 
> On Tue, 2018-10-02 at 00:34 +0200, Lorenzo Bianconi wrote:
