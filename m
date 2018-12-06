Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDE3C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 07:25:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD98120645
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 07:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD98120645
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbeLFHZq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 02:25:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60998 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbeLFHZq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 02:25:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gUo2Z-0008Ai-A5; Thu, 06 Dec 2018 08:25:43 +0100
Message-ID: <0d60ddc1367ab8e82811898b13e4d990794c9118.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 1/2] nl80211/cfg80211: Add support for Extended
 Key ID
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 06 Dec 2018 08:25:42 +0100
In-Reply-To: <a2d2f2ff-f776-93e8-579a-fbc05f236d76@wetzel-home.de>
References: <20181111110235.14213-1-alexander@wetzel-home.de>
         <20181111110235.14213-2-alexander@wetzel-home.de>
         <471c7131e4b81a06f8c514652038d69819ae66ea.camel@sipsolutions.net>
         <a2d2f2ff-f776-93e8-579a-fbc05f236d76@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-12-05 at 21:54 +0100, Alexander Wetzel wrote:
> 
> It started out as a flag and I switched to enum later without updating 
> it. I'll chnage that to nl80211_key_install_mode, much much better...

> No, all stations using Extended Key ID will always use RX_ONLY and 
> SET_TX for pairwise key installs. The AP will install the Key Rx only 
> prior to sending eapol #3, the sta prior to sending eapol #4.

Actually ... let's see all the operations at nl80211 level.

We have NEW_KEY and SET_KEY, right? SET_KEY basically already says to
use a given key for TX from now on, IIRC?

So realistically, don't we only need

NEW_KEY (RX-only)

as a new variant of NEW_KEY?

> The PTK0 rekey patch added a new line in front of the description. The 
> next author did not notice that and added the description for 
> NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER at the wrong place, probably 
> assuming it was the end of the list. I've noticed that and fixed the 
> documentation order and the misleading empty line.
> I'll break that out as a separate cleanup patch if nobody beats me to it:-)

Oh. OK. It also doesn't really matter ;-)

> > >   		k->def_multi = true;
> > >   
> > > +	k->rx_only = !!info->attrs[NL80211_ATTR_KEY_RXONLY];
> > > +	k->set_tx = !!info->attrs[NL80211_ATTR_KEY_SETTX];
> > 
> > shouldn't this already be install_mode?
> > 
> 
> Looks like switching to NL80211_ATTR_INSTALL_MODE will throw out that, 
> but with the code from this patch that's an interim layer for checks and 
> mapping it. So I'm not sure I understand that comment.

Well, me neither. Sounds almost like I got ahead of myself.

> > You need to check if extended key ID is supported
> 
> Yes. I have added checks in cfg80211_validate_key_settings current 
> development version already, making sure only valid combinations can be 
> called and reach this section.

Ok, great.

> NL80211_CMD_SET_KEY is normally only used to set default keys for wep or 
> managment keys. That changes here.

Right.

> In this API draft NL80211_CMD_NEW_KEY is only used when installing a 
> Extended Key ID key RX only. The switch to TX is added to 
> NL80211_CMD_SET_KEY. The code has some sanity checks and then tells the 
> driver to switch the key to tx.

Makes sense.

> But that has been changed quite a bit, the procedure in this patch 
> turned out to be not so good and even had a locking issue, so it has 
> changed a bit. I guess we should shelf that till I get the new variant 
> working and then look at it again.

Fair enough.

> > > +++ b/net/wireless/util.c
> > > @@ -236,13 +236,14 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
> > >   	case WLAN_CIPHER_SUITE_CCMP_256:
> > >   	case WLAN_CIPHER_SUITE_GCMP:
> > >   	case WLAN_CIPHER_SUITE_GCMP_256:
> > > -		/* Disallow pairwise keys with non-zero index unless it's WEP
> > > +		/* IEEE802.11-2016 allows only 0 and 1 for pairwise keys.
> > > +		 * Disallow pairwise keys with index above 1 unless it's WEP
> > >   		 * or a vendor specific cipher (because current deployments use
> > > -		 * pairwise WEP keys with non-zero indices and for vendor
> > > +		 * pairwise WEP keys with higher indices and for vendor
> > >   		 * specific ciphers this should be validated in the driver or
> > > -		 * hardware level - but 802.11i clearly specifies to use zero)
> > > +		 * hardware level.
> > >   		 */
> > > -		if (pairwise && key_idx)
> > > +		if (pairwise && key_idx > 1)
> > >   			return -EINVAL;
> > >   		break;
> > 
> > Again, only if driver support is advertised, and the comment should
> > probably reference the feature bit from the spec.
> 
> That is where I added most of the sanity checks in the meantime.
> But what feature bit from the spec are you referring to? The RSN 
> Capability one?

Well, I wasn't thinking that precisely. I just thought it should mention
that it now says "IEEE802.11-2016 allows only 0 and 1 for pairwise keys"
but doesn't clarify that this is only for stations that actually want to
support it, so it could be read as being always that way.

johannes

