Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31293 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbZEESpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:45:34 -0400
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 5 May 2009 11:45:33 -0700
Subject: RE: [ipw3945-devel] IWL3945 always reports noise levels of -127
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B3569A467@orsmsx502.amr.corp.intel.com>
References: <1241213459.7082.54.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B3569A43A@orsmsx502.amr.corp.intel.com>
	 <1241463816.4816.1.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B3569A442@orsmsx502.amr.corp.intel.com>
	 <1241535034.4816.20.camel@maxim-laptop>
 <1241540190.4816.25.camel@maxim-laptop>
In-Reply-To: <1241540190.4816.25.camel@maxim-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Excellent information.  Thank you.

We just issued new 3945 uCode within the past week or two ... Is that also showing the problem (noise_diff = 0)?

-- Ben --  

>-----Original Message-----
>From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
>Sent: Tuesday, May 05, 2009 12:17 PM
>To: Cahill, Ben M
>Cc: iwlwifi maling list; linux-wireless
>Subject: RE: [ipw3945-devel] IWL3945 always reports noise 
>levels of -127
>
>On Tue, 2009-05-05 at 17:50 +0300, Maxim Levitsky wrote:
>> On Mon, 2009-05-04 at 12:27 -0700, Cahill, Ben M wrote:
>> > 
>> > >-----Original Message-----
>> > >From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
>> > >Sent: Monday, May 04, 2009 3:04 PM
>> > >To: Cahill, Ben M
>> > >Cc: iwlwifi maling list; linux-wireless
>> > >Subject: RE: [ipw3945-devel] IWL3945 always reports noise 
>> > >levels of -127
>> > >
>> > >On Mon, 2009-05-04 at 11:53 -0700, Cahill, Ben M wrote:
>> > >> When one of our devices cannot figure out what the actual 
>> > >noise level is, it reports -127.
>> > >> 
>> > >> Newer devices are better at old devices at figuring noise 
>> > >level.  IIRC, 3945 cannot figure noise for CCK signals, and 
>> > >may not be possible with OFDM as well.
>> > >
>> > >Why then it did work on older kernel ?
>> > >(and noise levels seemed to be correct)
>> > 
>> > Hmmm, good point, and I don't know the answer!  :-(
>> > 
>> 
>> And I do know it now (this is what I suspected...)
>> This is firmware issue.
>> 
>> I forced the driver to use older firmware iwlwifi-3945-1.ucode,
>> and noise levels are back.
>
>
>Indeed old microcode reports values like that:
>rssi:017 agc:000 sig_avg:5437 noise_diff:580
>
>
>New microcode reports this instead:
>rssi:018 agc:000 sig_avg:140 noise_diff:000
>
>
>noise_diff is always zero now, and range for sig_avg changed.
>
>I also noticed that with older firmware I couldn't set the tx speed
>Thus what recently fixed it was a firmware update!
>(But in both cases OFDM rated were used)
>
>Thats all nothing to debug any more here.
>
>
>Best regards,
>	Maxim Levitsky
>
>