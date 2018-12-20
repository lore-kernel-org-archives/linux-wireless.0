Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D2FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66FC421720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mpDBr8g4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388110AbeLTRnb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:43:31 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35029 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387472AbeLTRna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:43:30 -0500
Received: by mail-pg1-f196.google.com with SMTP id s198so1219853pgs.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Dec 2018 09:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DeO+gnbz1SAVm4T6/y3xW8+Mgb/T/u9Wag6ydVGEg+E=;
        b=mpDBr8g4gBpisM/NQjuYFb5wQRXg2oQDcUTzkoSEyTS7HE1UIWZfOkq866xMaJkSpa
         FFv/DyXZzLFwEEfyLQp1RPcZnZWKBU9F9N4CfBnxqGb7ZRLH/WFRWoaoV96uIy+hoETn
         zLKBewFYT4KNWWHYpBGlal6le0o5RrgEh5MII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DeO+gnbz1SAVm4T6/y3xW8+Mgb/T/u9Wag6ydVGEg+E=;
        b=c2pMxfFGWGHffkttxTAOptPRi4WffngP7BfQAPQYtMabEK74xQGUh3l7q1yYfipzgD
         Zs5ymupPzynS51326pWoBxsdPAy8rjtIu5V2zzztvpzqqugOwxlBcK1JfIfW1sSTvwYR
         M3fKgn4gvEJBOqtEZkp+yv3OZmYNHk/QtL3rP/HqytAiwnEe6YaJsDc0tNopu+MzpiKF
         saQcaqxXrokfxBbH7xeAxyXWP4g6lA2VpWxU0kpLcZG7+nKJz9GwsRi6qEPHUs833clr
         hr3v1/YpIqMitNjx+OLmMpGqBjmyUulj6H9dXeQHQP6ltJiXwhmTeIinvpp3ejvuGc/8
         ipbg==
X-Gm-Message-State: AA+aEWbZPIzuHIJ24ROq1PAAvKuzz76HcJ39+wWItnTb6hJNuJxIuhTV
        UvX6st2lU2yljhWZ0TK3nRhv2YCtnAg=
X-Google-Smtp-Source: AFSGD/Viu3VtRgE2d+F6DwrHDoJhNf0AHCFLJs6V/o3Wc0/yvOR1vq6WkzveqvWbM0fca1k9AERO5w==
X-Received: by 2002:a62:520b:: with SMTP id g11mr25521677pfb.53.1545327809665;
        Thu, 20 Dec 2018 09:43:29 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id v190sm30529459pfv.26.2018.12.20.09.43.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Dec 2018 09:43:28 -0800 (PST)
Date:   Thu, 20 Dec 2018 09:43:26 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     govinds@codeaurora.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Move non-fatal warn logs to dbg level
Message-ID: <20181220174324.GA67805@google.com>
References: <20181129042522.11767-1-govinds@codeaurora.org>
 <CA+ASDXMOqzXk9HrX9AS58cUfKOHeXA7zN_ME3+zDZXQcok_0Tg@mail.gmail.com>
 <87h8f8talw.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h8f8talw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Dec 20, 2018 at 06:40:43PM +0200, Kalle Valo wrote:
> Brian Norris <briannorris@chromium.org> writes:
> > Alternatively, you could add these ignored commands to wmi-tlv.h, and
> > just ignore them specifically. That's better documentation, in case
> > new WMI events come along that *are* important to notice when we
> > ignore them. There are other recent examples of that sort of patch
> > being merged.
> 
> I have actually tried to do that (what Brian describes above) during the
> last years but the problem is that there are just so many different
> firmware branches that it's difficult to keep up in ath10k. So in the
> end these warnings just confused the users and they mistakenly thought
> this warning message is the cause of their problems. That's why I think
> it's best to remove this warning.

Thanks for the background. To be clear, I'm perfectly fine with this
patch too. I was mostly just volunteering an alternative, in case it
*was* your intention as maintainer to keep it this way.

Regards,
Brian
