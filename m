Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19766 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbYBEQvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 11:51:54 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [Ipw2100-devel] ipw2200 stalls on high load
Date: Tue, 5 Feb 2008 08:50:51 -0800
Message-ID: <4220499A1B034C4FA93B547BA01E1FF0017465A2@orsmsx413.amr.corp.intel.com> (sfid-20080205_165157_026726_5EF25DB0)
In-reply-to: <1202224154.1243.7.camel@localhost.localdomain>
References: <20080126132939.GA22630@Chamillionaire.breakpoint.cc><D936D925018D154694D8A362EEB0892003800B1B@orsmsx416.amr.corp.intel.com><20080130225738.GB2648@Chamillionaire.breakpoint.cc><D936D925018D154694D8A362EEB08920038F4382@orsmsx416.amr.corp.intel.com><1202128649.10632.4.camel@localhost.localdomain><D936D925018D154694D8A362EEB0892003947453@orsmsx416.amr.corp.intel.com><20080204224502.GA22717@Chamillionaire.breakpoint.cc><1202167450.5190.2.camel@localhost.localdomain><20080205083511.GA28623@Chamillionaire.breakpoint.cc> <1202224154.1243.7.camel@localhost.localdomain>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Dan Williams" <dcbw@redhat.com>,
	"Sebastian Siewior" <ipw+2200@ml.breakpoint.cc>
Cc: "James Ketrenos" <jketreno@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>, <linux-wireless@vger.kernel.org>,
	<ipw2100-devel@lists.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> That would mean that count never gets above 8, and that the 
> RX queue is never restocked.  The (count >= 8) part might be 
> specific to the
> 3945/4965 drivers, since they apparently restock the RX queue 
> in blocks of 8.  

That's right, the 3945 and 4965 hardware like to see the index change on
boundaries of 8.  You'll see that, somewhere in the driver code, the
lower 3 bits of the index get masked to 0.  I don't know what 2200's
requirements are in this regard.

-- Ben --
