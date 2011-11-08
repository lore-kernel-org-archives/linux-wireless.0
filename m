Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57691 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1KHTRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 14:17:21 -0500
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pA8JHKhC026610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 8 Nov 2011 11:17:21 -0800
Message-ID: <4EB98040.3020608@candelatech.com> (sfid-20111108_201724_409790_45209EDA)
Date: Tue, 08 Nov 2011 11:17:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7 1/2] wireless:  Support ht-capabilities over-rides.
References: <1320778857-3073-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1320778857-3073-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 11:00 AM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> This allows users to disable features such as HT, HT40,
> and to modify the MCS, AMPDU, and AMSDU settings for
> drivers that support it.
>
> The MCS, AMPDU, and AMSDU features that may be disabled are
> are reported in the phy-info netlink message as a mask.
>
> Attemping to disable features that are not supported will
> take no affect, but will not return errors.  This is to aid
> backwards compatibility in user-space apps that may not be
> clever enough to deal with parsing the the capabilities mask.
>
> This patch only enables the infrastructure.  An additional
> patch will enable the feature in mac80211.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
>
> v7:  Add detailed comments about what is supported in the
>       HT_CAPABILITY_MASK attribute.
>
>       Add call to cfg80211_oper_and_ht_capa() in the
>       __cfg80211_connect path to make sure non mac80211
>       drivers get proper masking.

Damn, I messed this up.  Hold for v8.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

