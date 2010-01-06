Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12291 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab0AFFXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 00:23:47 -0500
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
Date: Tue, 5 Jan 2010 21:23:32 -0800
Subject: RE: [ipw3945-devel] Panic in iwl3945 driver
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B5D151348@orsmsx502.amr.corp.intel.com>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>	<1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop>	<1259659724.12157.110.camel@debian>
	 <1259732550.12157.130.camel@debian>	<1259774227.26287.2.camel@maxim-laptop>
	 <1261413654.3556.6.camel@maxim-laptop>	<1261472251.12157.829.camel@debian>
	 <1262710566.3272.3.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B5D15133C@orsmsx502.amr.corp.intel.com>
	 <02B3067C068D0549A8CCFCB17D4D318B5D15133F@orsmsx502.amr.corp.intel.com>
 <1262750225.15653.113.camel@debian>
In-Reply-To: <1262750225.15653.113.camel@debian>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 

>-----Original Message-----
>From: Zhu, Yi 
>Sent: Tuesday, January 05, 2010 10:57 PM
>To: Cahill, Ben M
>Cc: Maxim Levitsky; Chatre, Reinette; linux-wireless; iwlwifi 
>maling list
>Subject: RE: [ipw3945-devel] Panic in iwl3945 driver
>
>On Wed, 2010-01-06 at 06:26 +0800, Cahill, Ben M wrote:
>> >><3>[  330.762510] iwl3945 0000:06:00.0: 1035963222
>> >>0x04dc0018     0401
>> >
>> >Last good command 0x18, with (driver provided) header
>> >indicating sent via queue 4, queue index 0xdc
>> >
>> >><3>[  330.762547] iwl3945 0000:06:00.0: 1035963229
>> >>0x00000000     0401
>> >
>> >This shows command "0" (non-existant/unsupported/bad command)
>> >with (driver provided) header indicating sent via queue "0",
>> >index "0"; obviously bad data in command queue.
>> 
>> Or index ("pointer") is getting out of sync.  (Reminder to 
>self; never
>> use the word "obviously"). 
>
>Ben, does it smell like driver issue or firmware bug?

I would tend to suspect driver or platform issue, but that's just a guess of course.  Something seems to be telling the device to read DRAM that contains "0".  Do we reset unused command buffers to 0?  Just wondering if the index/pointers are getting out of sync somehow (double-increment or who-knows-what?).

I haven't followed this thread closely (plus I've been on vacation!); can you give me a summary of what you're trying to fix?

Also, not sure if it's relevant, but a community member discovered that MSI should be enabled in kernel config.  See bugzilla 1944.

-- Ben --

>
>Thanks,
>-yi
>
>