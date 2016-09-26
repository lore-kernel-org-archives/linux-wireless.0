Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbcIZIwJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Sep 2016 04:52:09 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Sharon\, Sara" <sara.sharon@intel.com>
Cc: Luca Coelho <luca@coelho.fi>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 10/25] iwlwifi: mvm: support packet injection
References: <1474270071.5664.89.camel@coelho.fi>
        <20160919073028.22065-10-luca@coelho.fi>
        <87oa3d1r5h.fsf@kamboji.qca.qualcomm.com>
        <84271B8B681983469E84120965EB1B0434D68BCA@HASMSX106.ger.corp.intel.com>
Date: Mon, 26 Sep 2016 11:52:03 +0300
In-Reply-To: <84271B8B681983469E84120965EB1B0434D68BCA@HASMSX106.ger.corp.intel.com>
        (Sara Sharon's message of "Mon, 26 Sep 2016 08:10:08 +0000")
Message-ID: <8737kn11sc.fsf@kamboji.qca.qualcomm.com> (sfid-20160926_105214_055565_3A0E6D35)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Sharon, Sara" <sara.sharon@intel.com> writes:

>> The commit log doesn't tell a lot. I started to wonder why use
>> debugfs and not the proper interface through mac80211?
>
> This is RX packet injection, not TX. So the injection goes up - from
> the driver to mac80211. Since we use it to test some mvm data path
> stuff, we don't want to inject at mac80211 level.
>
>> But reading from the code makes me suspect that this isn't really
>> normal packet injection, more like passing full descriptors to the
>> hw. Did I understand correctly?
>
> For injecting at driver level we need the injected packet to contain a
> fake of the HW descriptor for the driver processing. This descriptor
> isn't being passed to the hw, but to the driver since it is RX. The
> code isn't creating the descriptor, but it is validating length and
> other checks to make sure we won't access invalid memory or so.

Ah, makes sense. No need to resend this, but in the future please try to
explain higher level design like this in the commit log. That avoids a
lot of guessing (wrong) for me and others.

-- 
Kalle Valo
