Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:12509 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYF3JQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:16:54 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1132813waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 02:16:52 -0700 (PDT)
Message-ID: <1ba2fa240806300216i40770cf7i8414c220326b0628@mail.gmail.com> (sfid-20080630_111707_835438_26515317)
Date: Mon, 30 Jun 2008 12:16:52 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>
In-Reply-To: <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com>
	 <43e72e890806300118me4b20bv2b91f30f91eaa7f3@mail.gmail.com>
	 <1ba2fa240806300152o6d5f7deby6d00a4421138177c@mail.gmail.com>
	 <43e72e890806300159j6c98ef9dpeac61d5aeca19f0e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 11:59 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Mon, Jun 30, 2008 at 1:52 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>> On Mon, Jun 30, 2008 at 11:18 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>>> On Sun, Jun 29, 2008 at 2:43 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:
>>>> From: Ester Kummer <ester.kummer@intel.com>
>>>>
>>>> This patch adds an option to enable all the channels by adding a
>>>> value of "NONE" to ieee80211_regdom module param. This is useful
>>>> for NICs that rely on EEPROM regulatory enforcement and for testing
>>>
>>> For the EEPROM we should not rely on "none" but on a callback notifier
>>> chain to let the driver do 'the right thing'. I'll post patches
>>> hopefully tonight.
>>
>> Still can be useful for testing,
>
> Testing can be done separately but not merged. The idea is to keep
> mac80211 and mac80211 drivers as compliant as possible. This steers in
> the other direction.

Currently EEPROM and reg domains creates strange intersections. We are
hitting this complains every other day.
What we are missing is the clear indication for end users (not on this
mailing list) what and why channels are restricted.
Thanks
Tomas
