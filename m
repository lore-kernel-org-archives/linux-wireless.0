Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1JZRWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:22:45 -0400
Message-ID: <4EA7DA0F.7050603@sipsolutions.net> (sfid-20111026_192247_679315_277E7D08)
Date: Wed, 26 Oct 2011 11:59:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: support adding IV-room in the skb for CCMP
 keys
References: <1319350901-31178-1-git-send-email-arik@wizery.com> (sfid-20111023_082219_026010_8DDA891C)
In-Reply-To: <1319350901-31178-1-git-send-email-arik@wizery.com> (sfid-20111023_082219_026010_8DDA891C)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/23/2011 8:21 AM, Arik Nemtsov wrote:
> Some cards can generate CCMP IVs in HW, but require the space for the IV
> to be pre-allocated in the frame at the correct offset. Add a key flag
> that allows us to achieve this.

Is it really that expensive to generate the IV and then not use it that 
this is worth the extra complexity? This not just makes it more complex 
but also more expensive in the other case.

johannes
