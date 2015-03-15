Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:18522 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbbCOI14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 04:27:56 -0400
Date: Sun, 15 Mar 2015 13:57:36 +0530
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move driver state check before setting throttle
Message-ID: <20150315082734.GD18213@qca.qualcomm.com> (sfid-20150315_092802_799583_7F2CECFF)
References: <1426097094-6225-1-git-send-email-rmanohar@qti.qualcomm.com>
 <873858rgh6.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <873858rgh6.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 13, 2015 at 06:48:21PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Since thermal daemon is unaware of the device state, it might
> > try to adjust the throttle state when the device is powered down.
> > So the driver caches the value and will configure it while
> > powering up the target. The cached value will be programed later
> > once the device is brought up. In such case, returning error
> > status is confusing and misleading the user application. Hence
> > moving the driver state check before sending wmi command to target.
> >
> > Reported-by: Matthias Kaehlcke <mka@google.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> What tree do you use as the baseline? Three-way merge doesn't work as
> sha1 ids are not found:
> 
Will send rebased version.

-Rajkumar
