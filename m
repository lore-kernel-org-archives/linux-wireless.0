Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:50308 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759958AbXJ2Sx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 14:53:57 -0400
Received: by py-out-1112.google.com with SMTP id u77so3054272pyb
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2007 11:53:55 -0700 (PDT)
Message-ID: <f6ca9fed0710291153o68ec2cffqbd2cc3f6d57fa11b@mail.gmail.com> (sfid-20071029_185503_531685_3A2F5413)
Date: Mon, 29 Oct 2007 19:53:54 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwl3945 lists supported rates backwards
Cc: "Pavel Roskin" <proski@gnu.org>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <1193677748.5197.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1192832109.19766.14.camel@dv> <47192F84.1020101@lwfinger.net>
	 <20071020014040.40pq9hqkw0c4owc8@webmail.spamcop.net>
	 <4719BA96.3010609@gmail.com> <1193644281.27622.12.camel@dv>
	 <1193667153.5197.48.camel@johannes.berg> <1193677095.11181.2.camel@dv>
	 <1193677748.5197.77.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -5414,10 +5414,10 @@ static int iwl_init_geos(struct iwl_priv *priv)
> >        * is supported by a mode -- and the first match is taken
> >        */
> >
> > -     if (modes[G].num_channels)
> > -             ieee80211_register_hwmode(priv->hw, &modes[G]);
> >       if (modes[B].num_channels)
> >               ieee80211_register_hwmode(priv->hw, &modes[B]);
> > +     if (modes[G].num_channels)
> > +             ieee80211_register_hwmode(priv->hw, &modes[G]);
> >       if (modes[A].num_channels)
> >               ieee80211_register_hwmode(priv->hw, &modes[A]);
>
> Huh no, you misunderstood my mail.
>
> This makes mac80211 always select 802.11B mode which is not what you
> want. You want to change the order of rates within the G mode.
>

shouldn't this one do it?
 (untested)

---
diff --git a/origin/iwl-3945-rs.h b/origin/iwl-3945-rs.h
index 09fa1a7..18b19a2 100644
--- a/origin/iwl-3945-rs.h
+++ b/origin/iwl-3945-rs.h
@@ -39,7 +39,11 @@ struct iwl_rate_info {
 };

 enum {
-       IWL_RATE_6M_INDEX = 0,
+       IWL_RATE_1M_INDEX = 0,
+       IWL_RATE_2M_INDEX,
+       IWL_RATE_5M_INDEX,
+       IWL_RATE_11M_INDEX,
+       IWL_RATE_6M_INDEX,
        IWL_RATE_9M_INDEX,
        IWL_RATE_12M_INDEX,
        IWL_RATE_18M_INDEX,
@@ -47,10 +51,6 @@ enum {
        IWL_RATE_36M_INDEX,
        IWL_RATE_48M_INDEX,
        IWL_RATE_54M_INDEX,
-       IWL_RATE_1M_INDEX,
-       IWL_RATE_2M_INDEX,
-       IWL_RATE_5M_INDEX,
-       IWL_RATE_11M_INDEX,
        IWL_RATE_COUNT,
        IWL_RATE_INVM_INDEX,
        IWL_RATE_INVALID = IWL_RATE_INVM_INDEX
