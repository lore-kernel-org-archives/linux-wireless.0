Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:46562 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbXGaKLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 06:11:07 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1598101wxd
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2007 03:11:06 -0700 (PDT)
Message-ID: <1ba2fa240707310311h2118f36cx3c8490eee36f79aa@mail.gmail.com>
Date: Tue, 31 Jul 2007 13:11:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 4/7] iwlwifi: Endainity fix for rx configuration
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Gregory Greenman" <gregory.greenman@intel.com>
In-Reply-To: <200707311148.07995.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11858505963374-git-send-email-yi.zhu@intel.com>
	 <11858506013260-git-send-email-yi.zhu@intel.com>
	 <11858506033857-git-send-email-yi.zhu@intel.com>
	 <200707311148.07995.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/31/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 31 July 2007, Zhu Yi wrote:
> > From: Tomas Winkler <tomas.winkler@intel.com>
> >
> > This patch fixes endianity issues in rx configuration
> > related code.
> >
> > Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > ---
> >  drivers/net/wireless/iwl-4965.c |   26 ++++---
> >  drivers/net/wireless/iwl-base.c |  148 +++++++++++++++++++++------------------
> >  drivers/net/wireless/iwl-hw.h   |   10 ++--
> >  3 files changed, 101 insertions(+), 83 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
> > index 19591a6..786c5d0 100644
> > --- a/drivers/net/wireless/iwl-4965.c
> > +++ b/drivers/net/wireless/iwl-4965.c
> > @@ -3615,8 +3615,8 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
> >
> >               hdr = (void *)(pkt->u.raw +
> >                              sizeof(struct iwl4965_rx_mpdu_res_start));
> > -             rx_end = (u32 *) (((u8 *) hdr) + amsdu->byte_count);
> >               len = amsdu->byte_count;
> > +             rx_end = (u32 *) (((u8 *) hdr) + len);
>
> I doubt rx_end is a pointer to u32. Most likely you want to use
> (__le32 *) here and also audit the users of rx_end, if they
> need le32_to_cpu().
>
You are right. Only the len  parameter was fixed. I will send another
patch that fixes also the pointer.
Thanks
Tomas

> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
