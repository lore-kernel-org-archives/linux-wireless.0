Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D583C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63BB321915
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 08:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfAYIbp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 03:31:45 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33826 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfAYIbp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 03:31:45 -0500
Received: by mail-lj1-f194.google.com with SMTP id u89-v6so7691601lje.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2019 00:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=A64WQCkSWaPnPTpt9zsqeA8eRLl3wXPFTijWzG9Nahk=;
        b=t60OIicZ9Uw8xn0VW6As0cpCd/ak3mZCwABXmOap9IHbCy9Ki1itUPOtubpLAsTVL4
         +azr1J7wjnZe32pdsuCg2ruqcL7iSpquqbsdhwU/EMOlUbfltKqOAFi4du7cENQ8k34i
         YSKTsn8ffBSBksX5QNIqWZEbirAM2LerBSiJE+c4wBYSGiufItcG9/ymnPTRnDSk3sQN
         X7QQ3P36XU+YSV1jsoFGhboJoxJbygCvFD5rRr2hg41hVC9XtUx7JZFNS87aLMJo6wMj
         MPTzHN1Qi07m+DLOvA1sgQvzhnh6RuHl0MrmvciJw2RTOb70yM9xB1yJT4adqhdBgJ8u
         r/3A==
X-Gm-Message-State: AJcUukcekDy1nWGoXF/7/lemhS1riNg4xeBqDcGvFKmod5BJYLzxritJ
        cUMtKXK6pQI79WeGJkGRh9U7uQ==
X-Google-Smtp-Source: ALg8bN4p7XbYfAW2QCQNP9uzbXWLOxYB9WUUM5P488VTvIwHtiyq8Bc/nFWJhHySv1nUeO+MPBSV0A==
X-Received: by 2002:a2e:8256:: with SMTP id j22-v6mr8197500ljh.40.1548405103201;
        Fri, 25 Jan 2019 00:31:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b25-v6sm1418293lji.94.2019.01.25.00.31.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 00:31:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3D68E180323; Fri, 25 Jan 2019 09:31:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kan Yan <kyan@google.com>
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v6 4/4] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <CA+iem5vnADN5YSvsts8sBO=_4yNE62E3roySHz5hU6OqNke-6A@mail.gmail.com>
References: <20190122142019.21417-1-toke@redhat.com> <20190122142019.21417-5-toke@redhat.com> <CA+iem5vnADN5YSvsts8sBO=_4yNE62E3roySHz5hU6OqNke-6A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 25 Jan 2019 09:31:41 +0100
Message-ID: <874l9xcf4i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kan Yan <kyan@google.com> writes:

> Hi Toke,
>
> This patch looks good to me. Great job on getting the airtime fairness
> scheduling framework done!

Great, thanks for checking! Have another patch to test on top of this
series, then we should look into getting the airtime queue limit patch
into mac80211 as well :)

-Toke
