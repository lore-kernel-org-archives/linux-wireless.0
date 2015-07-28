Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:33167 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbG1LYz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 07:24:55 -0400
Received: by igbpg9 with SMTP id pg9so131980386igb.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 04:24:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437421384-19884-3-git-send-email-emmanuel.grumbach@intel.com>
References: <1437421384-19884-1-git-send-email-emmanuel.grumbach@intel.com> <1437421384-19884-3-git-send-email-emmanuel.grumbach@intel.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 28 Jul 2015 16:54:35 +0530
Message-ID: <CABPxzYKKCLDaoAyE0VR66ynAxnm9Ob5m6T0ADbH415J6-i=6WA@mail.gmail.com> (sfid-20150728_132459_725763_2E51D94A)
Subject: Re: [RFC 02/10] mac80211: allow to transmit A-MSDU within A-MPDU
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	sara.sharon@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 21, 2015 at 1:12 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
>
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index c8ba2e7..a758eb84 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -97,7 +97,8 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
>         mgmt->u.action.u.addba_req.action_code = WLAN_ACTION_ADDBA_REQ;
>
>         mgmt->u.action.u.addba_req.dialog_token = dialog_token;
> -       capab = (u16)(1 << 1);          /* bit 1 aggregation policy */
> +       capab = (u16)(1 << 0);          /* bit 0 A-MSDU support */

Shouldn't this be based on HW capability? We can add couple of more
_HW_ flags for TX and RX
and populate this based on that?

>
> +       capab |= (u16)(1 << 1);         /* bit 1 aggregation policy */
>         capab |= (u16)(tid << 2);       /* bit 5:2 TID number */
>         capab |= (u16)(agg_size << 6);  /* bit 15:6 max size of aggergation */
