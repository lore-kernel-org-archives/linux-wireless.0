Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:17374 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbYCKLaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 07:30:19 -0400
Received: by wa-out-1112.google.com with SMTP id v27so2800037wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 04:30:16 -0700 (PDT)
Message-ID: <1ba2fa240803110430h5cabec18s5be16b586769dec@mail.gmail.com> (sfid-20080311_113042_501299_D1E62113)
Date: Tue, 11 Mar 2008 13:30:16 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Lukas Hejtmanek" <xhejtman@ics.muni.cz>
Subject: Re: Recent driver in linux kernel 2.6.25-rc2
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080311094236.GB4344@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080219153910.GA4303@ics.muni.cz>
	 <D936D925018D154694D8A362EEB0892003AF3199@orsmsx416.amr.corp.intel.com>
	 <20080219224418.GA20926@ics.muni.cz>
	 <D936D925018D154694D8A362EEB0892003DB2DC5@orsmsx416.amr.corp.intel.com>
	 <20080311094236.GB4344@ics.muni.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/11 Lukas Hejtmanek <xhejtman@ics.muni.cz>:
> On Mon, Mar 10, 2008 at 05:35:32PM -0700, Chatre, Reinette wrote:
>  > sorry for the delay - please do submit a bug at bughost.org to enable us
>  > to track this problem.
>  >
>  > The error you get is strange - the reason why the channel could not be
>  > set was because the device is not considered to be ready. Yet, from your
>  > debug log all the required steps appear to have completed successfully.
>  > Could you please add a print to the function
>  > iwl4965-base.c:iwl4965_is_ready to see what the value of priv->status
>  > is?
>
>  I don't have this problem in 2.6.25-rc3 and rc4. However, it seems that the
>  card does not associate with AP if I set iwcofnig wlan0 essid any. Is this
>  a bug or a feature? The AP does not use key and is visible.
>
It looks more like mac80211 bug but frankly I would prefer if this
'any' feature will be not supported.
It has security implications. The decision about to which AP to
associate should be left solely to user space.

Tomas
