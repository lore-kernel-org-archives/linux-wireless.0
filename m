Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:32984 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3J2Kab (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 06:30:31 -0400
Received: by mail-la0-f47.google.com with SMTP id ep20so6284580lab.34
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 03:30:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526ED316.7090205@qca.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
 <1382020835.14410.16.camel@jlt4.sipsolutions.net> <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAD14@nasanexd01a.na.qualcomm.com>
 <1382035171.22901.13.camel@dcbw.foobar.com> <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAF6F@nasanexd01a.na.qualcomm.com>
 <CAB=NE6UkKuSzH4x2SjkE0pRTVCVa3k7g=_ZeU_JE+t2OovRoEg@mail.gmail.com>
 <D19FD2B13A40CD4B8DA64DB9B8F112E9218E461D@nasanexd01a.na.qualcomm.com>
 <1382986906.7298.10.camel@dcbw.foobar.com> <526ED316.7090205@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 29 Oct 2013 11:30:10 +0100
Message-ID: <CAB=NE6VmxPOBcmRtO2r9KBfavTjNOexx5rWCh_KRv6_kf0Bq2w@mail.gmail.com> (sfid-20131029_113039_991492_28AE63C3)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe frequency ranges(s)
To: Jeffrey Johnson <jjohnson@qca.qualcomm.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 10:11 PM, Jeffrey Johnson
<jjohnson@qca.qualcomm.com> wrote:
> The issue that has been debated internally is whether or not userspace needs
> to know the source of the interference.  In other words, if we have an
> enumerated set of interference sources, would userspace behave differently
> based upon the source?

This is ignoring my overall architectural considerations of this being
cross RF domains and likely being a better idea to instead consider a
frequency broker for this sort of information. The only reason I
believe we can let that argument go here is that in this particular
case the same antenna is being used and the information seems to be
coming from the wireless firmware, as such it is pertinent to the
struct wiphy, and hence seems proper placement for an nl80211 event.

In so far as the source of information -- as I have said internally,
although userspace may not use it today, it may tomorrow, and having
that information can be useful. I consider a random source of
associated "frequency advisory" simply pointless. At least with some
sort of category of source, userspace, say hostapd or the supplicant,
may decide to treat it in a very specific way today.

  Luis
