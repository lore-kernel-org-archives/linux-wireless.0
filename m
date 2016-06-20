Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:51332 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbcFTVeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 17:34:15 -0400
Date: Tue, 21 Jun 2016 00:25:29 +0300
From: Jouni Malinen <j@w1.fi>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
Message-ID: <20160620212529.GA19076@w1.fi> (sfid-20160620_233418_884571_193EB6CF)
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi>
 <57673E10.7070706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <57673E10.7070706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:51:28AM +0900, Masashi Honma wrote:
> On 2016年06月18日 18:11, Jouni Malinen wrote:
> Yes. This patch breaks backward compatibility.
> I do not have smart idea to avoid also.
> I will create new define like this.
> CONFIG_MAC80211_MESH_GROUP_ADDRESSED_PRIVACY

Do we really want that? Group addressed privacy is what the standard
requires to be used with mesh and if we make it build time configurable,
we'll just end up with two different implementation that will never
interoperate with each other.. I don't really see any better option for
this apart from fixing this and requiring all STAs in a secure mesh to
be updated in synchronized manner. This way it will be a one time issue,
but that won't be there forever.

If something is needed to for temporary backwards compatibility support,
that should be something that can be enabled at runtime (and be disabled
by default). That said, I'm not sure I'd go with that extra complexity
taken into account how badly (i.e., completely incorrectly) the PMF case
was implemented in wpa_supplicant. I'm not planning on adding any
backwards compatibility mode there for due to the previous behavior not
really being good from security view point either (using the same key
with two different algorithms).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
