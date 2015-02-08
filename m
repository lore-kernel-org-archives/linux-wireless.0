Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:37273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbbBHJKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 04:10:07 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ArikX Nemtsov" <arik@wizery.com>
Subject: RE: [PATCH v4 1/2] cfg80211: Add API to change the indoor
	regulatory setting
Date: Sun, 8 Feb 2015 09:10:01 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com> (sfid-20150208_101018_904284_E230D389)
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com>
 <20150206235802.GA19988@wotan.suse.de>
In-Reply-To: <20150206235802.GA19988@wotan.suse.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@suse.com]
> Sent: Saturday, February 07, 2015 01:58
> To: Peer, Ilan
> Cc: linux-wireless@vger.kernel.org; ArikX Nemtsov
> Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor
> regulatory setting
> 
> On Mon, Feb 02, 2015 at 09:59:25AM -0500, Ilan Peer wrote:
> > As the operating environment of a device can change, add API for user
> > space to indicate a change of indoor settings.
> > In addition modify the handling of the indoor processing as
> > follows:
> >
> > 1. Directly update the indoor setting without wrapping it as a
> >    regulatory request.
> 
> Why? We have this present as part of the request as it was part of the
> country IE, that's all. I can see for instance then that it is wise to require the
> supplicant for instance to be still connected to the AP and the socket tracking
> as solution to the problem. Does that summarize the logic ?
> 	

This differs from the country setting that would potentially require user space interaction and might invoke more complex flows. The flow in this case is immediate, and does not require the somewhat complex handling of country settings (it even complicates the flow unnecessarily, with the REG_REQ_USER_HINT_HANDLED etc.).

> > 2. Track the socket on which the indoor hint is issued, and reset
> >    indoor setting if the socket was released. The motivation here is to
> >    force a user space process that sets the indoor setting to constantly
> >    monitor this setting, and be responsible to correctly toggling it,
> >    so indoor operation will not be enabled uncontrolled.
> 
> That seems to imply a new requirement for something that used to work,
> what having an option to set this requirement?

(Sadly) I would not consider the previous implementation as working as it would leave the regulatory core in a state that it considers to be indoor although it is no longer true.

> 
> > 3. Do not reset the indoor setting when restoring the regulatory
> >    settings as it has nothing to do with CRDA or interface
> >    disconnection.
> 
> I disagree, if we disconnect we want the more restrictive setting and if we
> put the indoor setting out of general regulatory requests then we do want to
> reset this no?
> 

I do not think so. This setting is in the responsibility of the user space daemon, so it should be the one controlling it. A disconnection of the station interface does not imply that we are no longer operating in an indoor environment. This also related to #2 above that tightens the responsibility of the user space daemon controlling this setting.

> > Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> > Signed-off-by: ArikX Nemtsov <arik@wizery.com>
> > ---
> >  include/uapi/linux/nl80211.h |  5 +++
> >  net/wireless/nl80211.c       | 10 +++++-
> >  net/wireless/reg.c           | 80 +++++++++++++++++++++++++----------------
> ---
> >  net/wireless/reg.h           | 15 ++++++++-
> >  4 files changed, 73 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/uapi/linux/nl80211.h
> > b/include/uapi/linux/nl80211.h index 68b294e..d80edcc 100644
> > --- a/include/uapi/linux/nl80211.h
> > +++ b/include/uapi/linux/nl80211.h
> > @@ -1739,6 +1739,9 @@ enum nl80211_commands {
> >   *
> >   * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan
> (or a
> >   *	WoWLAN net-detect scan) is started, u32 in seconds.
> > +
> > + * @NL80211_ATTR_REG_INDOOR: flag attribute, if set indicates that the
> device
> > + *      is operating in an indoor environment.
> >   *
> >   * @NUM_NL80211_ATTR: total number of nl80211_attrs available
> >   * @NL80211_ATTR_MAX: highest attribute number currently defined @@
> > -2107,6 +2110,8 @@ enum nl80211_attrs {
> >
> >  	NL80211_ATTR_SCHED_SCAN_DELAY,
> >
> > +	NL80211_ATTR_REG_INDOOR,
> > +
> >  	/* add attributes here, update the policy in nl80211.c */
> >
> >  	__NL80211_ATTR_AFTER_LAST,
> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index
> > 454d7a0..e78b096 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -399,6 +399,7 @@ static const struct nla_policy
> nl80211_policy[NUM_NL80211_ATTR] = {
> >  	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type =
> NLA_FLAG },
> >  	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
> >  	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
> > +	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
> >  };
> >
> >  /* policy for the key attributes */
> > @@ -4955,6 +4956,7 @@ static int parse_reg_rule(struct nlattr *tb[],
> > static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info
> > *info)  {
> >  	char *data = NULL;
> > +	bool is_indoor;
> >  	enum nl80211_user_reg_hint_type user_reg_hint_type;
> >
> >  	/*
> > @@ -4981,7 +4983,8 @@ static int nl80211_req_set_reg(struct sk_buff
> *skb, struct genl_info *info)
> >  		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> >  		return regulatory_hint_user(data, user_reg_hint_type);
> >  	case NL80211_USER_REG_HINT_INDOOR:
> > -		return regulatory_hint_indoor_user();
> > +		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
> > +		return regulatory_hint_indoor(is_indoor, info->snd_portid);
> 
> So we break old functionality ? No bueno.
> 

no bueno, pero necesario.

Previous functionality was not good in terms of regulatory compliance (once indoor was set there was no way to undo it ...), and lacked proper tracking of this setting by user space.

Regards,

Ilan.

