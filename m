Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60233 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaCLN0T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 09:26:19 -0400
Received: by mail-oa0-f47.google.com with SMTP id i11so10137813oag.34
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 06:26:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394629569-13798-4-git-send-email-luciano.coelho@intel.com>
References: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com>
	<1394629569-13798-4-git-send-email-luciano.coelho@intel.com>
Date: Wed, 12 Mar 2014 14:26:18 +0100
Message-ID: <CA+BoTQn2qKnSrZxKzO+2OeDEhRRk-o=WgpHsDzOWveGVXnOmsg@mail.gmail.com> (sfid-20140312_142621_946893_3083146E)
Subject: Re: [PATCH v7 3/4] mac80211: implement chanctx reservation
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 March 2014 14:06, Luciano Coelho <luciano.coelho@intel.com> wrote:

[...]

> +       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
> +               tmp_changed |= BSS_CHANGED_BANDWIDTH;
> +
> +       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;

> +
> +       /* unref our reservation before assigning */
> +       ctx->refcount--;
> +       sdata->reserved_chanctx = NULL;
> +
> +       if (old_ctx == ctx) {
> +               /* This is our own context, just change it */
> +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> +                                                    &tmp_changed);
> +               if (ret)
> +                       goto out;
> +       } else {

> +               if (sdata->vif.bss_conf.chandef.width !=
> +                   sdata->reserved_chandef.width)
> +                       tmp_changed |= BSS_CHANGED_BANDWIDTH;
> +
> +               sdata->vif.bss_conf.chandef = sdata->reserved_chandef;

You're already doing this a few lines earlier, before branching.


Michał
