Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48322 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbbHMNNt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 09:13:49 -0400
Message-ID: <1439471624.2114.30.camel@sipsolutions.net> (sfid-20150813_151412_002676_828CF73F)
Subject: Re: [PATCH] net/wireless: enable wiphy device to suspend/resume
 asynchronously
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: David Miller <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 13 Aug 2015 15:13:44 +0200
In-Reply-To: <CANUX_P3PMsvWCWWciwCsRvf5PqLVEK9d9S=2Gbq+EotVGffEow@mail.gmail.com> (sfid-20150730_075551_447889_FECED471)
References: <55B9B3BA.6080406@linux.intel.com>
	 <CANUX_P3PMsvWCWWciwCsRvf5PqLVEK9d9S=2Gbq+EotVGffEow@mail.gmail.com>
	 (sfid-20150730_075551_447889_FECED471)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-30 at 08:55 +0300, Emmanuel Grumbach wrote:
> On Thu, Jul 30, 2015 at 8:18 AM, Fu, Zhonghui
> <zhonghui.fu@linux.intel.com> wrote:
> > Enable wiphy device to suspend/resume asynchronously. This can 
> > improve
> > system suspend/resume speed.
> > 
> 
> How will that impact the timing with respect to the suspend call
> coming from the bus?
> I think that a few drivers rely on the suspend call of the wiphy
> device happening before the suspend call to the bus device.
> 

Yes, we can't do this for precisely this reason unless we have a way to
somehow keep the dependency between the two - possibly by also marking
the other one as async (although I don't know if the async framework in
general has any FIFO guarantees, which would be required for this.)

I've dropped the patch.

johannes
