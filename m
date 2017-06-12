Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbdFLQic (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Jun 2017 12:38:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2017-06-06
References: <1496777308.9478.107.camel@coelho.fi>
Date: Mon, 12 Jun 2017 19:38:06 +0300
In-Reply-To: <1496777308.9478.107.camel@coelho.fi> (Luca Coelho's message of
        "Tue, 06 Jun 2017 22:28:28 +0300")
Message-ID: <87d1a988lt.fsf@kamboji.qca.qualcomm.com> (sfid-20170612_183851_956488_F9F4BC0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> Here's my first pull-request intended for v4.13.=C2=A0 This one is double=
 the
> size of my normal pull-request since I'm sending to batches at once.  It
> contain=C2=A0generic development work, with improvements, bug fixes and
> cleanup all around.=C2=A0 More=C2=A0details in the tag description.
>
> I have sent this out before, and kbuildbot reported success.
>
> Please let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 219569ad0c41df7a7f999a2cad688c6b6ce173=
e2:
>
>   rsi: use subdirectory for firmware file (2017-06-01 12:51:19 +0300)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git =
tags/iwlwifi-next-for-kalle-2017-06-06
>
> for you to fetch changes up to 0ae0bb3f409d48251a9a1730a514b3521d8f6042:
>
>   iwlwifi: remove unnecessary code in iwl_trans_alloc_tx_cmd (2017-06-05 =
23:34:31 +0300)
>
> ----------------------------------------------------------------
> First batch of iwlwifi driver patches 4.13
>
> * Loads of FW API documentation improvements (for tools and htmldoc);
> * Continued work for the new A000 family;
> * Bumped the maximum supported FW API to 31;
> * Improve the differentiation between 8000, 9000 and A000 families;
> * A lot of fixes and cleanups here and there;
>
> ----------------------------------------------------------------

Pulled, thanks.

Because an hour earlier I had fast forwarded to latest net-next there
were two conflicts. This is what I wrote to the commit log, please
double check:

kvalo: There were conflicts iwl_mvm_stop_device() and
iwl_mvm_tcool_set_cur_state(). The former was easy but latter needed more
thought. Apparently the mutex was taken too late, so I fixed so that the mu=
tex
is taken first and then check for iwl_mvm_firmware_running().

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git/commit/?id=3D833689044e13a3fb8c6c03ad868375670d97010b

--=20
Kalle Valo
