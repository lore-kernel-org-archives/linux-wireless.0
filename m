Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab0CWQtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 12:49:22 -0400
Date: Tue, 23 Mar 2010 17:47:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
Message-ID: <20100323164706.GB3166@dhcp-lab-161.englab.brq.redhat.com>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com> <1269348417-4081-2-git-send-email-sgruszka@redhat.com> <43e72e891003230918g2e662957vd9bce29d36f3f334@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <43e72e891003230918g2e662957vd9bce29d36f3f334@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 23, 2010 at 09:18:33AM -0700, Luis R. Rodriguez wrote:
> On Tue, Mar 23, 2010 at 5:46 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-core.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> > index 112149e..f1729ca 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> > @@ -2410,6 +2410,15 @@ void iwl_bss_info_changed(struct ieee80211_hw *hw,
> >                priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
> >        }
> >
> > +       if (changes & BSS_CHANGED_QOS) {
> > +               unsigned long flags;
> > +
> > +               spin_lock_irqsave(&priv->lock, flags);
> > +               priv->qos_data.qos_active = bss_conf->qos_disabled ? 0 : 1;
> > +               iwl_activate_qos(priv, 1);
> > +               spin_unlock_irqrestore(&priv->lock, flags);
> > +       }
> > +
> >        if (changes & BSS_CHANGED_BEACON_INT) {
> >                priv->beacon_int = bss_conf->beacon_int;
> >                /* TODO: in AP mode, do something to make this take effect */
> 
> What happened without this BTW, did it not associate?
Associate, but after a short time, when any QoS frame is sent,
AP disassociate with MIC error.

> What AP was it?
Sitecom 161.

> Did you get to test with other drivers by chance?
rt73usb work well with that AP without any patches. I have also
rt2800usb, but it not work with any  AP's I have :(

Stanislaw
