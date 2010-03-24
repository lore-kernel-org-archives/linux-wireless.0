Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:55958 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab0CXQG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 12:06:59 -0400
Subject: Re: [PATCH 2/2] iwlwifi: implement disabling/enabling QoS
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1269449068.22705.7.camel@wwguy-ubuntu>
References: <1269348417-4081-1-git-send-email-sgruszka@redhat.com>
	 <1269348417-4081-2-git-send-email-sgruszka@redhat.com>
	 <1269364886.9689.4.camel@jlt3.sipsolutions.net>
	 <1269449068.22705.7.camel@wwguy-ubuntu>
Content-Type: text/plain
Date: Wed, 24 Mar 2010 10:03:29 -0700
Message-Id: <1269450209.22705.10.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2010-03-24 at 09:44 -0700, Guy, Wey-Yi wrote:
> Hi Stanislaw,
>  
> On Tue, 2010-03-23 at 10:21 -0700, Johannes Berg wrote:
> > On Tue, 2010-03-23 at 13:46 +0100, Stanislaw Gruszka wrote:
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > 
> > This really could use "more" text as to why etc.
> > 
> > > +	if (changes & BSS_CHANGED_QOS) {
> > > +		unsigned long flags;
> > > +
> > > +		spin_lock_irqsave(&priv->lock, flags);
> > > +		priv->qos_data.qos_active = bss_conf->qos_disabled ? 0 : 1;
> > > +		iwl_activate_qos(priv, 1);
> > > +		spin_unlock_irqrestore(&priv->lock, flags);
> > > +	}
> > 
> > This seems alright, but we really need to revisit that since there's a
> > lot of odd logic in iwlwifi that makes some sense based on this now but
> > could probably be simplified now. I'll close with Wey-Yi, she worked on
> > QoS here at some point I think.
> > 
> If I understand correctly, the current implementation has problem, by
> just calling iwl_activate_qos(), it did not have the AC setup correctly,
> take a look at the iwl_reset_qos(), it is the only place initialize the
> table, for STA mode, QoS is de-active by default. iwl_activate_qos()
> only change the qos flag, but did not re-initialize the table to proper
> value. 
> 
> Thanks
> Wey
> 
look at it again, please ignore my previous email, mac80211 will send
config_tx which make the ac table correct, so just call
iwl_activate_qos() should be ok.

Thanks
Wey

> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

