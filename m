Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35065 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1G2RwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2011 13:52:00 -0400
Message-ID: <4E32F338.8040901@openwrt.org> (sfid-20110729_195204_976377_898929BF)
Date: Fri, 29 Jul 2011 19:51:52 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: Always send EAPOL frames at lowest rate
References: <1311960137-25420-1-git-send-email-helmut.schaa@googlemail.com> <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1311960137-25420-2-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-07-29 7:22 PM, Helmut Schaa wrote:
> Since EAPOL frames are normal data frames they are treated by the rate
> control algorithm as such. Thus it can happen that the rate control
> algorithm chooses an inappropriate rate (minstrel_ht uses MCS rates for
> example) for the 4-way handshake and under low signal conditions the
> handshake may time out.
>
> To fix this issue always treat EAPOL frames the same as management
> frames and send them with the lowest available rate.
Have you tried preventing minstrel_ht from using EAPOL frames for 
probing different rates instead of forcing it to use the lowest rate?

- Felix
