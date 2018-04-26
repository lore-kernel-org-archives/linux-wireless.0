Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:59175 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753717AbeDZIhn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 04:37:43 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Eyal Reizer <eyalreizer@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "robh@kernel.org" <robh@kernel.org>,
        "sre@kernel.org" <sre@kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH v2] wlcore: sdio: allow pm to handle sdio
   power
Date: Thu, 26 Apr 2018 08:37:35 +0000
Message-ID: <4750eeeedcde47d39cd207a8c21ef802@ti.com> (sfid-20180426_103801_329280_DB226EA7)
References: <1524721631-5983-1-git-send-email-eyalr@ti.com>
 <87po2m7573.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87po2m7573.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>=20
> > pm_runtime handles sdio power on and power off transitions.
> > An old workaround for trying to control the power explicitly from the
> > driver was in fact causing failures on suspend/resume as the mmc layer
> > already power the module on resume.
> >
> > In case of resume pm_runtime_get sync returns a positive device's usage
> > count causing the driver to try an re-initialize an already initialized
> > device. This was causing sdio bus failure on resume.
> >
> > Remove this manual power on/off sequence as it is in-fact not needed.
> >
> > Signed-off-by: Eyal Reizer <eyalr@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
>=20
> No changelog.
>=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingp
> atches#changelog_missing
>=20
> No need to resubmit because of this, I guess you just fixed the title
> and added Tony's Acked-by?

Yes, this is correct. No change in the actual patch hence there was no chan=
ge=20
Log.

Best Regards,
Eyal
