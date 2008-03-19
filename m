Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:35740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858AbYCSTmM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:42:12 -0400
Received: by wa-out-1112.google.com with SMTP id v27so604656wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Mar 2008 12:42:09 -0700 (PDT)
Message-ID: <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com> (sfid-20080319_194443_491965_B23B687C)
Date: Wed, 19 Mar 2008 20:41:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Emmanuel Grumbach" <egrumbach@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080319173922.GB5308@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205761758.1614.79.camel@johannes.berg>
	 <1205781593.16475.20.camel@johannes.berg>
	 <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com>
	 <1205784255.16475.33.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu>
	 <1205831880.16475.43.camel@johannes.berg>
	 <20080318102344.GG5308@jm.kir.nu>
	 <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com>
	 <20080319173922.GB5308@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2008 at 7:39 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Mar 19, 2008 at 06:42:43PM +0200, Emmanuel Grumbach wrote:
>
>  > I ran some tests with the following configuration of wpa_supplicant:
>
> >         key_mgmt=NONE
>  >         group=WEP104
>  >         wep_key0=123456789A123456789A12345A
>  >         wep_key1=123456789A123456789A12345B
>  >         wep_key2=123456789A123456789A12345C
>  >         wep_key3=123456789A123456789A12345D
>  >         wep_tx_keyidx=2
>
>  > From what I saw, the driver got ioctl SIOCSIWAUTH several times, once at the
>  > very beginning (even before wpa_supplicant read its config file). The value
>  > was 1, which means 1X in wext language.
>
>  I think there may be some misunderstanding here on how SIOCSIWAUTH is
>  used.. That call for setting IW_AUTH_WPA_ENABLED to 1 (WPA enabled), not
>  to set key management (IW_AUTH_KEY_MGMT).
>
>
>  > Then I got SIOCSIWENCODEEXT with the keys, right after that.
>  > There were other SIOCSIWAUTH calls but after SIOCSIWENCODEEXT, they didn't
>  > help much.
>
>  Help with what?

As keys were already applied consequent  calls SIOCSIWAUTH are not
helpful. Unfortunately the  order mattes. As in some cases SIOCSIWAUTH
might not come so the actual setting is triggered by SIOCSIWENCODEEXT.

>
>  > From include/linux/wireless.h I saw that there are only two "legal" options:
>  >
>  > /* IW_AUTH_KEY_MGMT values (bit field) */
>  > #define IW_AUTH_KEY_MGMT_802_1X 1
>  > #define IW_AUTH_KEY_MGMT_PSK    2
>  >
>  > which is a bit poor... I would need something like
>  > #define IW_AUTH_KEY_MGMT_NONE 0
>
>  Well, there is not an explicit define for that, but zero is indeed used
>  to indicate that none of the listed key management options are used..
>
>
>  > In any case, this configuration (SIWAUTH with value = 1) seems quite odd
>  > since I am not running 1X, this value looks like a default value.
>
>  That's not what happened here as far as I can tell.. When starting to
>  associate, wpa_supplicant would end up setting IW_AUTH_KEY_MGMT to 0 in
>  this particular case.

Will try to verify that again

>
>  > I would need to get configured with SIWAUTH value = 0, before
>  > SIOCSIWENCODEEXT, this would mean for me that the key that will be sent in
>  > the future are static keys.
>
>  The concept of "static keys" is a bit misleading.. And use of
>  IW_AUTH_KEY_MGMT to distinguish the key type does not sound like the
>  best thing to do here.
>
>
>  > The value 0 is chosen on purpose: iwconfig doesn't send any SIWAUTH ioctl
>  > and configures static WEP key. I would like IW_AUTH_KEY_MGMT_NONE to be the
>  > default in a zeroed struct.
>
>  I don't follow this.. IW_AUTH_KEY_MGMT is set to zero if 802.1X or WPA
>  is not used.
>
>
>  > Jouni, do you aggree that a change is needed in wpa_supplicant / wext to
>  > support WEP static key and allow mac80211 to differentiate between the
>  > config I copy pasted before and WEP keys coming from an AP through 1X ?
>
>  No, I don't see why something in wpa_supplicant or WEXT would need to be
>  changed. If the goal is to figure out whether the key that is being
>  configured is a broadcast/default/group key, the ext_flags field for
>  SIOCSIWENCODEEXT is has IW_ENCODE_EXT_GROUP_KEY flag. If the key is a
>  unicast/individual/key-mapping key, this flag is not set. In addition,
>  the addr.sa_data value is set to ff:ff:ff:ff:ff:ff for
>  broadcast/default/group keys and to a unicast address for
>  unicast/individual/key-mapping keys.



  >  Calling the keys "static" or "dynamic" is just going to cause
>  confusion.. It does not matter whether the keys are statically
>  configured (e.g., IEEE 802.1X "dynamic keys" for broadcast could be
>  configured "statically" to support non-IEEE 802.1X STAs). The main
>  difference is in whether they are broadcast/default/group keys or
>  individual/unicast/key-mapping keys. As far as I know, this is already
>  distinguished in the current interface. If not, please let me know exact
>  details on the case that does not have such information.

>  The driver will just need to know which key to use in the corner case if
>  someone were to configure broadcast/default/group key with key index 0
>  and a unicast/individual key (always key index 0 if one were to follow
>  the standard) and both could match an incoming frame (the
>  broadcast/default/group key would be used if the addr1 field is
>  broadcast/multicast; otherwise, the unicast/individual/key-mapping key
>  would be used).
>
>

So how do you call WEP key that is used for both unicast and broadcast
i.e the old WEP key.
It's not attached to any particular address it's global BSS key. The
true is that you don't need
a supplicant to configure it yet wpa_supplicant has this option so
people do that.

What mac80211 currently does it's attach it to broadcast address. If
there is a group key re keying you don't know whether also unicast key
have to be overridden or not since you don't know if this is a
'static/global; key or  dynamic group key


Thanks
Tomas
