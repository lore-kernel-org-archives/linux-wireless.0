Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.233]:9438 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbXLTAJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 19:09:00 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1689952nze.1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2007 16:08:59 -0800 (PST)
Message-ID: <1ba2fa240712191608oa7f36e9ma05a04b4797d715a@mail.gmail.com> (sfid-20071220_000902_798350_66859B83)
Date: Thu, 20 Dec 2007 02:08:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH] iwlwifi: proper monitor support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1ba2fa240712191604l1f5343c0s62e66aaf2077cce1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1198052938-25637-1-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240712191604l1f5343c0s62e66aaf2077cce1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 20, 2007 2:04 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Dec 19, 2007 10:28 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > This patch changes the iwlwifi driver to properly support
> > monitor interfaces after the filter flags change.
> >
> > The patch is originally created by Johannes Berg for iwl4965. I fixed some
> > of the comments and created a similar patch for iwl3945.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945.c     |  118 ++++++++++++++++++++++----
> >  drivers/net/wireless/iwlwifi/iwl-3945.h     |   36 +++------
> >  drivers/net/wireless/iwlwifi/iwl-4965.c     |  120 ++++++++++++++++++++++++--
> >  drivers/net/wireless/iwlwifi/iwl-4965.h     |   24 +-----
> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |  109 +++----------------------
> >  drivers/net/wireless/iwlwifi/iwl4965-base.c |   90 +--------------------
> >  6 files changed, 236 insertions(+), 261 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > index 7d15b33..07fa363 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > @@ -35,9 +35,9 @@
> >
> > +static void iwl4965_add_radiotap(struct iwl4965_priv *priv,
> > +                                struct sk_buff *skb,
> > +                                struct iwl4965_rx_phy_res *rx_start,
> > +                                struct ieee80211_rx_status *stats,
> > +                                u32 ampdu_status)
> > +{
> > +       s8 signal = stats->ssi;
> > +       s8 noise = 0;
> > +       int rate = stats->rate;
> > +       u64 tsf = stats->mactime;
> > +       __le16 phy_flags_hw = rx_start->phy_flags;
> > +       struct iwl4965_rt_rx_hdr {
> > +               struct ieee80211_radiotap_header rt_hdr;
> > +               __le64 rt_tsf;          /* TSF */
> > +               u8 rt_flags;            /* radiotap packet flags */
> > +               u8 rt_rate;             /* rate in 500kb/s */
>
> You probably wants to have u32 value to accommodate HT rates (MCS)

I've made a mistake this is not logical but actual rate so it
theoretically we can go up to 600Mbs so it will make it 120 < 256.
But aren't we interested in MSC rate a packet was sent?

> > +               __le16 rt_channelMHz;   /* channel in MHz */
>
> > +               __le16 rt_chbitmask;    /* channel bitfield */
> > +               s8 rt_dbmsignal;        /* signal in dBm, kluged to signed */
> > +               s8 rt_dbmnoise;
> > +               u8 rt_antenna;          /* antenna number */
> > +       } __attribute__ ((packed)) *iwl4965_rt;
> > +
> > +       /*
> Tomas
>
