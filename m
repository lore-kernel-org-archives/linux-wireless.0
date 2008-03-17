Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:43792 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYCQU15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 16:27:57 -0400
Received: by rn-out-0910.google.com with SMTP id v46so3352158rnb.15
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 13:27:56 -0700 (PDT)
Message-ID: <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com> (sfid-20080317_202802_852198_F23DE3E7)
Date: Mon, 17 Mar 2008 22:27:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205784255.16475.33.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 <1205784255.16475.33.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 10:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >
>  > >  > BSS defines security setting which  defined by key management for
>  > >  > pairwise and group key + cipher method for both .
>  > >  > You can run multiple SSIDs over single single BSSID. This is done
>  > >  > using VLANs
>  > >
>  > >  Actually, we don't support that in mac80211.
>  > Last time I worked on AP project it worked. It was older mac hopefully
>  > it's not totally broken
>  >
>  >  And the way I understand
>  > >  VLANs they are simply done by negotiating different group keys with
>  > >  different groups of stations each forming a VLAN.
>  >
>  > We are saying the same. That's okay.
>
>  Well, you were suggesting the use of multiple SSIDs, which we don't
>  support, we only support VLANs within a BSS/single SSID. Not that I've
>  been able to test it, hostapd needs radius stuff set up for VLANs...

I think it's transparent since it's handled by MLME in hostapd so
multiple SSID is supported
Maybe we did some minor changes in mac to support that.. Will check again.
I think it's always done by means of VLANs


>  Right. I was just saying that the way it currently is I think you could
>  detect it that way. b43 simply assumes WEP keys are always 'static'
>  which seems to mostly work well in practice.
>  I suppose then set_key needs a new argument key_type:
>
>  enum ieee80211_key_type {
>         KEY_TYPE_PAIRWISE,
>         KEY_TYPE_GROUP,
>         KEY_TYPE_TXONLY,        /* group key in an AP */

Can we drop it? Hm still not sure why you like it so much.

>         KEY_TYPE_STATIC,
>  }
>
>  where the MAC address pointer would only be non-NULL when the key type
>  is PAIRWISE, and STATIC can only be used for WEP keys.
>


Do you know anything about mesh security are we breaking here anything?

Thanks
Tomas
>  johannes
>
