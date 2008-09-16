Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:59053 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYIPJPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 05:15:24 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1432835nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 02:15:23 -0700 (PDT)
Message-ID: <1ba2fa240809160215w4b990f2eo26805b62fb056ce5@mail.gmail.com> (sfid-20080916_111533_772438_16E8FE9D)
Date: Tue, 16 Sep 2008 12:15:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC] Implement basic background scanning
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <877i9czdjd.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200809151416.07552.hschaa@suse.de>
	 <200809151429.46638.hschaa@suse.de>
	 <1221494383.3700.52.camel@johannes.berg>
	 <200809151835.03786.hschaa@suse.de> <877i9czdjd.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 11:43 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Helmut Schaa <hschaa@suse.de> writes:
>
>>> This doesn't play well at all with hardware assisted scan as far as I
>>> can tell.
>>
>> Correct. The patch only adapts software scan code. The hardware
>> assisted scan is not touched at all but should also not be affected
>> in an odd way.
>
> I would guess that some firmwares support similar scanning in
> hardware. In the future we might add support for background scanning
> in hardware with a flag in hw_scan(), or something like that.

In iwwlifi we can trigger scan anytime during association so this is
not an issue.

The common point for sw and hw  is when to trigger scanning and what
are scanning parameters.

The objective is that this affect performance, therefore the scan can
be triggered on
1. On limited number of channels
    a. After first scan we know which channels are active or activated
(passive channels with traffic)
    b. We can scan only channels with possible roaming candidates
(same SSID or list of possible SSIDs)
2. Group scanning
  Issue scanning in small group of channels and returning back to the
serving channel. The size of group
   is affected by current traffic rate and quality. Size of group
effects off channel time (#channels * dwell time)

Thanks
Tomas
