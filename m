Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33468 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbcKIUpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 15:45:43 -0500
Received: by mail-pf0-f180.google.com with SMTP id d2so132530647pfd.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2016 12:45:43 -0800 (PST)
Date: Wed, 9 Nov 2016 12:45:39 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Andy Gross <andy.gross@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wcn36xx: Correct Kconfig dependency
Message-ID: <20161109204539.GB11179@tuxbot> (sfid-20161109_214606_061069_BCDCB4DB)
References: <1478714571-4841-1-git-send-email-bjorn.andersson@linaro.org>
 <20975667-9D09-430C-A70B-D0C38A320C86@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20975667-9D09-430C-A70B-D0C38A320C86@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 09 Nov 12:32 PST 2016, Marcel Holtmann wrote:

> Hi Bjorn,
> 
> > In the case SMD or WCNSS_CTRL are compiled as modules, wcn36xx must be
> > compiled as module as well, so we need to mention this dependency.
> > But we still want allow the driver to be compiled in case either of
> > those are =n, for compile testing reasons.
> > 
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > ---
> > drivers/net/wireless/ath/wcn36xx/Kconfig | 2 ++
> > 1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/ath/wcn36xx/Kconfig b/drivers/net/wireless/ath/wcn36xx/Kconfig
> > index 591ebaea8265..4b83e87f0b94 100644
> > --- a/drivers/net/wireless/ath/wcn36xx/Kconfig
> > +++ b/drivers/net/wireless/ath/wcn36xx/Kconfig
> > @@ -1,6 +1,8 @@
> > config WCN36XX
> > 	tristate "Qualcomm Atheros WCN3660/3680 support"
> > 	depends on MAC80211 && HAS_DMA
> > +	depends on QCOM_WCNSS_CTRL || QCOM_WCNSS_CTRL=n
> > +	depends on QCOM_SMD || QCOM_SMD=n
> 
> I thought we wanted to move towards being able to compile the WiFi and
> Bluetooth support without requiring QCOM_SMD.
> 

That's right.

The problem I spotted was that without the dependency on QCOM_SMD we're
allowed to compile these modules as builtin, but as
IS_ENABLED(CONFIG_QCOM_SMD) is true we don't get the stubs and as such
the kernel doesn't link.

So we must enforce these modules to be compiled as modules if either
QCOM_SMD or QCOM_WCNSS_CTRL are compiled as modules, and we do that with
the first part of the depends lines.


The second part of the depends lines states that the alternative
dependency is that the modules are not enabled at all, in which case we
will fall back to using the function stubs.

So this is unfortunately how we have to describe it in Kconfig to work
with the function stubs, sorry for not getting this right in the first
place.

Regards,
Bjorn
