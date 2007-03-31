Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47302 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765AbXCaSJP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 14:09:15 -0400
Message-ID: <460EA3C9.6020207@lwfinger.net>
Date: Sat, 31 Mar 2007 13:09:13 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	John Linville <linville@redhat.com>
Subject: Re: mac80211 does not support WPA when used with wext
References: <460E2B8C.4030002@gmail.com>	 <1175335211.23438.45.camel@johannes.berg> <1175363333.9349.10.camel@localhost.localdomain>
In-Reply-To: <1175363333.9349.10.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sat, 2007-03-31 at 12:00 +0200, Johannes Berg wrote:
>> On Sat, 2007-03-31 at 11:36 +0200, dragoran wrote:
>>> Hello
>>> While testing the iwlwifi driver I noticed that the mac80211 does 
>>> provide a wext interface but does not support wpa with it.
>> You must have done something wrong, it works well.
> 
> Nope!  This time it's really mac80211 :)
> 
> Take a look at ieee80211_sta_scan_result() in mac80211/ieee80211_sta.c.
> Note that it returns custom events for the WPA & RSN IEs.  That's just
> wrong.  We should be using already-defined events.
> 
> [ Hopefully in cfg80211 we'll have a very easy way to extend the defined
> tag-list for attributes returned from scan results.  If you look at what
> various drivers have custom-defined for the CUSTOM tag, we weren't very
> aggressive about standardizing custom tags into IWEV* events. ]
> 
> I'm not sure where the heck these bits of mac80211 came from; both
> hostap and ieee80211 do it right (also airo, libertas, and prism54,
> though I'm to blame for those).  Plus, it's a net loss of code to do it
> with IWEVGENIE, and no additional kzalloc that can fail!  Bonus+2!
> 
> hostap:
> -------------
> 	if (bss && bss->wpa_ie_len > 0 && bss->wpa_ie_len <= MAX_WPA_IE_LEN) {
> 		memset(&iwe, 0, sizeof(iwe));
> 		iwe.cmd = IWEVGENIE;
> 		iwe.u.data.length = bss->wpa_ie_len;
> 		current_ev = iwe_stream_add_point(
> 			current_ev, end_buf, &iwe, bss->wpa_ie);
> 	}
> 
> 	if (bss && bss->rsn_ie_len > 0 && bss->rsn_ie_len <= MAX_WPA_IE_LEN) {
> 		memset(&iwe, 0, sizeof(iwe));
> 		iwe.cmd = IWEVGENIE;
> 		iwe.u.data.length = bss->rsn_ie_len;
> 		current_ev = iwe_stream_add_point(
> 			current_ev, end_buf, &iwe, bss->rsn_ie);
> 	}
> 
> ieee80211:
> -------------
> 
> 	memset(&iwe, 0, sizeof(iwe));
> 	if (network->wpa_ie_len) {
> 		char buf[MAX_WPA_IE_LEN];
> 		memcpy(buf, network->wpa_ie, network->wpa_ie_len);
> 		iwe.cmd = IWEVGENIE;
> 		iwe.u.data.length = network->wpa_ie_len;
> 		start = iwe_stream_add_point(start, stop, &iwe, buf);
> 	}
> 
> 	memset(&iwe, 0, sizeof(iwe));
> 	if (network->rsn_ie_len) {
> 		char buf[MAX_WPA_IE_LEN];
> 		memcpy(buf, network->rsn_ie, network->rsn_ie_len);
> 		iwe.cmd = IWEVGENIE;
> 		iwe.u.data.length = network->rsn_ie_len;
> 		start = iwe_stream_add_point(start, stop, &iwe, buf);
> 	}
> 
> <rant>
> 
> I don't quite get why mac80211/d80211 was so behind in wireless
> extensions support.  Didn't Jouni and Devicescape basically _write_
> WE-18/19 WPA support?  Did d80211 just not get the love that
> wpa_supplicant and the other drivers got when they were updated to WE-18
> and later?
> 
> </rant>
> 
> I can whip something up that _looks_ right but hasn't been compile
> tested if somebody else can test it.
> 

I can test it. ATM, I cannot get NM to connect, which prevents any testing of mac80211.

Larry
