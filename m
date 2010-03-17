Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:42867 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab0CQTen (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 15:34:43 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Nrz0p-0004fD-9T
	for linux-wireless@vger.kernel.org; Wed, 17 Mar 2010 20:34:39 +0100
Received: from 69-165-147-23.dsl.teksavvy.com ([69.165.147.23])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 20:34:39 +0100
Received: from monnier by 69-165-147-23.dsl.teksavvy.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 20:34:39 +0100
To: linux-wireless@vger.kernel.org
From: Stefan Monnier <monnier@iro.umontreal.ca>
Subject: Re: iwl3945 and power saving
Date: Wed, 17 Mar 2010 15:34:20 -0400
Message-ID: <jwvr5niiw6r.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
References: <jwvwrxbimib.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
	<1268804105.2446.620.camel@rchatre-DESK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> The extra power consumption is quite significant, so I'm considering
>> compiling my own driver, manually re-enabling the power-saving code.
> You will need to revert "iwl3945: disable power save" and then also
> enable power savings using "iwconfig wlanX power on"

Yes, thank you.

>> But before I do that, I'd like to know what is the risk involved (it
>> seems pretty serious since it warranted removing the feature
>> altogether, even tho it was runtime-disabled by default anyway).
> You should find all the details in
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2125

Hmm... it seems odd to completely kill the feature rather than to flag
it as "beware, it's brittle" (e.g. only allow to turn it on with
"iwconfig wlanX power on-and-I-promise-I-wont-report-a-bug-if-its-buggy").

Also, it puzzles me: my 3945 has been working fine with power-saving for
more than 2 years (and earlier with ipw3945 as well) and I haven't
noticed any unreliability.  Have I just been lucky or did the problem
only start to manifest in more "recent" versions of the driver, for
reasons we don't understand?


        Stefan

