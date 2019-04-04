Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487A6C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17E3C20674
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554366522;
	bh=zEHqEhWXZb2ElXZMWNMqG3PazIE9/M702h9sDFLKoqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zoznxGTegdAO+r5QaNZTxEO+JVN4VqW/czxsensHagINXoew2r2NCnJ3YQDx+AS7P
	 KPoE6pWZpd2vRknS3m7PlavPvBSd4Bx6eMea14BUoBrpqgLMNbekh5r78rjwQJLD+J
	 mefcAjkqp2g3h21CyM6n1B05cxeqv42seVXp1m0Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfDDI2l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 04:28:41 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:33307 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbfDDI2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 04:28:41 -0400
Received: by mail-ot1-f65.google.com with SMTP id j10so1605107otq.0;
        Thu, 04 Apr 2019 01:28:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEHqEhWXZb2ElXZMWNMqG3PazIE9/M702h9sDFLKoqY=;
        b=Awyt8lL8vL0c5ewP9slsRjm5kQq4goQKUm0Dx5z329dX2lxTL2Lsm8f9clk8mktL+2
         m8rNlZ/xcPubZ9f2InccBklkRcnCn6QjoM8Yr0L1N6MvkCwdgzUqC1zUEAJ/DoMWL5aD
         JLyqO8uSNEbOeos/O5HrqIwnUnh2E2CtuDQNY0OICOlcN9iQtHSNjDnbJTi61j3kpJ8/
         WsEw+UEcGvATaq3YG8OjOMhOY+fBw6VJz9TR+JUfsbYFDymLkdO+dZn1cjZw8XCpdTM+
         URxePDg6HxhIn0I8uMgs5/1o9DVvnW0FV+PpXRPWNzwZXPpHdq1lpo346GM2z6MUjE7K
         o3iQ==
X-Gm-Message-State: APjAAAUONY4UVNUmsy0K6cg/24c82WhHE3UYJ3+OLQnCuR1GL/UIDgX1
        +5iP/6VMigYW+Jd7Br6ZmLcmbh/nhN9CRyRplp8=
X-Google-Smtp-Source: APXvYqz26shc4cF/ZfGh8dWrhns/8Uw5BUmNZalGvVl3BmA9zUgFDfVA2h0qFKhCfddHzVb8IWxgWo5gqAE43Ko5hYg=
X-Received: by 2002:a05:6830:11d0:: with SMTP id v16mr3024742otq.159.1554366520385;
 Thu, 04 Apr 2019 01:28:40 -0700 (PDT)
MIME-Version: 1.0
References: <2884043.Jv1Mn93hE8@aspire.rjw.lan> <20190403195718.GA74723@google.com>
 <1645947.WPhbVaNX0l@aspire.rjw.lan> <CA+ASDXPoB94o0pbY0TQGS7Dtp2RNz=3goH38gpLtBoJ15i7eoQ@mail.gmail.com>
 <87k1gatnvt.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k1gatnvt.fsf@kamboji.qca.qualcomm.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 4 Apr 2019 10:28:29 +0200
Message-ID: <CAJZ5v0h=gcurf7msXkxBCmf86D1C1cMP6uL8iadUjMaNd6FPYA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Drop WARN_ON()s that always trigger during system resume
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        ath10k@lists.infradead.org, Todd Brandt <todd.e.brandt@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sriram R <srirrama@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Claire Chang <tientzu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 4, 2019 at 6:08 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Brian Norris <briannorris@chromium.org> writes:
>
> > On Wed, Apr 3, 2019 at 2:47 PM Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> I have been wondering whether or not I need to resend this patch or something ...
> >
> > I think the linux-wireless Patchwork instance is the source of truth
> > -- Kalle and Johannes use it for tracking status, IIUC. So this says
> > your patch is still "New":
> >
> > https://patchwork.kernel.org/patch/10837139/
>
> Yeah, that's right:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork
>
> So no need to resend, it's in my queue.
>
> I was travelling and then busy with something else so I haven't had a
> chance to process patches, I'll try to catch up now but I'm sure it will
> take a while as there are so many patches. Sorry for the delay.

No worries. :-)
