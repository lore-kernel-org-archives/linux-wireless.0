Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55907 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0LBG5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 01:57:31 -0500
Subject: Re: [RFC 5/5] cfg80211/mac80211: add mesh join/leave commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
In-Reply-To: <AANLkTin==aJjY4Sctu1+g7bitDsd6S14SKRymrNW_WLy@mail.gmail.com>
References: <20101201205939.009530439@sipsolutions.net>
	 <20101201210226.159495600@sipsolutions.net>
	 <AANLkTin==aJjY4Sctu1+g7bitDsd6S14SKRymrNW_WLy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 07:57:27 +0100
Message-ID: <1291273047.3481.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-01 at 16:23 -0800, Javier Cardona wrote:

> +static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
> +{
> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +       struct net_device *dev = info->user_ptr[1];
> +       struct mesh_config cfg;
> +       int err;
> +
> +       /* start with default */
> +       memcpy(&cfg, &default_mesh_config, sizeof(cfg));
> +
> +       /* and parse other given info */
> +       err = nl80211_parse_mesh_params(info, &cfg, NULL);
> +       if (err)
> +               return err;
> 
> Only the mesh id should be mandatory for starting the mesh, and none
> of the other mesh parameters.  Therefore I would change the above to:
> 

> +       if (info->attrs[NL80211_ATTR_MESH_PARAMS]) {
> +               err = nl80211_parse_mesh_params(info, &cfg, NULL);
> +               if (err)
> +                       return err;
> +       }

Good point.

> +               case NL80211_IFTYPE_MESH_POINT:
> +                       /* backward compat code ... */
> +                       if (wdev->ssid_len)
> +                               __cfg80211_join_mesh(rdev, dev, wdev->ssid,
> +                                                    wdev->ssid_len, NULL);
> +
> 
> This doesn't quite work:  when mesh interfaces are created with a mesh
> id you set wdev->ssid_len.
> Later, when the interface is brought up, the mesh won't start because
> of the last check below:

Oops, good catch.

> If you want to keep working on this we'll be happy to test it again,
> or if you want we can take it from here and finish this.
> Let me know.

I'll finish it, shouldn't be too much.

> > I just noticed that this will lose mesh parameters when you leave the
> > mesh, unlike previously where they would be kept.
> 
> ...I don't think there's an issue.  I'll ask around.

Ok, I'll leave it as is for now.

Regarding this I also noticed something else: there's a bug still in the
patch -- if you attempt to set mesh parameters on an interface that's
down it'll go through to mac80211, but then the parameters will just be
overwritten upon joining. Clearly, that's not desirable, but I'm not
sure whether we need the ability to update mesh parameters while the
interface isn't joined to a mesh?

johannes

