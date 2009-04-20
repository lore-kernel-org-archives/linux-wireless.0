Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10173 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755959AbZDTUwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 16:52:13 -0400
Subject: Re: WARN on return of ieee80211_if_config
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1240252511.4632.17.camel@johannes.local>
References: <1240252271.5206.63.camel@rc-desk>
	 <1240252511.4632.17.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 13:58:16 -0700
Message-Id: <1240261096.5206.107.camel@rc-desk> (sfid-20090420_225217_945805_7449ED00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Mon, 2009-04-20 at 11:35 -0700, Johannes Berg wrote:
> Hi Reinette,
> 
> > In 2.6.30 we are starting to see people encountering a WARN when
> > resuming with HW rfkill enabled. The WARN is printed from
> > net/mac80211/pm.c:159 in 2.6.30, for current wireless-testing it is 
> > net/mac80211/util.c:1050.
> 
> Hmm, ok, that makes sense.
> 
> > With that function resuming multiple interfaces I do not know if it will
> > make sense to return an error code if one fails. So, it seems that
> > __ieee80211_resume()/ieee80211_reconfig() will always return zero. Even
> > so, the case where ieee80211_if_config() fails needs to be
> > accommodated. 
> > 
> > Would something like this make sense?
> > 
> > diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
> > index 0273023..46f2961 100644
> > --- a/net/mac80211/pm.c
> > +++ b/net/mac80211/pm.c
> > @@ -156,8 +156,11 @@ int __ieee80211_resume(struct ieee80211_hw *hw)
> >  		case NL80211_IFTYPE_ADHOC:
> >  		case NL80211_IFTYPE_AP:
> >  		case NL80211_IFTYPE_MESH_POINT:
> > -			WARN_ON(ieee80211_if_config(sdata, changed));
> > -			ieee80211_bss_info_change_notify(sdata, ~0);
> > +			if (ieee80211_if_config(sdata, changed))
> > +				printk(KERN_DEBUG "%s: failed to configure interface\n",
> > +				       sdata->dev->name);
> > +			else
> > +				ieee80211_bss_info_change_notify(sdata, ~0);
> 
> Not sure. That doesn't seem to make sense anyway, since iwlwifi does
> this:
> 
>         if (iwl_is_rfkill(priv))
>                 goto done;
> ...
>  done:
> ...
> 	return 0;
> 
> 
> Or will this test:
>         if (!iwl_is_alive(priv))
>                 return -EAGAIN;
> 
> kick us out before even getting to the rfkill test?

Yes ... and it is not immediately clear that it is caused by rfkill. The
STATUS_ALIVE bit that is tested here is cleared when machine is
suspended. When machine is resumed and HW rfkill is set then it will not
come up fully, see __iwl_up() that returns early with success if rfkill
is enabled. STATUS_ALIVE will only be set again after HW rfkill is
disabled and we initialize ucode again.

Reinette




