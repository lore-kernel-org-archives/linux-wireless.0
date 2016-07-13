Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59569 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcGMGvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 02:51:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "Grumbach\, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linuxwifi <linuxwifi@intel.com>,
	"Coelho\, Luciano" <luciano.coelho@intel.com>,
	"Berg\, Johannes" <johannes.berg@intel.com>,
	"Ivgi\, Chaya Rachel" <chaya.rachel.ivgi@intel.com>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon\, Sara" <sara.sharon@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RESEND] iwlwifi, Do not implement thermal zone unless ucode is loaded
References: <1468250301-10357-1-git-send-email-prarit@redhat.com>
	<CANUX_P0AFoM5VEDWDjtvOhNbExu4T1bLWU+uS-EYqoGtu5h2bw@mail.gmail.com>
	<5783E33E.7090205@redhat.com> <1468261650.20877.14.camel@intel.com>
	<57840214.8000904@redhat.com>
Date: Wed, 13 Jul 2016 09:50:53 +0300
In-Reply-To: <57840214.8000904@redhat.com> (Prarit Bhargava's message of "Mon,
	11 Jul 2016 16:31:16 -0400")
Message-ID: <87eg6yav5e.fsf@purkki.adurom.net> (sfid-20160713_085108_740452_4E9E465C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prarit Bhargava <prarit@redhat.com> writes:

>> We implement thermal zone because we do support it, but the problem is
>> that we need the firmware to be loaded for that. So you can argue that
>> we should register *later* when the firmware is loaded. But this is
>> really not helping all that much because the firmware can also be
>> stopped at any time. So you'd want us to register / unregister the
>> thermal zone anytime the firmware is loaded / unloaded?
>
> You might have to do that.  I think that if the firmware enables a feature then
> the act of loading the firmware should run the code that enables the feature.
> IMO of course.

But I suspect that the iwlwifi firmware is loaded during interface up
(and unloaded during interface down) and in that case
register/unregister would be happening all the time. That doesn't sound
like a good idea. I would rather try to fix the thermal interface to
handle the cases when the measurement is not available.

-- 
Kalle Valo
