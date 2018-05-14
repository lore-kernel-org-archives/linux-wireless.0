Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753451AbeENNrK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 09:47:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master] BUILD REGRESSION b41c393676696c20456d5fd8cbe71453560ee06e
References: <5af6c41e.dwbK9bka/B8S6Bva%lkp@intel.com>
Date: Mon, 14 May 2018 16:47:06 +0300
In-Reply-To: <5af6c41e.dwbK9bka/B8S6Bva%lkp@intel.com> (kbuild test robot's
        message of "Sat, 12 May 2018 18:38:22 +0800")
Message-ID: <87lgcms61x.fsf@kamboji.qca.qualcomm.com> (sfid-20180514_154714_268241_1DEE8A63)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> tree/branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-ne=
xt.git
> master
> branch HEAD: b41c393676696c20456d5fd8cbe71453560ee06e rsi: fix
> spelling mistake: "thead" -> "thread"
>
> Regressions in current branch:
>
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2740:49:
> sparse: Using plain integer as NULL pointer
>
> Error ids grouped by kconfigs:
>
> recent_errors
> =E2=94=94=E2=94=80=E2=94=80 x86_64-allmodconfig
>     =E2=94=94=E2=94=80=E2=94=80
> drivers-net-wireless-broadcom-brcm80211-brcmfmac-cfg80211.c:sparse:Using-=
plain-integer-as-NULL-pointer

Could someone (Franky?) please fix this regression in brcmfmac? (Or if
it's a false positive report it to the kbuilt bot maintainers.) The
kbuild bot is complaining about this in every build report now.

I think the offending commit is:

7742fce4c007 brcmfmac: reports boottime_ns while informing bss

Earlier report:

https://lkml.kernel.org/r/878t94278l.fsf@codeaurora.org

--=20
Kalle Valo
