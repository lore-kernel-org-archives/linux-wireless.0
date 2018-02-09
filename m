Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41810 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752483AbeBITlf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 14:41:35 -0500
Message-ID: <1518205292.4047.0.camel@sipsolutions.net> (sfid-20180209_204139_375397_19845295)
Subject: Re: [PATCH] mac80211: round IEEE80211_TX_STATUS_HEADROOM up to
 multiple of 4
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Fri, 09 Feb 2018 20:41:32 +0100
In-Reply-To: <5A7DF237.9020803@broadcom.com> (sfid-20180209_201049_187355_A2F49113)
References: <20180209185100.22511-1-nbd@nbd.name>
         <5A7DF237.9020803@broadcom.com> (sfid-20180209_201049_187355_A2F49113)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2018-02-09 at 20:10 +0100, Arend van Spriel wrote:
> 
> > @@ -4149,7 +4149,7 @@ void ieee80211_sta_uapsd_trigger(struct ieee80211_sta *sta, u8 tid);
> >    * The TX headroom reserved by mac80211 for its own tx_status functions.
> >    * This is enough for the radiotap header.
> 
> Hi Felix,
> 
> Maybe useful to mention the alignment requirement in this comment block.
> 
> >    */
> > -#define IEEE80211_TX_STATUS_HEADROOM	14
> > +#define IEEE80211_TX_STATUS_HEADROOM	16
> 
Or better yet, just define it as ALIGN(14, 4) ?

johannes
