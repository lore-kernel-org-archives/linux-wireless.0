Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39323 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZLCUZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 15:25:15 -0500
Received: by bwz27 with SMTP id 27so1473248bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 03 Dec 2009 12:25:20 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 3 Dec 2009 12:25:20 -0800
Message-ID: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
Subject: RE: [PATCH v3 0/2] mac80211: add U-APSD client support
From: Jason Young <a.young.jason@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I'm happy to see this proposal for U-APSD client support for mac80211.

>> Hello,
>>
>> here is my proposal how to add U-APSD client support to mac80211. I also
>> included example driver implementation for wl1251.
>>
>> Please comment. Also I would like to get comments how U-APSD needs to be
>> implemented in different hardware.

WMM Admission Control allows queues to be configured as trigger-only and
deliver-only via mgmt action frames. If this feature is ever added to mac80211
we may need to make trigger-enabled and deliver-enabled per queue configuration
explicit rather than a single boolean value per access category.  Being as
there is no way to configure an access category trigger-only or deliver-only
outside of admission control, we don't need to worry about this problem right
now.

>>
>> v3:
>> - remove unnecessary debugfs interface, people can recompile mac80211 in
>> case they want to try enable more queues

We will want runtime time configuration of u-apsd because its is necessary for
station's 'WMM Power Save' certification. Recompiling mac80211 for the various
uapsd configurations is a bit heavy-handed. I'd like to see debugfs support
added back back for now its primarily a testing issue anyway.

>> - add max SP length defines to ieee80211.h

The bit values for IEEE80211_WMM_IE_STA_SP_XXX are not correct.  The Max SP
Length subfield settings table in 7.3.1.17 has the least significant bit listed
first.

#define IEEE80211_WMM_IE_STA_SP_ALL  (0<<5)
#define IEEE80211_WMM_IE_STA_SP_2     (1<<5)  /* or (BIT(5)) */
#define IEEE80211_WMM_IE_STA_SP_4     (2<<5)  /* or (BIT(6)) */
#define IEEE80211_WMM_IE_STA_SP_6     (3<<5)  /* or (BIT(5) | BIT(6)) */

>> v2:
>> - remove cfg80211 changes
>> - rename IEEE80211_QOS_IE to IEEE80211_WMM_IE_STA in ieee80211.h

I would rename IEEE80211_WMM_IE_STA_XXX defines to something like
IEEE80211_STA_QOSINFO_XXX to make it clear that bit values are used in the
context of the qosinfo field octet.

Jason Young
DSP Group
