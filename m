Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0JYIPs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 04:15:48 -0400
Date: Mon, 25 Oct 2010 10:18:44 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] iwlwifi: defer update power mode while scan
Message-ID: <20101025081842.GA2343@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
 <1287759870-5758-6-git-send-email-sgruszka@redhat.com>
 <1287761637.8143.3.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1287761637.8143.3.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Fri, Oct 22, 2010 at 08:33:57AM -0700, Guy, Wey-Yi wrote:
> On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> > -int iwl_power_update_mode(struct iwl_priv *priv, bool force)
> > +static void iwl_power_build_cmd(struct iwl_priv *priv,
> > +				struct iwl_powertable_cmd *cmd)
> >  {
> > -	int ret = 0;
> >  	bool enabled = priv->hw->conf.flags & IEEE80211_CONF_PS;
> > -	bool update_chains;
> > -	struct iwl_powertable_cmd cmd;
> >  	int dtimper;
[snip]
> >  	if (priv->cfg->base_params->broken_powersave)
> > -		iwl_power_sleep_cam_cmd(priv, &cmd);
> > +		iwl_power_sleep_cam_cmd(priv, cmd);
> Is this right?

Yes, patch change "cmd" to be a pointer anywhere in this function.

Stanislaw
