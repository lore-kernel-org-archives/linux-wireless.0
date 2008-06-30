Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:56179 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173AbYF3K1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 06:27:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [PATCH 29/33] iwlwifi: drop skb silently for Tx request in monitor mode
Date: Mon, 30 Jun 2008 12:26:49 +0200
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com> <1214817813-17639-30-git-send-email-yi.zhu@intel.com> <69e28c910806300322i5ac6e123h23ed5c0419d087c1@mail.gmail.com>
In-Reply-To: <69e28c910806300322i5ac6e123h23ed5c0419d087c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200806301226.50085.mb@bu3sch.de> (sfid-20080630_122744_885142_64B635C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 30 June 2008 12:22:45 Stefanik G=E1bor wrote:
> On Mon, Jun 30, 2008 at 11:23 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> > This patch fixes the problem to keep mac80211 resubmitting SKBs
> > when Tx request cannot be met in monitor mode.
> >
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
> >  drivers/net/wireless/iwlwifi/iwl4965-base.c |    3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/=
net/wireless/iwlwifi/iwl3945-base.c
> > index 4f0a18a..2744b0a 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -6695,7 +6695,8 @@ static int iwl3945_mac_tx(struct ieee80211_hw=
 *hw, struct sk_buff *skb)
> >
> >        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> >                IWL_DEBUG_MAC80211("leave - monitor\n");
> > -               return -1;
> > +               dev_kfree_skb_any(skb);
> > +               return 0;
> >        }
> >
> >        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->le=
n,
> > diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/=
net/wireless/iwlwifi/iwl4965-base.c
> > index ba0f289..60b7a64 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> > @@ -2682,7 +2682,8 @@ static int iwl4965_mac_tx(struct ieee80211_hw=
 *hw, struct sk_buff *skb)
> >
> >        if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
> >                IWL_DEBUG_MAC80211("leave - monitor\n");
> > -               return -1;
> > +               dev_kfree_skb_any(skb);
> > +               return 0;
> >        }
> >
> >        IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->le=
n,
> > --
> > 1.5.3.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wir=
eless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> NACK.
>=20
> This blocks packet injection for not only 4965/5000, but also 3945.
> Also, I have multiple records of injection working with 4965 cards
> with your original patch.
>=20

This patch fixes a _real_ bug. No matter what your plans for packet inj=
ection
are, it _needs_ to go in for now. You can later change the code to actu=
ally
transmit the frame. There are only two possibilities for the TX handler=
:
Either transmit it or drop it. It must not return an error.


--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
