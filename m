Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s5.bay0.hotmail.com ([65.54.246.205]:28396 "EHLO
	bay0-omc3-s5.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbYDSCix convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 22:38:53 -0400
Message-ID: <BAY109-W5276443C777EAD90F53A43C9E70@phx.gbl> (sfid-20080419_033859_609184_F31D6EFE)
From: Marcus Furlong <furlongm@hotmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: RE: iwl3945 problem with 2.6.25-rc9
Date: Sat, 19 Apr 2008 03:32:43 +0100
In-Reply-To: <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
 <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org>
 <1208376292.27708.3.camel@localhost.localdomain>
 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
 A<fu931e$k1b$1@ger.gmane.org>
 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
 (sfid-20080418_224627_648936_DECA7576)
 <1208555842.4848.56.camel@johannes.berg>
 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
Content-Type: text/plain; charset=Windows-1252
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 18 Apr 2008 15:12:13 -0700, you wrote:
>
> On Friday, April 18, 2008 2:57 PM, Johannes Berg wrote:
>
>> Just jumping in here because I want to know if there are any mac8021=
1
>> bugs (I don't have any 5 GHz hw except the iwl4965, no AP), would it
>> maybe help to explicitly enable sw scanning?
>
> First thing is that there is a iwlwifi driver or ucode problem as it
> asserts every time (it seems) when mac_config is called for channels =
38,
> 42, 46, and 52. Channel 36 succeeds. The cause of the ucode error is
> unclear to me as I am waiting for somebody to get back to me about wh=
at
> the contents of that "event log dump" means.
>
> I looked further about why mac_config is called for those channels an=
d
> the reason appears to be that it is done from ieee80211_sta_scan_work=
=2E
> This should not happen as it should only do so for sw scanning (if I
> understand correctly), while the default for this driver is hw scanni=
ng
> (and the user is not overriding the default). I am thus now trying to
> figure out how it actually thinks sw scanning is enabled through some
> simple debugging where mac80211 tries to run the driver's hw_scan
> function.
>
> Explicitly enabling sw scanning is an interesting idea.
>
> Marcus: could you please run your test twice with that patch? The fir=
st
> time you run it as you did before, the second time please provide the
> driver parameter "disable_hw_scan=3D1" together with the debug parame=
ter.

Both dmesg logs here:

https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch
https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-with-patch-disable=
_hw_scan

This time I was able to associate, and the dhcp client got an address e=
ach time (with and without disable_hwscan=3D1). However, with disable_h=
w_scan=3D1, I tried to associate, then dmesg said it had timed out. Aft=
er playing around a bit, I figured out that I could only properly assoc=
iate with my AP (essid testing) after I associated with a different AP =
(connected to my neighbours one). Rebooted a few times and repeated and=
 it worked each time.

Unfortunately both with and without disable_hwscan=3D1, I lost the conn=
ection after a few minutes.

(Quick question: I can't find information about using wireless-tools an=
d wpa for this driver. I saw for other drivers they use iwpriv set_algo=
=3D2 for wpa support, but iwl3945 doesn't seem to support this yet or i=
s there a different way?)

Marcus.
_________________________________________________________________
Love Hotmail? It just got better =96 Drag and Drop capabilities, new Re=
ading Panes making it easier to read your mail, enhanced security setti=
ngs, 5GB of FREE storage? New Windows Live Hotmail. Get your free accou=
nt here
http://get.live.com/mail/overview/--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
