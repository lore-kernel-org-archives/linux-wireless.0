Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53567 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab0IUKZN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 06:25:13 -0400
Message-ID: <4C9887FD.6070505@openwrt.org>
Date: Tue, 21 Sep 2010 12:25:01 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: Kick start paprd calibration whenever	operating
 channel changes
References: <1285048487-16795-1-git-send-email-vasanth@atheros.com> <1285048487-16795-2-git-send-email-vasanth@atheros.com> <4C9883A4.60302@openwrt.org> <20100921101757.GA4229@vasanth-laptop>
In-Reply-To: <20100921101757.GA4229@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-21 12:17 PM, Vasanthakumar Thiagarajan wrote:
> On Tue, Sep 21, 2010 at 03:36:28PM +0530, Felix Fietkau wrote:
>> That seems like code duplication to me. The caldata already has the
>> channel number and the channel flags. ath9k_hw_reset() clears the entire
>> caldata whenever that changes. Because of that, ah->caldata->paprd_done
>> should have already been set to zero automatically after the reset
>> triggered by an operating channel change.
>> Is that part not working, or why did you write this patch?
>> Either way, we should not have a separate check just for paprd, it
>> belongs to the other calibrations.
> 
> I don't want to do paprd again whenever coming back from off-channel
> (like during background scanning).
That's not what it does. The caldata is only reset after *operating*
channel changes, not just after off-channel activity.
The reason this works is that for off-channel activity, the caldata
pointer is not passed to the hw reset function, so it can't reset any
data there. The intention behind that is that offchannel activity should
never trigger any long calibration activity, nor change the state of the
existing long calibration data.

- Felix
