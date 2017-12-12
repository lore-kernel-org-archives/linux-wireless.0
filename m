Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754387AbdLLM5Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 07:57:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH] brcmfmac: fix CLM load error for legacy chips when user helper is enabled
References: <1513071596-17506-1-git-send-email-wright.feng@cypress.com>
Date: Tue, 12 Dec 2017 14:57:10 +0200
In-Reply-To: <1513071596-17506-1-git-send-email-wright.feng@cypress.com>
        (Wright Feng's message of "Tue, 12 Dec 2017 17:39:56 +0800")
Message-ID: <87shcgp0ih.fsf@kamboji.qca.qualcomm.com> (sfid-20171212_142348_891534_279DD8B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> For legacy chips w/o CLM blob files, kernel with user helper function
> enables returns -EAGAIN when we request_firmware() for blob file:
> "request_firmware() -> _request_firmware() -> fw_load_from_user_helper()
> -> _request_firmware_load() -> retval=-EAGAIN"
> We should do one more retry

Who says that we should do one more retry?

> and continue brcmf_c_process_clm_blob if getting -EAGAIN from
> request_firmware function.
>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>

[...]

> @@ -180,11 +183,18 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>  		return err;
>  	}
>  
> -	err = request_firmware(&clm, clm_name, dev);
> +	do {
> +		err = request_firmware(&clm, clm_name, dev);
> +	} while (err == -EAGAIN && retries++ < CLM_LOAD_RETRIES);

This looks like a REALLY ugly workaround, please think three times
before submitting something like this. And if you still decide to submit
it, put a good effort on the commit log to explain why the hack would be
acceptable.

Have you investigated why you are getting the -EGAIN, user space not
ready during boot or something like that?

-- 
Kalle Valo
