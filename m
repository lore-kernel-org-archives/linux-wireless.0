Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40226 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab1KPSQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 13:16:57 -0500
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org> <1321445323-71774-2-git-send-email-nbd@openwrt.org> <CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com>
In-Reply-To: <CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A6331C99-8D86-4CD6-88F2-123B38F31B26@nbd.name> (sfid-20111116_191700_064846_A1510CD2)
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 2/4] ath9k: rework power state handling
Date: Wed, 16 Nov 2011 19:16:58 +0100
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16.11.2011, at 18:42, "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com> wrote:

> On Wed, Nov 16, 2011 at 4:08 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> Turning off the radio when mac80211 tells the driver that it's idle is not
>> a good idea, as idle interfaces might still occasionally scan or send packets.
>> The only time the radio can be safely turned off is when drv_stop has been
>> called. In the mean time, use sc->ps_idle only to indicate network sleep vs
>> full sleep.
>> Move the LED GPIO changes out of the PCI suspend/resume path, the start/stop
>> functions already take care of that.
>> 
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> 
> This set of patches are going to need some good amount of testing for
> power impact. The benefits and gains need to be considered. I'll yield
> to Senthil and Paul for final approval on this.
One of the gains is that this series fixes some "PCI error" crashes on OpenWrt during hostapd restarts.

- Felix