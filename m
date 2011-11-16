Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48030 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab1KPXwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 18:52:50 -0500
Message-ID: <4EC44CC6.7090104@openwrt.org> (sfid-20111117_005257_145958_1AE3FB30)
Date: Thu, 17 Nov 2011 00:52:38 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: [PATCH 2/4] ath9k: rework power state handling
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org> <1321445323-71774-2-git-send-email-nbd@openwrt.org> <CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com> <A6331C99-8D86-4CD6-88F2-123B38F31B26@nbd.name> <CAB=NE6WLQUqbWoVGC4WgGVFTUJC1i8_um4=sBU-V+NpfW57YHg@mail.gmail.com> <CAMcMvsjsCzDH6hpS6Bon-5Zrad5eNf41Zq0ei_iw+MFK41rF=w@mail.gmail.com>
In-Reply-To: <CAMcMvsjsCzDH6hpS6Bon-5Zrad5eNf41Zq0ei_iw+MFK41rF=w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-16 7:40 PM, Paul Stewart wrote:
> In fact, could this be made contingent on whether there's an AP-mode
> interface, since the problem you're encountering seems to only be in
> AP mode?  What troubles me, Felix, is your statement that " this
> series fixes some "PCI error" crashes".  Does this mean that you
> haven't root-caused the problem, and that this may only partially mask
> it?
The existing code was wrong, especially for client mode. I only noticed
that because I was investigating some AP mode crashes triggered by it.
My main focus when fixing this stuff was actually client mode since
that's the one most affected by this codepath.

- Felix
