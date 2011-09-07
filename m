Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1IGSIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 14:08:45 -0400
Subject: Re: [PATCH 0/2] QoS headers for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1315347976-13950-1-git-send-email-javier@cozybit.com> (sfid-20110907_002659_987760_30CFF5E1)
References: <1315347976-13950-1-git-send-email-javier@cozybit.com>
	 (sfid-20110907_002659_987760_30CFF5E1)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Sep 2011 20:08:40 +0200
Message-ID: <1315418920.4002.13.camel@jlt3.sipsolutions.net> (sfid-20110907_200849_198439_CB225490)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-06 at 15:26 -0700, Javier Cardona wrote:
> Mesh frames are required to have QoS headers to indicate the presence of a Mesh
> Control Header in the payload.  These patches add QoS headers to mesh frames,
> but note that they don't implement full QoS support: mesh stations don't
> currently advertise QoS capabilities.

Uh, so does mesh want full QoS support or just QoS headers? The latter
seems a little odd to me. But if it wants QoS how about zd1211rw? I
don't think that even supports QoS?

That's one thing that bothers me a little bit about this patchset --
previously, QoS frames could only happen when the device actually
supported 4 queues, now this rule seems to be broken. I don't expect
this to be a major issue, but it certainly is unexpected and will
probably be forgotten by a lot of people in the future ...

johannes

