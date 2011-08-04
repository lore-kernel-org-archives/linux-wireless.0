Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58300 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab1HDSXf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2011 14:23:35 -0400
Message-ID: <4E3AE3A0.2000308@openwrt.org> (sfid-20110804_202339_249480_48CA985D)
Date: Thu, 04 Aug 2011 20:23:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 11/13] ath9k_hw: Disable Walsh spatial spreading for
 2 chains
References: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1312480447-27483-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-04 7:54 PM, Rajkumar Manoharan wrote:
> The Walsh bit is disabled for regulatory consideration.
>
> As per the FCC rulings, only transmissions that are completely
> non-coherent, are allowed to waive the array gain contribution
> to EIRP for multi-transmit configurations. The use of 2-stream
> with 2 transmit and use of 3-steam with 3 transmit qualifies
> for this spatial multiplexing MIMO classification as long as
> the streams are directly mapped to each radio (not Walsh spread
> prior to splitting to multiple radios)
I think ath9k does not waive the array gain contribution. I haven't 
checked AR9003, but on AR9002 and older, it explicitly includes the 
array gain contribution in the tx power limit calculation. I'm not sure 
that unconditionally disabling spatial spreading is the right way to 
deal with this.

- Felix
