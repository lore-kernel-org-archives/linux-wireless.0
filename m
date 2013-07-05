Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53866 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3GEJ7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 05:59:42 -0400
Message-ID: <1373018378.8548.6.camel@jlt4.sipsolutions.net> (sfid-20130705_115945_081349_187143C9)
Subject: Re: [PATCH V2] vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric.voncken@acksys.fr
Cc: linux-wireless@vger.kernel.org
Date: Fri, 05 Jul 2013 11:59:38 +0200
In-Reply-To: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	vlan_priority = (skb->vlan_tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
> +	if (vlan_priority > 0)
> +		return vlan_priority;

Is this really correct? For once, checking vlan_priority for non-zero
seems weird since that ought to be a valid value -- is there no other
way to determine that the value is valid?

Also, this gives you a 2-bit value, while the return value should be a
3-bit value, maybe you need to shift this up by one to spread into the
correct buckets?

johannes

