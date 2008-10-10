Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6987 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbYJJDZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 23:25:04 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"lrodrigues@atheros.com" <lrodrigues@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081009154547.GB13349@tesla>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 11:22:28 +0800
Message-Id: <1223608949.2510.1061.camel@debian.sh.intel.com> (sfid-20081010_052512_883760_F373F92C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-10-09 at 09:45 -0600, Luis R. Rodriguez wrote:
> 
> In your case I think you hit this after rmmod and modprobe:
> 
>         if (last_request->wiphy != wiphy)
>                 return -EALREADY;
> 
> since the last wiphy != your new wiphy. The reason this check was
> added
> though, as the comment indicates, was to prevent two drivers with
> different regulatory domains from trying to set it. In your case this
> doesn't affect your requested setting as the old regulatory domain
> is still set. This check currently also forces the first device
> detected
> on the system and its regutory_hint() to be respected over any other
> devices considering that your built in wireless card on your laptop
> will probably be detected first over your cardbus card, or USB card
> for example.
> 
> In other words this you can treat -EALREADY return value as non
> critical, as per the documentation (please see
> include/net/wireless.h).

Does below scenario an expected behaviour?

0. A system with iwl3945 BG card and iwl4965 AGN card.
1. insmod iwl3945 -> regulatory_hint(, 99, rd) return 0;
2. insmod iwl4965 -> regulatory_hint(, 99, rd2) return -EALREADY;
3. iwl4965 has no A band support!

Thanks,
-yi

