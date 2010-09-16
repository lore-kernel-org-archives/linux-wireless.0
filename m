Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:44156 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab0IPGrm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 02:47:42 -0400
Message-ID: <4C91BD85.9090604@openwrt.org>
Date: Thu, 16 Sep 2010 08:47:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath9k: Paprd calibration should be per channel
References: <1284560528-8934-1-git-send-email-vasanth@atheros.com> <1284560528-8934-2-git-send-email-vasanth@atheros.com> <4C90E4F6.1090403@openwrt.org> <20100916051739.GA32605@vasanth-laptop>
In-Reply-To: <20100916051739.GA32605@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-16 7:17 AM, Vasanthakumar Thiagarajan wrote:
> On Wed, Sep 15, 2010 at 08:53:34PM +0530, Felix Fietkau wrote:
>> On 2010-09-15 4:22 PM, Vasanthakumar Thiagarajan wrote:
>> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
>> NACK. The point of the caldata struct is to keep calibration data for
>> the operating channel and reset it whenever that changes (but not just
>> for off-channel activity).
>> Since the PAPRD data uses quite a bit of memory and doesn't take that
>> long to generate, we don't really need to make it per-channel.
> 
> Yes, it takes some memory, this looked clean and simple. It is not
> unusual case that we would be operating on different channels
> (think about roaming,dfs,p2p and etc).
Roaming is fine, since the driver is unlikely to switch back and forth
often enough for the re-calibration to matter.
As far as I know, the plan for p2p is to have a per-vif channel in the
long run. Once that is implemented, the calibration data will also be
made per-vif.

> The existing implementation
> does not do paprd calibration when the operating channel is changed.
> Having a single caldata might require us depend on SC_OP_SCANNING/
> SC_OP_OFFCHANNEL, but we are already dealing with some bugs in those
> flags. I completely agree that it takes memory, would try to fix
> existing issues in paprd rather than keeping channel specific data.
> thanks for the review.
If PAPRD is not started after the return to the operating channel, then
other calibrations will be affected as well. In that case, we definitely
need to fix the root cause and not paper over the bug by moving the
PAPRD state.

- Felix
