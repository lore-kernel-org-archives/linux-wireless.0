Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:20737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYDRWMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 18:12:15 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: RE:  RE: iwl3945 problem with 2.6.25-rc9
Date: Fri, 18 Apr 2008 15:12:13 -0700
Message-ID: <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com> (sfid-20080418_231234_669737_BDAABB98)
In-Reply-To: <1208555842.4848.56.camel@johannes.berg>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com> A<fu931e$k1b$1@ger.gmane.org> <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com> (sfid-20080418_224627_648936_DECA7576) <1208555842.4848.56.camel@johannes.berg>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Marcus Furlong" <furlongm@hotmail.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, April 18, 2008 2:57 PM, Johannes Berg  wrote:

 
> Just jumping in here because I want to know if there are any mac80211
> bugs (I don't have any 5 GHz hw except the iwl4965, no AP), would it
> maybe help to explicitly enable sw scanning?

First thing is that there is a iwlwifi driver or ucode problem as it
asserts every time (it seems) when mac_config is called for channels 38,
42, 46, and 52. Channel 36 succeeds. The cause of the ucode error is
unclear to me as I am waiting for somebody to get back to me about what
the contents of that "event log dump" means.

I looked further about why mac_config is called for those channels and
the reason appears to be that it is done from ieee80211_sta_scan_work.
This should not happen as it should only do so for sw scanning (if I
understand correctly), while the default for this driver is hw scanning
(and the user is not overriding the default). I am thus now trying to
figure out how it actually thinks sw scanning is enabled through some
simple debugging where mac80211 tries to run the driver's hw_scan
function.

Explicitly enabling sw scanning is an interesting idea. 

Marcus: could you please run your test twice with that patch? The first
time you run it as you did before, the second time please provide the
driver parameter "disable_hw_scan=1" together with the debug parameter.

Thank you 

Reinette
