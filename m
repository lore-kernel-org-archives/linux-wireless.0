Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbYDTPbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 11:31:52 -0400
Subject: Re:  RE: iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Brian Morrison <bdm@fenrir.org.uk>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080418232358.000fbdf7@peterson.fenrir.org.uk>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org>
	 <1208376292.27708.3.camel@localhost.localdomain>
	 <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com>
	 <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 11:28:21 -0400
Message-Id: <1208705301.5036.12.camel@localhost.localdomain> (sfid-20080420_163157_188112_71D37C51)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-04-18 at 23:23 +0100, Brian Morrison wrote:
> On Fri, 18 Apr 2008 15:12:13 -0700
> "Chatre, Reinette" <reinette.chatre@intel.com> wrote:
> 
> > Explicitly enabling sw scanning is an interesting idea. 
> > 
> > Marcus: could you please run your test twice with that patch? The first
> > time you run it as you did before, the second time please provide the
> > driver parameter "disable_hw_scan=1" together with the debug parameter.
> 
> Not wishing to muddy the waters, but I've found that the iwlwifi driver
> with a 3945 card is only reliable for scanning and associating for
> my laptop (x86_64) with disable_hw_scan=1 set, this is with
> 2.4.24.4-64.fc8 kernel. Driver version is 1.2.26.
> 
> Previous to the recent heavy driver development, with 2.6.23.15-137.fc8
> the opposite was the case. This was driver version 1.2.23.
> 
> Currently with sw scanning *every* scan returns my own 2 APs, whereas
> using hw scanning I often receive "No scan results" and my 2 APs
> sometimes appear in the scan output and disappear frequently. It's
> equally unreliable when I can see my neighbours APs, the software scan
> is reliable when signals are strong enough to register at all.
> 
> One of the Fedora common bugs advised the used of sw scanning, this is
> still showing up on the common bugs list.

The specific issue that caused Linville and I to request that people use
disable_hw_scan=1 was to diagnose an issue with iwl3945 where the driver
would subsequently fail to find an AP that was previously associated
with, without an rmmod/modprobe cycle.

After resume from sleep or hibernate, and in some cases where the STA
got disconnected, even repeated 'iwlist wlan0 scan' would fail to find
the previously associated AP, despite showing up to 30 or so APs in the
area, and despite being just 30 FT away from one AP in the SSID.
Setting disable_hw_scan=1 "fixed" the issue, though we hadn't gotten too
far with debugging it yet.

Dan


