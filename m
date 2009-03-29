Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4633 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZC2TlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 15:41:19 -0400
Date: Sun, 29 Mar 2009 15:39:00 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Message-ID: <20090329193900.GA27166@hash.localnet> (sfid-20090329_214129_376797_021FC71D)
References: <200903242324.33485.chunkeey@web.de> <20090324223022.M51759@bobcopeland.com> <43e72e890903241613x6e6de1ecp909ee6f4156ba709@mail.gmail.com> <43e72e890903241617i629a4c75of573bb7f77572ade@mail.gmail.com> <43e72e890903241652o70aa8e2bjd40a5ae9a4ebc91a@mail.gmail.com> <20090325010626.GA8528@hash.localnet> <43e72e890903241930g7985f7c7i858a0e94fb8db667@mail.gmail.com> <43e72e890903241959x51dc9278oc424bfa85cff9e0f@mail.gmail.com> <43e72e890903242015l449f0835v5602694c735f9b96@mail.gmail.com> <43e72e890903242045n520842c3q9392f75651a6b905@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903242045n520842c3q9392f75651a6b905@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 08:45:53PM -0700, Luis R. Rodriguez wrote:
> > Fixed..
> >
> > http://bombadil.infradead.org/~mcgrof/patches/ath/ath-common-v5.patch.txt
> 
> Nope.. no luck, something got messed up along the way... needs a closer look.

So I tested this series and it works fine, with a caveat:

Currently, ath5k exposes tons of 5 GHz channels.  In addition to the other
problems I mentioned in http://marc.info/?l=linux-wireless&m=123825852320853,
it also essentially breaks with regulatory hints from the driver.  This is
because because the Atheros world regdomain allows most channels in the
5 GHz range for passive scanning, whereas the default world regdomain 
disables many of these.  Consequently, scanning takes long enough that 
NM/wpa_supplicant bails.

So, I think the way forward is to include the patch linked above with the
rest of the series.  Although perhaps the last patch moving ath5k/ath9k etc 
under the ath/ directory can be put off a while in case people have patches 
sitting around against the old dir structure.

Anyone who still wants to use all the channels with ath5k can use a custom 
regd or configure the supplicant to scan the specific channels they are 
interested in.

-- 
Bob Copeland %% www.bobcopeland.com

