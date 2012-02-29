Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab2B2I3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:29:55 -0500
Subject: RE: WARNING: at
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
 iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB30B2BFE@HASMSX103.ger.corp.intel.com>
References: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com>
	 <1330441305.3368.12.camel@jlt3.sipsolutions.net>
	 <CAD2nsn0p=owQVumNVhxfPgtxyj7M6o5OkRcEYKhn8sQzQBCi+g@mail.gmail.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB30B2BFE@HASMSX103.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 09:29:53 +0100
Message-ID: <1330504193.4714.1.camel@jlt3.sipsolutions.net> (sfid-20120229_093008_126771_DBDC14FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-28 at 17:39 +0000, Grumbach, Emmanuel wrote:
> > >
> > >> [11056.342672] WARNING: at
> > >> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
> > >> iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
> > >> [11056.342681] Hardware name: 64756D6
> > >> [11056.342687] reclaim is false, SEQ_RX_FRAME unset:
> > STATISTICS_NOTIFICATION
> > >
> > > Thanks for the report. The warning is harmless, but we were hoping this
> > > code was only to handle 4965 (this code comes from pre-driver-split
> > > days). As we weren't sure, we put in the warning. Since you ran into it,
> > > evidently this does in fact happen on later devices; it will complicate
> > > our life a bit but we'll handle it.
> > 
> > oh ok,  also i am just using the default firmware thats in my system
> > [36762.942612] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1
> > build 33692
> > 
> 
> And this one seems to be the latest but I am not sure. Can you please download http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-5000-ucode-8.83.5.1-1.tar.gz and check what is the diff with your version ?

ISTR that the only difference was that the previous version was
accidentally packaged as supporting two virtual interfaces, which isn't
true.

johannes

