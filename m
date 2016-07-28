Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45058 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbcG1MU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 08:20:59 -0400
Message-ID: <1469708450.6761.156.camel@hadess.net> (sfid-20160728_142134_739519_A9DAF3D6)
Subject: Re: [RFC v0 4/8] Input: goodix: use firmware_stat instead of
 completion
From: Bastien Nocera <hadess@hadess.net>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Daniel Wagner <wagi@monom.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	irina.tirdea@intel.com, octavian.purdila@intel.com
Date: Thu, 28 Jul 2016 14:20:50 +0200
In-Reply-To: <f7dd0db5-af15-7310-ac9f-1034bdf4f592@bmw-carit.de>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>	
 <1469692512-16863-5-git-send-email-wagi@monom.org>	
 <1469704952.6761.142.camel@hadess.net>
	 <f7dd0db5-af15-7310-ac9f-1034bdf4f592@bmw-carit.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-07-28 at 13:59 +0200, Daniel Wagner wrote:
> On 07/28/2016 01:22 PM, Bastien Nocera wrote:
> > On Thu, 2016-07-28 at 09:55 +0200, Daniel Wagner wrote:
> > > From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > > 
> > > Loading firmware is an operation many drivers implement in
> > > various
> > > ways
> > > around the completion API. And most of them do it almost in the
> > > same
> > > way. Let's reuse the firmware_stat API which is used also by the
> > > firmware_class loader. Apart of streamlining the firmware loading
> > > states
> > > we also document it slightly better.
> > > 
> > > Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > 
> > Irina added and tested that feature, so best for her to comment on
> > this, as I don't have any hardware that would use this feature.
> 
> In case you have any comments on the API, let me know. I'll add Irina
> to 
> the Cc list in the next version.

Looking at the API, I really don't like the mixing of namespaces.
Either it's fw_ or it's firmware_ but not a mix of both.

Also looks like fw_loading_start() would do nothing as the struct is
likely zero initialised, and FW_STATUS_LOADING == 0. Maybe you need an
UNSET enum member?

FW_STATUS_ABORT <- FW_STATUS_ABORTED, to match the adjective suffixes
of the other members. Ditto fw_loading_abort() which doesn't abort
firmware loading but sets the status.

Cheers

