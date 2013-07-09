Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56196 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3GIHRm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 03:17:42 -0400
Received: by mail-bk0-f46.google.com with SMTP id na10so2179034bkb.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 00:17:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373289250-12259-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1373289250-12259-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Date: Tue, 9 Jul 2013 09:17:41 +0200
Message-ID: <CA+BoTQnsDGtAp4n9hYQTjhNZFzsEsaT4qnX_W7hBcutTAZvjYw@mail.gmail.com> (sfid-20130709_091746_317203_678B0DBC)
Subject: Re: [PATCHv3 4/5] mac80211: add channel switch command and beacon callbacks
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

On 8 July 2013 15:14, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> +static int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
> +                                   struct cfg80211_csa_settings *params)
> +{
> +       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +       struct ieee80211_local *local = sdata->local;
> +       struct ieee80211_chanctx_conf *chanctx_conf;
> +       struct ieee80211_chanctx *chanctx;
> +       int err;
> +
> +       if (!list_empty(&local->roc_list) || local->scanning)
> +               return -EBUSY;
> +
> +       if (sdata->wdev.cac_started)
> +               return -EBUSY;
> +
> +       /* don't handle if chanctx is used */
> +       if (local->use_chanctx)
> +               return -EBUSY;
> +
> +       rcu_read_lock();
> +       chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> +       if (!chanctx_conf) {
> +               rcu_read_unlock();
> +               return -EBUSY;
> +       }
> +
> +       /* don't handle for multi-VIF cases */
> +       chanctx = container_of(chanctx_conf, struct ieee80211_chanctx, conf);
> +       if (chanctx->refcount > 1) {
> +               rcu_read_unlock();
> +               return -EBUSY;
> +       }
> +       rcu_read_unlock();

I'm wondering if it's a huge hassle to support drivers that depend on
channel context API? Perhaps local->open_count could be used instead
of local->use_chantx and chanctx->refcount?

I'm also worried this can possibly do silly things if someone starts
an interface while CSA is under way. Consider the following:

 * start AP
 * initiate channel switch
  [ while channel switch is in progress and driver is yet to call
ieee80211_csa_finish() ]
 * start another STA interface and associate
  [ CSA completes ]

Upon CSA completion the STA will be moved to a different channel
silently and most likely end up with a beacon loss quickly. I think
mac80211 should forbid bringing up any new interfaces during CSA.

It seems there's nothing preventing from multiple calls to channel
switch callback. Is this expected? Can this work if CSA is invoked
while other CSA is still in progress?


Pozdrawiam / Best regards,
Micha³ Kazior.
