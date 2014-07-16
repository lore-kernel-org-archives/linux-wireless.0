Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59597 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934406AbaGPP26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 11:28:58 -0400
Message-ID: <53C69A32.3090305@candelatech.com> (sfid-20140716_172901_469820_2317F3C6)
Date: Wed, 16 Jul 2014 08:28:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, svens@stackframe.org,
	vh.nguyen@actiasodielec.fr
Subject: Re: [RFC/RFT 2/2] ath10k: don't start monitor vdev for promisc
References: <1405516873-26411-1-git-send-email-michal.kazior@tieto.com> <1405516873-26411-2-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1405516873-26411-2-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/16/2014 06:21 AM, Michal Kazior wrote:
> ath10k doesn't apply any extra rx filters so
> there's no need to start monitor vdev for
> promiscuous mode.
>
> This fixes crashes with 4addr station interface
> bridging and some very rare crashes of AP
> interfaces with bridging as well.

Ahh, I was just working on some related hack-arounds to make sure
I left a vdev slot open for the monitor interface in case some poor
person started a sniffer on an interface and made it go promisc...

With this patch, I can be sure monitor interfaces will not
be automatically created without explicit user request?

Any idea if it will be a problem to apply this to what is
effectively a 3.15 kernel?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

