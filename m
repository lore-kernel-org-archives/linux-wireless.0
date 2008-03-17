Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:4762 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbYCQND3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 09:03:29 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6366637wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 06:03:29 -0700 (PDT)
Message-ID: <1ba2fa240803170603g58cd5378n4e8e58b62c41c37c@mail.gmail.com> (sfid-20080317_130343_540906_DFB344AD)
Date: Mon, 17 Mar 2008 15:03:28 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 2/5] mac80211: allows driver to request a Phase 1 RX key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205753998.1614.34.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-3-git-send-email-reinette.chatre@intel.com>
	 <1205608293.15910.53.camel@johannes.berg>
	 <1ba2fa240803161704r36b5df43q33c953d698b88590@mail.gmail.com>
	 <1205753998.1614.34.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 1:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > iwlwifi firmware also derive phase2 in RX path by itself since this is
>  > not really possible to do in host level.
>
>  Right. I just wonder why then it needs the host to derive the phase 2
>  key for TX, that seems pretty strange. Seems to me a bit like a "what
>  can we do" design decision rather than "what makes sense".

The reason is solely engineering. It can be done safely in host so
it's done there.

>  > However in case of non
>  > matching iv32 such as wraparound it passes packet up unencrypted.
>
>  That makes sense.
>
>
>  > Therefore HW decryption
>  > have to be always backed up by SW one.
>
>  Obviously, yes.
>
>
>  > Wraparound of Iv32 is reliable only if decryption of a the packet that
>  > triggers it is correct. If this is not done and phase1 is advanced by
>  > mistake it  breaks traffic till the next wraparound actually it will
>  > effectively cause  disconnection.
>
>  Good point. But let's not overload set_key() for it this way. This way,
>  the driver needs to look up the key etc. and the semantics get quite
>  mangled up. Also, your approach doesn't work for Broadcom hardware that
>  only needs phase 1 keys for both RX and TX.

Can you elaborate why it doesn't cover bcom case?

>  How about instead we add a new "update_tkip_key()" callback that takes
>  exactly the required parameters? It should also give the
>  hardware-key-index so that the driver has less work to do.

It's viable but I actually prefer not opening too many interfaces.
Please give me some more detailed sketch how do you see that and we
sure get to some acceptable solution.

Thanks
Tomas

>  johannes
>
