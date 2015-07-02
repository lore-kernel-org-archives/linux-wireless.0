Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36070 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbbGBLuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:50:05 -0400
Received: by igrv9 with SMTP id v9so94480347igr.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 04:50:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435837125.2285.7.camel@sipsolutions.net>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
 <1435082418.2777.11.camel@ipeer-box> <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
 <1435822032.2285.2.camel@sipsolutions.net> <CABPxzYLVDUsFu3WwCFzYjE-sZtARiDSM6iGRu6RSFxeJ7k=rOw@mail.gmail.com>
 <1435837125.2285.7.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 2 Jul 2015 17:19:45 +0530
Message-ID: <CABPxzYLP=GUVL6BAGYRn0Btu5pFRVNiBKrvifO-FS2jmLa2kUw@mail.gmail.com> (sfid-20150702_135010_652884_CA7183BB)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 2, 2015 at 5:08 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-07-02 at 14:32 +0530, Krishna Chaitanya wrote:
>>
>> We have also found another issue with direct probe.
>> Some of the AP's are not setting sequence number in the probe
>> responses
>> so in case of a retry they are dropped as duplicate by rx_h_check
>> causing direct probe to fail.
>
> I don't quite see how that can be an issue, since the RETRY bit
> shouldn't be set??

If retry bit is not set, then it works, but in a noisy channel 2.4GHz
we are seeing high retries causing direct probes to fail 90% of the
time.

The AP in case is Marvel AP RD88W8787 (WFA Testbed).
