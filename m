Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBB7C67872
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:03:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0BCA20835
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 16:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RP9Jw8Ct";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cZenIttq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C0BCA20835
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbeJLXg6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:36:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:39210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbeJLXg6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:36:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BA8B9600C1; Fri, 12 Oct 2018 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539360228;
        bh=G8sj/w6SyE4FoVx+Jz0zICQHLaiGr+tWvHvs4lv7vdc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RP9Jw8CtekV9FAx50VdAirijEEoi+EBpDcBD5BzMhrmidy87/IvKvDUhjkU02NPDZ
         mTn52xyQgk7FEtitlp4Rjr6/LG9iveFbh3NoUkWs+Xh475oWKQu8nULW6Khn0NbOBb
         BwyZ1ov+kYT1oGhSf+0hPOZV5KbJyt8xOq2qFcwY=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8E7FA600C1;
        Fri, 12 Oct 2018 16:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539360227;
        bh=G8sj/w6SyE4FoVx+Jz0zICQHLaiGr+tWvHvs4lv7vdc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cZenIttqpwNxLTXTdRUyfY2IfUJ+6QZUfX/paxhU4LxciYaWjhV5mhHJbmGk+WTPO
         PPIKsu3TXXHKsJLobqoEamKfvOlFdim36lqJUsaEIwvPhNfSSlK0eE7PFka84rO6Jn
         mhcWhOGCRA1ezlbFUMrqhpT4nbYJmgzgmLe/ulSA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8E7FA600C1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Niklas Cassel <niklas.cassel@linaro.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        Govind Singh <govinds@codeaurora.org>,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 0/6] *** Add support for wifi QMI client handshakes ***
References: <20180815092637.11455-1-govinds@codeaurora.org>
        <20181009003628.GA253926@ban.mtv.corp.google.com>
        <20181012120924.GA1030@centauri.lan>
Date:   Fri, 12 Oct 2018 19:03:42 +0300
In-Reply-To: <20181012120924.GA1030@centauri.lan> (Niklas Cassel's message of
        "Fri, 12 Oct 2018 14:09:24 +0200")
Message-ID: <87in272lup.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Niklas Cassel <niklas.cassel@linaro.org> writes:

> On Mon, Oct 08, 2018 at 05:36:30PM -0700, Brian Norris wrote:
>> + linux-msm
>> 
>> Hi Govind, Kalle,
>> 
>> On Wed, Aug 15, 2018 at 02:56:31PM +0530, Govind Singh wrote:
>> > Add QMI client handshakes for Q6 integrated WLAN connectivity subsystem.
>> > This module is responsible for communicating WLAN control messages to FW
>> > over QMI interface. This patch series enables the qmi handshakes required for
>> > WCN3990 chipset.
>> [...]
>> 
>> What's the status of this patchset? It has seen various stages of
>> review, and except for the fact that Govind seems to have dropped
>> various Reviewed-by/Acked-by tags (which Rob noticed), I don't see any
>> relevant feedback that should be blocking it.
>> 
>> I previously had concerns about the firmware boot sequence -- that it
>> required a Qualcomm-specific TFTP service over QRTR, which had no open
>> source implementations. There is now a published daemon that worked for
>> me [1], as well as firmware releases that loaded modem and Wifi firmware
>> together, such that this TFTP service is not needed at all. So my
>> concerns there are no longer blocking.
>> 
>> And I think Rob already reviewed the relevant DT bindings (but again,
>> Govind missed collecting that tag for this series).
>> 
>> So the only outstanding request I see is to collect the appropriate
>> tags. Should Govind resend the whole series just for that?
>> 
>> FWIW, I've been using this series for a while now, and I reviewed
>> earlier versions. I can provide this for the whole series:
>> 
>> Reviewed-by: Brian Norris <briannorris@chromium.org>
>
> Hello Kalle,
>
> I see that this patch series has been added to your master-pending branch.

Yes, I'm very close to applying these patches now.

> It seems to be lacking Brians Reviewed-by tags (from above).

Added in the pending branch.

> The diff between v4 and v5 is just:
>
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -1010,10 +1010,10 @@ int ath10k_qmi_deinit(struct ath10k *ar)
>         struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
>         struct ath10k_qmi *qmi = ar_snoc->qmi;
>  
> +       qmi_handle_release(&qmi->qmi_hdl);
>         cancel_work_sync(&qmi->event_work);
>         destroy_workqueue(qmi->event_wq);
> -       qmi_handle_release(&qmi->qmi_hdl);
> -       qmi = NULL;
> +       ar_snoc->qmi = NULL;
>  
>         return 0;
>  }
>
> I've given my Acked-by on v4:
> https://patchwork.kernel.org/cover/10540111/
> The change between v4 and v5 does not warrant the removal of those tags,
> so please re-add them.

Added these as well.

> Rob has given his Reviewed-by on the dt-binding on v4:
> https://patchwork.kernel.org/patch/10540115/
> The dt-binding hasn't changed between v4 and v5, so please re-add it.

And this also. Please check that everything is ok in the pending branch
I just pushed:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=pending

> I also noted that kbuild test robot complain about this series on x86:
> http://lists.infradead.org/pipermail/ath10k/2018-October/012268.html
> Are test errors still valid?

These errors are because of my mistakes in the conflict resolutions I
did yesterday. They should be fixed now.

> My patch series that makes QMI_HELPERS selectable for compile test
> (e.g. x86), is queued up for 4.20~5.0:
> https://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git/log/?h=qcom-drivers-for-4.20
>
> Does this patch series make the errors go away, or are they unrelated?

Yeah, the errors reported by kbuild bot were unrelated.

BTW, I can already use COMPILE_TEST to for compiling snoc.c on x86. I do
get some warnings about QMI_HELPERS which I guess your patches fix once
they land my tree.

Thanks for all the help!

-- 
Kalle Valo
