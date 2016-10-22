Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57024 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751816AbcJVUeV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 16:34:21 -0400
Message-ID: <1477168456.4123.10.camel@sipsolutions.net> (sfid-20161022_223424_647264_5427266A)
Subject: Re: [NOT FOR MERGE] ath9k: work around key cache corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <a@unstable.cc>, ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
        Antonio Quartulli <antonio@open-mesh.com>
Date: Sat, 22 Oct 2016 22:34:16 +0200
In-Reply-To: <20161022134222.GQ12558@prodigo.lan> (sfid-20161022_154307_816691_A0A58C81)
References: <20161018083552.28592-1-a@unstable.cc>
         <20161022134222.GQ12558@prodigo.lan> (sfid-20161022_154307_816691_A0A58C81)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> "The patch itself has (at least) one big problem. It is using some
> mac80211
> internals in ath_key_config_iter to make sure that the uploaded keys
> were
> actually programmed in the hardware. Without this check the keys
> could end up
> in the lower slots and thus break all connections."

The KEY_FLAG_UPLOADED_TO_HARDWARE use? Might not be so nice, but it's
probably not really a problem. If you wanted to avoid it, you could
just use the hw_key_idx in some way, e.g. the highest-order bit
indicates that you've set this value, or you just make sure that 0 is
an invalid value and set it to real index + 1 or something, then you
can check that?

johannes
