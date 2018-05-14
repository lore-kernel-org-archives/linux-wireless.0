Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55400 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751402AbeENNii (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 May 2018 09:38:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 00/12] *** Add support for wifi QMI client driver ***
References: <1522042636-25516-1-git-send-email-govinds@codeaurora.org>
Date: Mon, 14 May 2018 16:38:33 +0300
In-Reply-To: <1522042636-25516-1-git-send-email-govinds@codeaurora.org>
        (Govind Singh's message of "Mon, 26 Mar 2018 11:07:16 +0530")
Message-ID: <87po1ys6g6.fsf@kamboji.qca.qualcomm.com> (sfid-20180514_153842_282709_5FE6207C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> Add QMI client driver for Q6 integrated WLAN connectivity subsystem.
> This module is responsible for communicating WLAN control messages to FW
> over QMI interface.
>
> =E2=80=9CQUALCOMM Messaging Interface=E2=80=9D(QMI) provides the control =
interface between
> components running b/w remote processors with underlying transport layer
> based on integrated chipset(shared memory) or discrete chipset(PCI/USB/SD=
IO/UART).
>
> QMI client driver implementation is based on qmi frmework https://lwn.net=
/Articles/729924/.
>
> Below is the sequence of qmi handshake.
>
>        QMI CLIENT(APPS)                                         QMI SERVE=
R(FW in Q6)
>
>                          <------wlan service discoverd----
>
>                        -----connect to wlam qmi service----->
>
>                        ------------wlan info request----->
>
>                        <------------wlan info resp------------
>
>                        ------------msa info req-------->
>
>                      <------------msa info resp------------
>
>                      ------------msa ready req-------->
>
>                      <------------msa ready resp------------
>
>                      <------------msa ready indication-------
>
>                      ------------capability req------->
>
>                     <------------capability resp------------
>
>                     ------------qmi bdf req--------->
>
>                      <------------qmi bdf resp------------
>
>                       ------------qmi cal trigger------->
>
>                   <------------ QMI FW ready indication-------
>
> Govind Singh (12):
>   ath10k: Add qmi service for wlan qmi client
>   dt: bindings: add bindings for ath10k qmi client
>   ath10k: Add WCN3990 QMI client driver
>   ath10k: add support to start and stop qmi service
>   ath10k: Add support of QMI indication message
>   firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
>   ath10k: Add MSA handshake QMI mgs support
>   ath10k: Add QMI CAP request support
>   ath10k: Add QMI HOST CAP request support
>   ath10k: add bdf/cal indication support
>   ath10k: Add wlan mode on/off qmi message
>   ath10k: Add qmi wlan enable/disable support for WCN3990

BTW, I noticed that you had v3 only in the cover letter but the version
number should be in every patch part of the set:

https://patchwork.kernel.org/patch/10307161/

--=20
Kalle Valo
