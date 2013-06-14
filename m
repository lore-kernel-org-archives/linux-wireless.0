Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58093 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3FNXio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 19:38:44 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5ENchp9024782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 16:38:44 -0700
Message-ID: <51BBA983.5090704@candelatech.com> (sfid-20130615_013846_760802_5E47CDAB)
Date: Fri, 14 Jun 2013 16:38:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Double 'put' of bss in mac80211/mlme.c?
References: <51BBA888.7030309@candelatech.com>
In-Reply-To: <51BBA888.7030309@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2013 04:34 PM, Ben Greear wrote:
> Looks like an easy way to leak ies would be to mess up the
> ref counting on bss objects.
>
> While looking at such code, I found this in mac80211/mlme.c
>
> The destroy_assoc_data does a put_bss, and then it is put again
> directly.  Is this on purpose, or would this effectively cause
> a double-free?
>
>          if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
>              /* oops -- internal error -- send timeout for now */
>              ieee80211_destroy_assoc_data(sdata, false);
>              cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
>              return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
>          }
>
> Thanks,
> Ben
>

Gah, nevermind...one is assoc_data->bss, the other is auth_data->bss.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

