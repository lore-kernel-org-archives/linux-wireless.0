Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35124 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbbH2WZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Aug 2015 18:25:33 -0400
Received: by igcrd18 with SMTP id rd18so6053179igc.0
        for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2015 15:25:33 -0700 (PDT)
Date: Sat, 29 Aug 2015 18:25:31 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k@lists.infradead.org
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
Message-ID: <20150829222531.GA8604@localhost> (sfid-20150830_002538_049613_09FEBDA2)
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
 <1440673024-13696-4-git-send-email-me@bobcopeland.com>
 <CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 29, 2015 at 01:11:03PM -0400, Jason Andryuk wrote:
> Is there a reason to hide rawmode behind a modparam, or should the
> modparam just be removed?  Just let the driver set
> ATH10K_FLAG_RAW_MODE when ATH10K_FW_FEATURE_RAW_MODE_SUPPORT is
> detected?

Yes: you don't want to enable raw mode TX / RX decap in the normal
case because it's fairly inefficient compared to "native" wifi mode,
according to my understanding.  The latter doesn't support mesh framing
however.

> Does struct ieee80211_iface_limit need to be conditional on firmware
> support as well or does interface_modes (below) gate use of
> MESH_POINT?

If you advertise a combination that isn't supported by interface modes,
I believe you'll get a kernel warning when the wiphy is registered.

> 
> > @@ -6998,7 +7020,8 @@ int ath10k_mac_register(struct ath10k *ar)
> >
> >         ar->hw->wiphy->interface_modes =
> >                 BIT(NL80211_IFTYPE_STATION) |
> > -               BIT(NL80211_IFTYPE_AP);
> > +               BIT(NL80211_IFTYPE_AP) |
> > +               BIT(NL80211_IFTYPE_MESH_POINT);
> 
> Set BIT(NL80211_IFTYPE_MESH_POINT) conditionally if ATH10K_FLAG_RAW_MODE is set?

Yes, this was discussed on the ath10k mailing list and I'll probably do
it in a follow-up patch.  It is a little messy because it will involve
casting away a const somewhere.

-- 
Bob Copeland %% http://bobcopeland.com/
