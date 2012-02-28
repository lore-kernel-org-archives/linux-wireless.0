Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2B1Rkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 12:40:47 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Subject: RE: WARNING: at
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
 iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
Date: Tue, 28 Feb 2012 17:39:42 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB30B2BFE@HASMSX103.ger.corp.intel.com> (sfid-20120228_184050_706559_A4AF7C6B)
References: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com>
	<1330441305.3368.12.camel@jlt3.sipsolutions.net>
 <CAD2nsn0p=owQVumNVhxfPgtxyj7M6o5OkRcEYKhn8sQzQBCi+g@mail.gmail.com>
In-Reply-To: <CAD2nsn0p=owQVumNVhxfPgtxyj7M6o5OkRcEYKhn8sQzQBCi+g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> >> [11056.342672] WARNING: at
> >> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
> >> iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
> >> [11056.342681] Hardware name: 64756D6
> >> [11056.342687] reclaim is false, SEQ_RX_FRAME unset:
> STATISTICS_NOTIFICATION
> >
> > Thanks for the report. The warning is harmless, but we were hoping this
> > code was only to handle 4965 (this code comes from pre-driver-split
> > days). As we weren't sure, we put in the warning. Since you ran into it,
> > evidently this does in fact happen on later devices; it will complicate
> > our life a bit but we'll handle it.
> 
> oh ok,  also i am just using the default firmware thats in my system
> [36762.942612] iwlwifi 0000:03:00.0: loaded firmware version 8.83.5.1
> build 33692
> 

And this one seems to be the latest but I am not sure. Can you please download http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-5000-ucode-8.83.5.1-1.tar.gz and check what is the diff with your version ?
Thanks !


> 
> >
> > For you, there's nothing to worry about, the driver handles this
> > situation just fine. :-)
> 
> 
Yes, it just means that we must remove this WARNING. Thanks for the heads-up !
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

