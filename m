Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33687 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2J2JsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 05:48:12 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so4452111oag.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 02:48:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351501949-20169-1-git-send-email-johannes@sipsolutions.net>
References: <1351501949-20169-1-git-send-email-johannes@sipsolutions.net>
Date: Mon, 29 Oct 2012 11:48:11 +0200
Message-ID: <CAB3XZEeTTAOO1DzPArvaSU-esTFeY7SLAMTkSt5vKD_QScK1vQ@mail.gmail.com> (sfid-20121029_104815_971450_49F36004)
Subject: Re: [RFC] mac80211: send deauth only with channel context
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 29, 2012 at 11:12 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> When userspace asks to deauthenticate and we're just
> authenticated (or still authenticating) send a deauth
> frame instead of deleting the auth request.
>
why send a deauth if we are not authenticated yet?

>         mutex_lock(&sdata->local->mtx);
>         ieee80211_recalc_idle(sdata->local);
>         mutex_unlock(&sdata->local->mtx);
>
> + out:
> +       if (sent_frame)
> +               __cfg80211_send_deauth(sdata->dev, frame_buf,
> +                                      IEEE80211_DEAUTH_FRAME_LEN);
> +

shouldn't the "out" label be before recalcing the idle state?

Eliad.
