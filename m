Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaCFRi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 12:38:59 -0500
Message-ID: <1394127643.10175.13.camel@dcbw.local> (sfid-20140306_183904_319172_CB56B7EA)
Subject: Re: rtlwifi (rtl8192ce) consistently reports EBUSY error, but
 scanning works
From: Dan Williams <dcbw@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Thierry Moreau <thierry.moreau@connotech.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 06 Mar 2014 11:40:43 -0600
In-Reply-To: <53189AF9.9030707@lwfinger.net>
References: <5316C602.8020504@connotech.com> <5316CE44.5060905@lwfinger.net>
	 <5317506B.1080305@connotech.com> <53175368.50009@lwfinger.net>
	 <531777F8.5060506@connotech.com> <53189AF9.9030707@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-06 at 09:57 -0600, Larry Finger wrote:
> On 03/05/2014 01:16 PM, Thierry Moreau wrote:
> > On 03/05/14 16:40, Larry Finger wrote:
> >>
> >> Please give me the exact set of commands you use to get this problem. If
> >> possible, capture the console output. As I am currently running
> >> long-term tests of the latest version of rtl8192ce using an RTL8188CE
> >> (10ec:8176), it will be a perfect time to test.
> >>
> >
> > Here is the command script, and the console log
> > (....sh 2>&1 | tee ....log)
> >
> > Is it possible that the Shuttle system be arranged with a digital output
> > enabling/inhibiting the Realtek wifi interface active participation in wifi
> > protocol?
> >
> > I did ask Shuttle tech support, but in any event I don't want to induce you to
> > troubleshoot a specific system.
> 
> The problem is not specific to the Shuttle - I can reproduce it on my HP laptop. 
> Furthermore, it affects other mac80211-based drivers. The EBUSY return comes out 
> of mac80211/cfg80211/nl80211 code.

I deleted the earlier bits of this thread after skimming it, but IIRC
we're talking about scanning here right?  If there's already a scan
in-progress, then the stack can often return EBUSY.

For example, from both cfg80211_wext_siwscan() and
nl80211_trigger_scan(), used by 'iwlist' and 'iw' respectively:

	if (rdev->scan_req) {
		err = -EBUSY;
		goto out;
	}

Scans do not get canceled just because another random scan request comes
in.  Whatever userspace there is needs to wait for a scan completion
event and then request it's new scan.  There are also stack internal
scans that happen from time to time that may cause a user-requested scan
to return EBUSY.

(NM hands this all off to wpa_supplicant, which itself handles the EBUSY
by waiting a bit and then requesting another scan.)

Dan

