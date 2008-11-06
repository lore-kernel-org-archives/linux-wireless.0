Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:24680 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYKFOrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:47:06 -0500
Received: by wf-out-1314.google.com with SMTP id 27so712527wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 06:47:05 -0800 (PST)
Message-ID: <1ba2fa240811060647x688f1efp1728e5f80dbb6b35@mail.gmail.com> (sfid-20081106_154734_586790_2EC29439)
Date: Thu, 6 Nov 2008 16:47:05 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association in 5Ghz band
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Abhijeet Kolekar" <abhijeet.kolekar@intel.com>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1225982253.3619.233.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
	 <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
	 <20081106134950.GB14184@tuxdriver.com>
	 <1225982253.3619.233.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 4:37 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2008-11-06 at 08:49 -0500, John W. Linville wrote:
>> On Wed, Nov 05, 2008 at 11:17:22PM +0100, Marcel Holtmann wrote:
>>
>> >> This patch is related to bug 11870 at bugzilla.kernel.org. With
>> >> correct regulatory information the number of channels to scan
>> >> will be correct and not zero as seen in that bug.
>> >>
>> >> This patch eliminates the need for wireless to be compiled with
>> >> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
>> >> iwlwifi.
>> >
>> > so this is still for 2.6.28, but for 2.6.29 and wireless-testing the API
>> > changed and we need a separate or different patch.
>> >
>> > John, Dave what is your take on pushing this to Linus this late in the
>> > merge window? I personally think we should do that. And if not, then
>> > change the Intel wireless Kconfig to select
>> > CONFIG_WIRELESS_OLD_REGULATORY by default at least.
>>
>> CONFIG_WIRELESS_OLD_REGULATORY is already 'default y' now.  I don't
>> really see why iwlwifi should _require_ that if someone decides to
>> choose a non-default configuration.
>
> I agree, also, I thought the problem was that iwlwifi misbehaved if
> there were no active channels in the 5 GHz band and there was a patch to
> fix that?
The problem with missing A band is that this info was supplied to
driver too late. after registration otherwise
the iwlwifi dealt properly with missing band This was change in design
that wasn't reflected in the driver.

This can happen _regardless_ of the setting of old regulatory,

With old regulatory the channel was known prior to registration

Tomas
