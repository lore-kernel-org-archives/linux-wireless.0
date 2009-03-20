Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:53181 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZCTBW2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 21:22:28 -0400
Received: by an-out-0708.google.com with SMTP id d14so620846and.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 18:22:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237427568.6943.13.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236312734.19328.37.camel@rainbow> <1236317982.12430.9.camel@rc-desk>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
Date: Thu, 19 Mar 2009 21:22:25 -0400
Message-ID: <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com> (sfid-20090320_022231_904381_2FD27C7F)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a bug related to the use of DMA.  Using wireless-testing
2.6.29-rc7 from ~3/15, and booting with "iommu=off mem=2G" gives me a
working iwl3945.  I also confirmed
78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use iwl3945_tx_cmd
instead of iwl_tx_cmd" plus previously posted "rb_stts and BUG to
WARN" patch as working when iommu is disabled.

So swiotlb exposes iwl3945 dma breakage.

>From 78bb4a96d0d4ab2860df5f0fdfde58cd7a3ad642 "iwl3945: use
iwl3945_tx_cmd instead of iwl_tx_cmd" the most obvious problem is the
change to pci_map_single from pci_alloc_consistent.

As previously noted, problems brought along by that include the
modification of data to be DMAed after the _map_single call.  The lack
of associated un-mapping of memory may also be a problem.

For testing, swiotlb use can be forced with "swiotlb=force" which
should reproduce the error.

Jason
