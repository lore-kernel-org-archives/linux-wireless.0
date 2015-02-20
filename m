Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55772 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbbBTAxr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 19:53:47 -0500
Date: Fri, 20 Feb 2015 01:53:44 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Peer, Ilan" <ilan.peer@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ArikX Nemtsov <arik@wizery.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] cfg80211: Add API to change the indoor
	regulatory setting
Message-ID: <20150220005344.GF20824@wotan.suse.de> (sfid-20150220_015405_215605_947A0854)
References: <1422889166-29386-1-git-send-email-ilan.peer@intel.com> <20150206235802.GA19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D01068E@HASMSX106.ger.corp.intel.com> <20150210200027.GG19988@wotan.suse.de> <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CB3B3D4774441E42AA3EA0E1BA8230A04D017CEB@HASMSX106.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wider community:

anyone aware of any *need* in the kernel to know whether one is indoor or
not on a device running Linux other than wifi? Clearly it should be something
that might be of interest to at least other RF devices, so that is at least
one possibilty to consider already, but what else?

On Sun, Feb 15, 2015 at 12:26:04PM +0000, Peer, Ilan wrote:
> Hi Luis,
> 
> > >
> > > This differs from the country setting that would potentially require
> > > user space interaction and might invoke more complex flows. The flow
> > > in this case is immediate, and does not require the somewhat complex
> > > handling of country settings (it even complicates the flow
> > > unnecessarily, with the REG_REQ_USER_HINT_HANDLED etc.).
> > 
> > There's two things you should address then:
> > 
> >   0) Try to mitigate the issue with the old userspace API if possible.
> >      This will enable old userspace to continue to work with the
> >      old API but also mitigate the issue you have described for which
> >      you are providing a new optimized solution for but that requires
> >      a new API.
> > 
> 
> Not sure I have a good solution for this. The problem here is that with the
> current API, the indoor setting will stick as long as a station interface is
> connected, although the indoor setting might no longer be true. For example
> when a station interface is connected to P2P GO (or a soft AP) and both
> devices are moving out of the indoor environment. The motivation for this
> patch was to move the full control of this setting to user space.
>
> Any suggestion are welcomed.

Why not just clear it upon disconnect for the old case? It seems that would
be better if that is better regulatory wise.

> 
> >   1) With the new API have userspace be able to send to the kernel that
> >      userspace will do socket monitoring and because of this and the
> >      reasons you mentioned it will have more control over the environment
> >      boolean.
> > 
> 
> Ok. Will add such an API.

Great.

> > > > > 2. Track the socket on which the indoor hint is issued, and reset
> > > > >    indoor setting if the socket was released. The motivation here is to
> > > > >    force a user space process that sets the indoor setting to constantly
> > > > >    monitor this setting, and be responsible to correctly toggling it,
> > > > >    so indoor operation will not be enabled uncontrolled.
> > > >
> > > > That seems to imply a new requirement for something that used to
> > > > work, what having an option to set this requirement?
> > >
> > > (Sadly) I would not consider the previous implementation as working as
> > > it would leave the regulatory core in a state that it considers to be
> > > indoor although it is no longer true.
> > 
> > Let's review the current implementation for indoor thing.
> > 
> > We assume we're not indoor unless userspace sends a
> > regulatory_hint_indoor_user(), this is with the user reg hint type set to
> > NL80211_USER_REG_HINT_INDOOR.
> > For country IEs we never trust the country IE data since it may contain bogus
> > data, but we also end up ignoring the environment aspect too.
> > 
> > If we disconnect we should be reseting the indoor setting to false.
> > I just checked and restore_regulatory_settings() does set reg_is_indoor =
> > false so if we are keeping the indoor setting I am missing something here, and
> > it does indeed rather an issue that should be fixed. Where is the indoor
> > setting being upkept?
> > 
> 
> This is generally true, but is not fully compatible with moving APs/P2P GOs,
> where you can be indoor, connect to an AP/P2P GO, and then move out of the
> indoor environment, while connected. Point is the being connected does not
> guarantee that the indoor setting is kept. 

Ah so then the above description does satisfy the concern you stated.
What you are describing *now* is a dynamic environment new requirement.

That's a very different picture than what you originally stated and
your commit message does not clarify what worked and what really are
the issue well. As it stands your changes will be an ammendment to
help with dynamic environment setting, and it will also enable environment
options to remain post disconnect.

> > > > > 3. Do not reset the indoor setting when restoring the regulatory
> > > > >    settings as it has nothing to do with CRDA or interface
> > > > >    disconnection.
> > > >
> > > > I disagree, if we disconnect we want the more restrictive setting
> > > > and if we put the indoor setting out of general regulatory requests
> > > > then we do want to reset this no?
> > > >
> > >
> > > I do not think so. This setting is in the responsibility of the user
> > > space daemon, so it should be the one controlling it.
> > 
> > Right now the API requires sending the userspace regulatory hint and the
> > kenrel should indeed reset to non-indoor upon disconnect, the later is an
> > issue which should be fixed and what you introduce seems rather complex for
> > something that should be fixed within the existing API.
> > 
> 
> The kernel does not have enough information to deduce indoor environment or
> not (as pointed above), only user space has the full information in this
> case, and should be responsible for controlling the setting.

Do you forsee other sources to override the socket information? What about
a disconnect, will that kill the socket setting too? What about a future
feature, say something generic in the kernel?

> > > A disconnection of the
> > > station interface does not imply that we are no longer operating in an
> > > indoor environment.
> > 
> > I am confused you seem to be disagreeing with your above statement that
> > says otherwise where you said that we leave the indoor setting in place if we
> > disconnect. Can you clarify what you mean?
> > 
> 
> What I meant is that a disconnection of the station interface does not imply
> that we are no longer operating in an indoor environment.

Sure.

> For example, in an
> enterprise environment, disconnections/reconnection would happen all the time
> due to roaming etc., but in all this cases that device indoor setting would
> continue to be true. 

Sure.

> > Do you mean that you don't wish to fix it so that upon disconnect we never
> > get an indoor setting and instead prefer this to be a matter of socket
> > monitoring?
> > 
> 
> What I mean is that I want to make it the responsibility of the user space
> and not be depended on kernel wifi flows.

OK

> > > This also related to #2 above that tightens the responsibility of the
> > > user space daemon controlling this setting.
> > 
> > This smells like an optimization feature.
> > 
> > > > > @@ -4981,7 +4983,8 @@ static int nl80211_req_set_reg(struct
> > > > > sk_buff
> > > > *skb, struct genl_info *info)
> > > > >  		data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
> > > > >  		return regulatory_hint_user(data, user_reg_hint_type);
> > > > >  	case NL80211_USER_REG_HINT_INDOOR:
> > > > > -		return regulatory_hint_indoor_user();
> > > > > +		is_indoor = !!info->attrs[NL80211_ATTR_REG_INDOOR];
> > > > > +		return regulatory_hint_indoor(is_indoor, info->snd_portid);
> > > >
> > > > So we break old functionality ? No bueno.
> > > >
> > >
> > > no bueno, pero necesario.
> > >
> > > Previous functionality was not good in terms of regulatory compliance
> > > (once indoor was set there was no way to undo it ...),
> > 
> > As I noted restore_regulatory_settings() does set reg_is_indoor = false so
> > what is missing?
> > 
> 
> Hope I clarified this above.

You did and it confirms my suspicion that this is an optimization.
You need to sell it as such and most importantly document this
very well.

> > > and lacked proper tracking of this setting by user space.
> > 
> > This seems like an optimization that you want and if you do wish to add that I'd
> > recommend NL80211_USER_REG_HINT_INDOOR_SOCK_MONITOR
> > and document as a feature which allows the interpretation you noted but you
> > must first address the issue with the existing API as I'm failing to see where we
> > fail to reset the regulatory setting for indoor.
> > 
> 
> Sure. I'll extend this with requested flag or similar. 
> 
> Thanks again Luis (and sorry for the delayed response).

Likewise,

  Luis
