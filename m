Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21572 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZCERtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 12:49:36 -0500
Subject: Re: Please apply to stable: cfg80211: add support for custom
 firmware regulatory solutions
From: reinette chatre <reinette.chatre@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>
References: <43e72e890903041335n47a70186u4a7aeb304f8b6979@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 09:54:28 -0800
Message-Id: <1236275668.6612.134.camel@rc-desk> (sfid-20090305_184942_799938_88197D44)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-03-04 at 13:35 -0800, Luis R. Rodriguez wrote:
> Forgot to Cc: stable@kernel.org for this patch during its submission,
> this is needed on 2.6.28 as otherwise there is an issue for Intel
> cards which get their channels 5 GHz disabled if OLD_REG is set to no
> (this is not the default) or the channels 12-14 are disabled if
> OLD_REG is set to yes (default) set to no and the ieee80211_module
> parameter is not used. The later issue is resolved by userspace as
> well but we cannot yet expect 2.6.28 kernels to have enough userspace
> interfaces to set the regulatory domain just yet. This is why OLD_REG
> is still set to default with 2.6.28.
> 
> 14b9815af3f4fe0e171ee0c4325c31d2a2c1570b
> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date:   Wed Nov 12 14:22:03 2008 -0800
> 
>    cfg80211: add support for custom firmware regulatory solutions
> 
>    This adds API to cfg80211 to allow wireless drivers to inform
>    us if their firmware can handle regulatory considerations *and*
>    they cannot map these regulatory domains to an ISO / IEC 3166
>    alpha2. In these cases we skip the first regulatory hint instead
>    of expecting the driver to build their own regulatory structure,
>    providing us with an alpha2, or using the reg_notifier().
> 
>    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>    Acked-by: Zhu Yi <yi.zhu@intel.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Could you please also add commit
ea4a82dceec7b5782b1259079c8de508d0afe33a? This is the commit that
enables the Intel cards to take advantage of the parameter introduced in
previous commit.

commit ea4a82dceec7b5782b1259079c8de508d0afe33a
Author: Luis R. Rodriguez <lrodriguez@atheros.com>
Date:   Wed Nov 12 14:22:04 2008 -0800

    iwlwifi: enable custom fw regulatory solution
    
    This enables the custom firmware regulatory solution option
    on iwlwifi drivers. These devices are uncapable of mapping their
    EEPROM regulatory domain to a specific ISO / IEC alpha2.
    Although the new 11n devices (>= iwl 5000) have only
    3 regultaory SKUs -- MOW, ABG (no N) and BG -- the older
    devices (3945 and 4965) have a more complex SKU arrangement
    and therefore its not practical to move this to the driver.
    
    Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
    Acked-by: Zhu Yi <yi.zhu@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>


