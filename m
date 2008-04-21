Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYDUARu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 20:17:50 -0400
Subject: Re: RE: iwl3945 problem with 2.6.25-rc9
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Brian Morrison <bdm@fenrir.org.uk>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240804201339u3232c5f6mede647c5c8521ae3@mail.gmail.com>
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com>
	 <fu931e$k1b$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB089200438B6D6@orsmsx416.amr.corp.intel.com>
	 <1208555842.4848.56.camel@johannes.berg>
	 <D936D925018D154694D8A362EEB089200438B728@orsmsx416.amr.corp.intel.com>
	 <20080418232358.000fbdf7@peterson.fenrir.org.uk>
	 <1208558255.4848.60.camel@johannes.berg>
	 <1208558382.4848.63.camel@johannes.berg>
	 <1ba2fa240804181728u7a3440cajbba7dcc696d02909@mail.gmail.com>
	 <1208593973.26186.2.camel@johannes.berg>
	 <1ba2fa240804201339u3232c5f6mede647c5c8521ae3@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 20:14:09 -0400
Message-Id: <1208736849.18548.8.camel@localhost.localdomain> (sfid-20080421_011804_298309_79AE2933)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-20 at 23:39 +0300, Tomas Winkler wrote:
> On Sat, Apr 19, 2008 at 11:32 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >  > Second the 3954 and 4965 my uCode may crash intentionally if you send
> >  > probe requests on a passive channel.according EEPROM.
> >
> >  I really wonder what sort of error handling strategy that is, even if
> >  it's done for regulatory compliance purposes I don't see a need to crash
> >  the whole card. Especially considering that the userspace MLME in
> >  wpa_supplicant will scan by itself (yes, it scans in userspace, whether
> >  or not you may like that), of course it would be made comply with
> >  regulatory settings but that makes it hard to develop.
> 
> It should not scan on not supported channel in any conditions. EEPROM
> and reg.c has to be combined.

The driver should _certainly_ be enforcing regulatory domains.  Even if
userspace requests a scan of a channel that is not available in the
regulatory domain, the driver needs to be rejecting the scan request in
situations where the firmware would reject it.

If the firmware triggers an assertion, that definitely indicates a bug
in the driver, where the driver is not properly gating options sent to
the firmware.  Only in the most exceptional circumstances should the
firmware actually crash.

> >
> >  > I personally  wish to not make SW scanning possible at all for that reason.
> >
> >  That is not going to happen since you can always "scan" by sending probe
> >  requests manually.
> 
> Probe request before association is  a must, no argue about it.
> 
> >  > At last iwlwifi HW scanning can handle up to 4 essids for direct scan
> >  > but currently wireless tools interface cannot utilize this.
> >
> >  Does anybody actually *want* that? I personally dislike the behaviour of
> >  scanning for all previously known SSIDs actively when hidden SSIDs are
> >  so uncommon, I see it as an information disclosure vulnerability.
> 
> Sure you want that. User space applications handles number of
> preferred SSIDs, let's call them profiles. It's desired that you do
> direct scan for those SSIDss for faster connection.
> Currently it takes 20 minutes  for NM to connect to network I want in
> crowded air. (I'm exaggerating now I don't have real number...  but
> it's something like that)

More like 1 or 2 minutes; though the scanning algorithm in NM 0.7 does
need to be optimized somewhat.  Cards that advertise > 14 channels are
assumed to take a prohibitively long time to scan while connected
(madwifi was the largest offender here), and therefore NM will not
request scans for a/b/g devices while connected, but will collect and
use background scan results.

Dan

> It's not just for hidden ssids.
> 
> Tomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

