Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:46924 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbaHZFws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 01:52:48 -0400
Message-ID: <1409032360.32368.2.camel@dubbel> (sfid-20140826_075252_472502_6E4E5294)
From: Luca Coelho <luca@coelho.fi>
To: Jim Rees <rees@umich.edu>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Tue, 26 Aug 2014 08:52:40 +0300
In-Reply-To: <20140826020721.GA1490@umich.edu>
References: <20140826020721.GA1490@umich.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi 35% loss rate after v3.16-rc5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jim,

On Mon, 2014-08-25 at 22:07 -0400, Jim Rees wrote:
> I've got a Thinkpad x220 with iwlwifi Ultimate-N 6300 AGN. After v3.16-rc5
> it became unusable due to 35% packet loss rate. If I revert these commits,
> it works again:
> 
> dc271ee iwlwifi: mvm: disable CTS to Self
> 43d826c iwlwifi: dvm: don't enable CTS to self
> e48393e iwlwifi: mvm: Fix broadcast filtering
> a42c9fc Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag"
> b3c063a iwlwifi: update the 7265 series HW IDs
> 8987941 iwlwifi: mvm: rework sched scan channel configuration
> 
> I can bisect further if that would be useful. Dmesg is here:
> http://pastebin.com/wD3UMxUL
> 
> It's still broken in 3.17.0-rc2. Any suggestions?

This is probably the commit that is to blame:

43d826c iwlwifi: dvm: don't enable CTS to self

Could you try again without just that one? If it's confirmed we can
revert that patch.

Also, any chance you can get sniffer logs of the problem?

--
Cheers,
Luca.

