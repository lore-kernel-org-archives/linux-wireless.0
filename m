Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:52602 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaKJNVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 08:21:07 -0500
Received: by mail-lb0-f181.google.com with SMTP id l4so5757358lbv.26
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2014 05:21:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1415610621-27438-1-git-send-email-luca@coelho.fi>
References: <1415610621-27438-1-git-send-email-luca@coelho.fi>
Date: Mon, 10 Nov 2014 05:21:05 -0800
Message-ID: <CANUX_P3_Wg5UVbMTjid=4fWg4184dubd62G7enDZ7wf03A1tUw@mail.gmail.com> (sfid-20141110_142111_477700_E57C7A9F)
Subject: Re: [PATCH 00/16] iwlwifi: mvm: more CSA patches
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Hi,
>
> These patches finalize the CSA implementation for iwlmvm.  These are
> the remaining patches that were still pending in our internal tree.
> After this, I believe we are aligned.

Thanks Luca!

>
> This series depends on the mac80211/cfg80211 series I sent to Johannes
> last Friday (2014-11-07), we probably need to wait those to get
> applied to sync things up.
>

I will - no problem.

> There is one more mac80211 patch that I need to send.  This series
> removes the usage of the channel_switch_beacon operation in iwlmvm.
> It's the last user of it in the mainline, so we can remove it from
> mac80211 after the trees are in sync.
>
> --
> Luca.
>
> Andrei Otcheretianski (2):
>   iwlwifi: mvm: Handle failed beacon transmissions during CSA
>   iwlwifi: mvm: Insert DS Parameter Set placeholder in probes
>
> Luciano Coelho (14):
>   iwlwifi: mvm: use new pre_channel_switch op instead of
>     channel_switch_beacon
>   iwlwifi: mvm: only save csa_vif in AP/GO mode
>   iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other
>     modes
>   iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
>   iwlwifi: mvm: return the actual error code when switch_vif_chanctx
>     fails
>   iwlwifi: mvm: disable PS during channel switch
>   iwlwifi: mvm: use switching_chanctx argument instead of csa_active
>   iwlwifi: mvm: add CSA absent time event for clients
>   iwlwifi: mvm: schedule CSA time event a bit before beacon 1
>   iwlwifi: mvm: finalize on post_switch instead of unassign
>   iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
>   iwlwifi: mvm: disable beacon filtering during CSA
>   iwlwifi: mvm: clear TE data if CSA time event fails to start
>   iwlwifi: mvm: protect session during CSA
>
>  drivers/net/wireless/iwlwifi/iwl-fw.h         |   4 +-
>  drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |  21 ++-
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 254 +++++++++++++++++++++-----
>  drivers/net/wireless/iwlwifi/mvm/mvm.h        |  36 +++-
>  drivers/net/wireless/iwlwifi/mvm/scan.c       |  53 +++++-
>  drivers/net/wireless/iwlwifi/mvm/sta.c        |  15 ++
>  drivers/net/wireless/iwlwifi/mvm/sta.h        |   1 +
>  drivers/net/wireless/iwlwifi/mvm/time-event.c |  39 +++-
>  8 files changed, 356 insertions(+), 67 deletions(-)
>
> --
> 2.1.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
