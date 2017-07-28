Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbdG1PCT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 11:02:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ipw2100: don't return positive values to PCI probe on error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499878022.6577.4.camel@redhat.com>
References: <1499878022.6577.4.camel@redhat.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>
Message-Id: <20170728150218.B8A8E6088D@smtp.codeaurora.org> (sfid-20170728_170222_790350_43D64A9C)
Date: Fri, 28 Jul 2017 15:02:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> wrote:

> Causes the PCI stack to complain, and then eventually call the
> PCI remove function, which ipw2100 is not expecting.  It then
> tries to unregister an already-released netdev and other nasty
> things, leading to a panic.
> 
> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1185518
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

185ffc194800 ipw2100: don't return positive values to PCI probe on error

-- 
https://patchwork.kernel.org/patch/9837159/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
