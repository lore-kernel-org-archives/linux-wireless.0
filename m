Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81253C64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A17320835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:30:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XV1JBSMw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A17320835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbeJCORT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:17:19 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44488 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeJCORS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:17:18 -0400
Received: by mail-lf1-f65.google.com with SMTP id m18-v6so3352938lfl.11;
        Wed, 03 Oct 2018 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=22wrp42nv39BT3NsKBT7iy67Dytzr8zmrjug9iNU144=;
        b=XV1JBSMwWiYTrTlIw1fDK420hUDWQ81qgSX2Rar1LD30uyNq0JwG1pJEwq+qNZUyk4
         byDom+r/S6kkYrpDhpaSxVnjpLPv/Ikg/zd8FYdLfxFeZt9hQkTKY1bg4rDOqdrdHIdH
         QPARo+6JEStqx2vgMMDxqCXfZQdnAoHn+4BLHW7L6JQTSDbqiGOC5IdBcKWISYNxoizi
         3ZzVEiyISjZuhPiLfxJNIL/WGOze3JvhyGZTfmNBvoILXfC6WFMyPa52qlTRgeuLG9Fc
         J7so1ScIHNprBigOHpmB09PBj+aIe9V7RbkIWtCHruGXjziugHzKmtYMad/1VTSLjMJB
         XChw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=22wrp42nv39BT3NsKBT7iy67Dytzr8zmrjug9iNU144=;
        b=Ly7+g19bbfj2OZ6We1n1zRCksX37zh9GCZsXxSuMPS8/+5nxcvHsTHotHtbB9XMsly
         TyU0NVtQUIxWTJy1qKQH1OQGxiruzNtBLjpWBHIfXZZoGGpOLfRaVUaER9qFs37tbyE+
         qGGT9Kf9uFHFyB1tN620Y6QpwvIWqSac/VMetBY0Mlw9VMqj2Pf2/1HLANbect+b5mF9
         GddU6zzMi25b+F9TJ4wJUnX3LFIZRUeSR3BEc4D1p1PVMDRcacwIkKJ5yAhCpfqCv2xR
         8ou/FlwynkiU3AJS6SLW6wvScgx42Zi6ChjWLesE2ePHWmbh9bxpeQNYZl+LGofM0Ali
         QuiQ==
X-Gm-Message-State: ABuFfojqnVALMjrK5s2Qmw2gQcax8AWTfW6wLdG8CIrBroFg6eUooI1Q
        Ez9EMsHRphCbDmfxs+NlnHWt9HtdiqgK4G4XOpd/J9Q1eZc=
X-Google-Smtp-Source: ACcGV63DZRbL1iQLmgW1l78zBTRqjCQv1olekXursFM5NCiMBhx8dSJMPnX6zXA//0TwNSzWzcNPvsYQfrQ+QAG+67Y=
X-Received: by 2002:a19:e44b:: with SMTP id b72-v6mr148711lfh.77.1538551805841;
 Wed, 03 Oct 2018 00:30:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
 <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com> <81B978A9-270E-4C0B-BE67-D05899B1BC3B@canonical.com>
In-Reply-To: <81B978A9-270E-4C0B-BE67-D05899B1BC3B@canonical.com>
From:   Matt Chen <mattsled@gmail.com>
Date:   Wed, 3 Oct 2018 15:29:52 +0800
Message-ID: <CALx5=V_0fyTcpTdYh=ZOLWL79cop1F=5GyMuK6S9QnP5qHKouQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
To:     kai.heng.feng@canonical.com
Cc:     luciano.coelho@intel.com, LKML <linux-kernel@vger.kernel.org>,
        johannes.berg@intel.com,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        linuxwifi@intel.com, Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I think Canonical were facing some wifi fw load error from some 8260
earlier module during the BT still loading the fw.
I believe we had later 8260 sku that fixed this issue.

Hi Kai-Heng,

Can you check with OEM for which SKU they are reporting the issue ?
Kai Heng Feng <kai.heng.feng@canonical.com> =E6=96=BC 2018=E5=B9=B410=E6=9C=
=883=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=883:28=E5=AF=AB=E9=81=93=
=EF=BC=9A
>
>
>
> > On Oct 3, 2018, at 3:24 PM, Luciano Coelho <luciano.coelho@intel.com> w=
rote:
> >
> > On Wed, 2018-10-03 at 15:15 +0800, Kai-Heng Feng wrote:
> >> To avoid the firmware loading race between Bluetooth and WiFi on Intel
> >> 8260, load firmware exclusively when BT_INTEL is enabled.
> >>
> >> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> >> ---
> >
> > Where is this coming from? Can you explain what "the firmware loading
> > race" is?
>
> Looks like the patch is not correctly threaded. I=E2=80=99ll resend the s=
eries.
>
> >
> >
> >> .../net/wireless/intel/iwlwifi/pcie/trans.c   | 37 ++++++++++++++++++-
> >> 1 file changed, 36 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers=
/net/wireless/intel/iwlwifi/pcie/trans.c
> >> index cc8c53dc0ab6..c30d3989e2a8 100644
> >> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> >> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> >> @@ -71,6 +71,7 @@
> >> #include <linux/vmalloc.h>
> >> #include <linux/pm_runtime.h>
> >> #include <linux/module.h>
> >> +#include <linux/intel-wifi-bt.h>
> >
> > I don't see this upstream.  Is it something that was recently added?
> > Looks odd...
> >
> > Regardless, this should also be protected on CONFIG_BT_INTEL.
>
> Thanks, I=E2=80=99ll update this one.
>
> >
> >
> >> #include "iwl-drv.h"
> >> #include "iwl-trans.h"
> >> @@ -1335,6 +1336,10 @@ static int iwl_trans_pcie_start_fw(struct iwl_t=
rans *trans,
> >>      bool hw_rfkill;
> >>      int ret;
> >>
> >> +#if IS_ENABLED(CONFIG_BT_INTEL)
> >> +    void (*firmware_lock_func)(void);
> >> +    void (*firmware_unlock_func)(void);
> >> +#endif
> >>      /* This may fail if AMT took ownership of the device */
> >>      if (iwl_pcie_prepare_card_hw(trans)) {
> >>              IWL_WARN(trans, "Exit HW not ready\n");
> >> @@ -1394,6 +1399,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_tr=
ans *trans,
> >>       * RF-Kill switch is toggled, we will find out after having loade=
d
> >>       * the firmware and return the proper value to the caller.
> >>       */
> >> +
> >
> > Stray empty line.
> >
> >>      iwl_enable_fw_load_int(trans);
> >>
> >>      /* really make sure rfkill handshake bits are cleared */
> >> @@ -1401,8 +1407,37 @@ static int iwl_trans_pcie_start_fw(struct iwl_t=
rans *trans,
> >>      iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL=
);
> >>
> >>      /* Load the given image to the HW */
> >> -    if (trans->cfg->device_family >=3D IWL_DEVICE_FAMILY_8000)
> >> +    if (trans->cfg->device_family >=3D IWL_DEVICE_FAMILY_8000) {
> >> +#if IS_ENABLED(CONFIG_BT_INTEL)
> >> +            firmware_lock_func =3D symbol_request(btintel_firmware_lo=
ck);
> >> +            firmware_unlock_func =3D symbol_request(btintel_firmware_=
unlock);
> >> +            if (!firmware_lock_func || !firmware_unlock_func) {
> >> +                    if (firmware_lock_func) {
> >> +                            symbol_put(btintel_firmware_lock);
> >> +                            firmware_lock_func =3D NULL;
> >> +                    }
> >> +
> >> +                    if (firmware_unlock_func) {
> >> +                            symbol_put(btintel_firmware_unlock);
> >> +                            firmware_unlock_func =3D NULL;
> >> +                    }
> >> +            }
> >> +
> >> +            if (firmware_lock_func)
> >> +                    firmware_lock_func();
> >> +#endif
> >>              ret =3D iwl_pcie_load_given_ucode_8000(trans, fw);
> >> +
> >> +#if IS_ENABLED(CONFIG_BT_INTEL)
> >> +            if (firmware_unlock_func) {
> >> +                    firmware_unlock_func();
> >> +                    symbol_put(btintel_firmware_lock);
> >> +                    firmware_lock_func =3D NULL;
> >> +                    symbol_put(btintel_firmware_unlock);
> >> +                    firmware_unlock_func =3D NULL;
> >> +            }
> >> +#endif
> >> +    }
> >>      else
> >>              ret =3D iwl_pcie_load_given_ucode(trans, fw);
> >>
> >
> > I'm not sure I like adding this BT-specific stuff here, especially not
> > without a detailed explanation.
> >
> > Did you also send the other patches in this series to linux-wireless? I
> > can't see them=E2=80=A6
>
> I=E2=80=99ll resend one soon.
>
> Thanks!
>
> Kai-Heng
>
> >
> > --
> > Cheers,
> > Luca.
>
