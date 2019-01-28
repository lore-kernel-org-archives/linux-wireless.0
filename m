Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAE7C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 22:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB59A2084C
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 22:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MUhOxjgi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfA1Wiv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 17:38:51 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35376 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfA1Wiu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 17:38:50 -0500
Received: by mail-ed1-f66.google.com with SMTP id x30so14486498edx.2
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 14:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xeMKn+QoURnr428YaDGIQLnsMKLu1rBJYBtIRRBZiPc=;
        b=MUhOxjgir91rw4Rpe8YZfN6F5DZfLZA1nGGKsBSGEeUaaq1HP75PKM6cPeNrY8KAuH
         vwIvVdVyHSuQaGPdTEdXqQuOt3sO+v8XMfZ3YtPRmjX347Ag/zo45ZrrzqUp36Uf/WuO
         j9v01nK/X7xLMShdkQO2Cd2kyy+KoPv427wpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xeMKn+QoURnr428YaDGIQLnsMKLu1rBJYBtIRRBZiPc=;
        b=FSbwFA1530IQJy0irMVRA4grbl7gGpz43Tn1YGmzrUhlF9+cAEh8g7MlMci9EqPspA
         nuHLBNQ9CaAHLvH4FW9PBHwVKn1ggljbX2VEg7kDW/avHjeieopi3RngXQHA/kEaQ8Sb
         WCNDABuSGvgPG/8Qzy7AOOo4TucLFcwgQ4E2TIjUNO1XcCmhK0JJDHLvTuhheYq1erbc
         5Yli136ed/vYtNCpw3ndRa9PsPbPNEGAjE5r0KznyfWJVo5HemmE/Wr4IXwfHWBpXX1i
         w9BZ9TdGaoSgkPxabqw7rvdmX8L75cNfKCcb5sHgPXtTis0cHYsLm5xi6qYHaY3NfqUZ
         YOxg==
X-Gm-Message-State: AJcUuke0blfNOgWOkPLGrWrqwNiHmu0Ix2WDlJdbZnL1+O4HZzx27eCY
        7rTM7xNqY1AvgBpADh5c4YIOPUsQwtc=
X-Google-Smtp-Source: ALg8bN5m1FRxmPDLWr7W1zVbC/5kKTHbBEuJj77TK6QzYS2DLKtBhwofk3lWP6sfUQ3/rIpU24wGIQ==
X-Received: by 2002:a50:8689:: with SMTP id r9mr22331544eda.227.1548715127894;
        Mon, 28 Jan 2019 14:38:47 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id t26sm14289352eda.22.2019.01.28.14.38.46
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 14:38:46 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id f23so14451359edb.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 14:38:46 -0800 (PST)
X-Received: by 2002:a50:951a:: with SMTP id u26mr23233946eda.4.1548715126287;
 Mon, 28 Jan 2019 14:38:46 -0800 (PST)
MIME-Version: 1.0
References: <1548654407-28469-1-git-send-email-yhchuang@realtek.com>
 <87tvht18mn.fsf@codeaurora.org> <F7CD281DE3E379468C6D07993EA72F84D1793BB2@RTITMBSVM04.realtek.com.tw>
 <20190128101214.GC4132@redhat.com>
In-Reply-To: <20190128101214.GC4132@redhat.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 28 Jan 2019 14:38:34 -0800
X-Gmail-Original-Message-ID: <CA+ASDXNW9v_abS+nX2+H2XymwOL9aVNwdPn-QhfZo71aeQahWQ@mail.gmail.com>
Message-ID: <CA+ASDXNW9v_abS+nX2+H2XymwOL9aVNwdPn-QhfZo71aeQahWQ@mail.gmail.com>
Subject: Re: [PATCH v3 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 28, 2019 at 2:16 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jan 28, 2019 at 09:25:32AM +0000, Tony Chuang wrote:
> > Sorry for the typo here. Yes, I mean " wireless-drivers-next ".
> > In MAINTAINERS file, I do change to "wireless-drivers-next" instead of "wireless-next".
>
> The git entry in MAINTAINER file is not necessary and should point
> the driver specific tree, which rtw88 do not have. Just remove this
> entry.

Yes, it seems Tony mis-interpreted my suggestion when I said he was
using the wrong tree. I agree this driver does not need a git entry at
all.

Regards,
Brian

P.S. I do plan to give this driver a spin this week and hopefully give
it a little closer review. No guarantees I actually get the time for
that, but I hope to...
