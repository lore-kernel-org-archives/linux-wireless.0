Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:22056 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYCQAEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 20:04:31 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6054207wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 16 Mar 2008 17:04:31 -0700 (PDT)
Message-ID: <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com> (sfid-20080317_000437_017164_3A3B53D3)
Date: Mon, 17 Mar 2008 02:04:31 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205608293.15910.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 15, 2008 at 9:11 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Wed, 2008-03-12 at 17:05 -0700, Reinette Chatre wrote:
>  > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>  >
>  > This patch makes mac80211 able to send a phase1 key for TKIP decryption.
>  > This is needed for drivers that don't do the rekeying by themselves
>  > (i.e. iwlwifi). Upon IV16 wrap around, the packet is decrypted in SW, if
>  > decryption is ok, mac80211 calls to set_key with a new phase 1 RX key.
>
>
> > --- a/include/net/mac80211.h
>  > +++ b/include/net/mac80211.h
>  > @@ -590,12 +590,20 @@ enum ieee80211_key_alg {
>  >   * @IEEE80211_KEY_FLAG_TKIP_REQ_TX_P2_KEY: This flag should be set by
>  >   *   the driver for a TKIP key if it requires a phase2 TX key generation
>  >   *   in SW. The key will be attached to each packet.
>  > + * @IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY: This flag should be set by the driver
>  > + *   for a TKIP key if it requires phase 1 key generation in software.
>  > + *   The phase 1 key will be sent in the same context as Rx.
>  > + * @IEEE80211_KEY_FLAG_TKIP_PHASE1_VALID: Set by mac80211, valid only when
>  > + *   IEEE80211_KEY_FLAG_TKIP_REQ_RX_P1_KEY was set. When set, the phase 1
>  > + *   fields (tkip_p1k and tkip_iv32) in ieee80211_key_conf are valid.
>
>  This really breaks the set_key() model of having always one set_key()
>  call to add the key and another one to remove it again.
>
>  I think it would be much more appropriate to handle this in the driver
>  by exporting an appropriate phase1 mixing function that takes the
>  key_conf, iv16, RX vs. TX flag, and for RX the queue number as
>  arguments. The RX vs. TX flag could be used by the b43 driver since that
>  hardware can actually derive the phase2 key by itself.

iwlwifi firmware also derive phase2 in RX path by itself since this is
not really possible to do in host level. However in case of non
matching iv32 such as wraparound it passes packet up unencrypted.  And
there are some more esoteric cases when packet when SW decryption is
more efficient such as very short packets. Therefore HW decryption
have to be always backed up by SW one.
Wraparound of Iv32 is reliable only if decryption of a the packet that
triggers it is correct. If this is not done and phase1 is advanced by
mistake it  breaks traffic till the next wraparound actually it will
effectively cause  disconnection. Your suggestion will requires to
move also decryption into driver levelm not only phase1 generation. So
it's rather no go solution


>  I think for advanced features like crypto hardware acceleration or
>  similar we should deviate from the "push" model mac80211 has for most
>  things (and which you also implemented here) so we don't end up creating
>  special flags for all possible different hardware. A "pull" model is
>  much more scalable here.

I agree in general but in this specific case this will cause much more
data movement than few flags.

Thanks
Tomas

>  johannes
>
> -------------------------------------------------------------------------
>  This SF.net email is sponsored by: Microsoft
>  Defy all challenges. Microsoft(R) Visual Studio 2008.
>  http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
>  Ipw3945-devel mailing list
>  Ipw3945-devel@lists.sourceforge.net
>  https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
>
