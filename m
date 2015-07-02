Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36763 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbGBLvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:51:13 -0400
Received: by igrv9 with SMTP id v9so94498800igr.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 04:51:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435837168.2285.8.camel@sipsolutions.net>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
 <1435082418.2777.11.camel@ipeer-box> <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
 <1435822032.2285.2.camel@sipsolutions.net> <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com>
 <1435837168.2285.8.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 2 Jul 2015 17:20:53 +0530
Message-ID: <CABPxzY+P+p18gVG-o9WhuQy_VVvR3QaS-CQMr8RuiD_2iSTFgw@mail.gmail.com> (sfid-20150702_135116_909105_3370B24D)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 2, 2015 at 5:09 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-07-02 at 11:44 +0200, Janusz Dziedzic wrote:
>>
>> > The issue above can probably easily fixed by doing the BSS update
>> > after
>> > the "direct probe responded" though, no? Like this:
>> > https://p.sipsolutions.net/67f9212f0f9f3642.txt
>> >
>> This was my first idea, but in such case I suspect we will send
>> another direct probe while  bss->proberesp_ies will be not set and
>> ieee80211_probe_auth() will send second probe_req?
Yes, if the seuqnce number is not set the second probe resp
also gets dropped.

> But why would it not be set? We do rely on ieee80211_rx_bss_info()
> setting it, after all.
The probe resp is dropped early in the rx_path so this call is not made.
