Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750824AbdKNGr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 01:47:58 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Chung-Hsien Hsu <stanley.hsu@cypress.com>
Cc: Wright Feng <wright.feng@cypress.com>,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH v6] brcmfmac: add CLM download support
References: <1507188678-24985-1-git-send-email-wright.feng@cypress.com>
        <87vaiilkw8.fsf@purkki.adurom.net>
        <20171110090013.GA131667@aremote01.aus.cypress.com>
Date: Tue, 14 Nov 2017 08:47:52 +0200
In-Reply-To: <20171110090013.GA131667@aremote01.aus.cypress.com> (Chung-Hsien
        Hsu's message of "Fri, 10 Nov 2017 03:00:14 -0600")
Message-ID: <8760adjqzr.fsf@kamboji.qca.qualcomm.com> (sfid-20171114_074806_440137_707DE62A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chung-Hsien Hsu <stanley.hsu@cypress.com> writes:

> On Fri, Nov 10, 2017 at 08:15:19AM +0200, Kalle Valo wrote:
>> Wright Feng <wright.feng@cypress.com> writes:
>> 
>> > From: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>> >
>> > The firmware for brcmfmac devices includes information regarding
>> > regulatory constraints. For certain devices this information is kept
>> > separately in a binary form that needs to be downloaded to the device.
>> > This patch adds support to download this so-called CLM blob file. It
>> > uses the same naming scheme as the other firmware files with extension
>> > of .clm_blob.
>> >
>> > The CLM blob file is optional. If the file does not exist, the download
>> > process will be bypassed. It will not affect the driver loading.
>> >
>> > Signed-off-by: Chung-Hsien Hsu <stanley.hsu@cypress.com>
>> 
>> [...]
>> 
>> > +	err = brcmf_fil_iovar_data_get(ifp, "clmver", buf, sizeof(buf));
>> > +	if (err) {
>> > +		if (err == -23) {
>> 
>> No magic numbers, please. Is this supposed to be -ENFILE?
>
> It indicates "Unsupported". I will remove it since it will not affect
> the CLM downlaod and driver loading.

BTW you would not have to remove it, adding a define would have been
just fine. (I was travelling, hence the late reply.)

-- 
Kalle Valo
