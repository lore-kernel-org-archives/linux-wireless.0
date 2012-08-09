Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:62598 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2HIEpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 00:45:03 -0400
Received: by obbuo13 with SMTP id uo13so70453obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 21:45:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502281D9.4030109@openwrt.org>
References: <1344344772-49459-1-git-send-email-nbd@openwrt.org>
	<1344344772-49459-2-git-send-email-nbd@openwrt.org>
	<1344344772-49459-3-git-send-email-nbd@openwrt.org>
	<1344344772-49459-4-git-send-email-nbd@openwrt.org>
	<20120808145531.GB2041@vmraj-lnx.qualcomm.com>
	<502281D9.4030109@openwrt.org>
Date: Thu, 9 Aug 2012 10:15:02 +0530
Message-ID: <CAD2nsn3HDjA-3vG+KLsFuzTmYq3-67qO8kBHXEn3_dc7ho7rEQ@mail.gmail.com> (sfid-20120809_064509_736442_DE10ACC7)
Subject: Re: [PATCH 3.6 4/4] ath9k_hw: enable PA linearization
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Wed, Aug 8, 2012 at 8:42 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-08-08 4:55 PM, Rajkumar Manoharan wrote:
>> On Tue, Aug 07, 2012 at 03:06:12PM +0200, Felix Fietkau wrote:
>>> This feature had been disabled in ath9k because the code to support
>>> it was incomplete, but now the code is in sync with the internal QCA
>>> codebase, so it's time to enable it.
>>>
>>> On many newer devices, the calibration is assumed to be done with PA
>>> linearization enabled.
>>>
>>> Tests with a particular AR933x device showed that the signal emitted
>>> at full power was highly distorted and unreliable with PA linearization
>>> disabled. With this patch, the signal becomes clear and stability
>>> is improved.
>>>
>> We faced stability issues with 938x chipsets when paprd is enabled. The commit
>> 6f4810101a629b31b5427872a09ea092cfc5c4bd states one of the issue. Even if it
>> helps for AR933x, let us enable it only for that chip alone.
> That was in January 2011, lots of bugs have been fixed since then,
> initvals have been updated, EEPROM code has changed, ...
>
> The internal QCA codebase enables PAPRD for all AR93xx devices that
> support it, meaning non-PAPRD tx receives much less test coverage there.
>
> While this issue has only been visible on a particular AR933x device, I
> believe this is not the only one that's going to be affected, as the
> EEPROM of any new device is calibrated for PAPRD-enabled operation.
>
> If you don't want to enable it now, when do you think would be the right
> time to enable it? Before I sent this patch, I did a detailed code
> review to make sure that any obvious code discrepancies in PAPRD between
> the internal codebase and ath9k are dealt with.
>
> What else is needed to get this issue sorted out?
>

i was working on PAPRD  for sometime to ensure that it provides a
consistent throughput improvement in all the rates.
After some amount of testing where i was able to show it  gave a
considerable throughput improvement in particular
MCS rates/particular attenuation  only(in the shielded box, varying
the attenuation) and i thought/asked for enabling
PAPRD. With the open air and with other even in the shielded
environment I could not show any consistent improvement in all
attenuation. Infact there are some cases where it proved detrimental
to the actual throughput, because of some bugs i suppose. Even with
our internal code base i saw there are few work arounds to disable it
if the PAPRD fails(PAPRD curve ?) and few more issues cropped up
because of this feature. We throw in the towel and stopped tracking
the changes. But i am not sure of its current status and its effects
in our internal code base. As Raj had suggested we can validate the
bug in commit id
6f4810101a629b31b5427872a09ea092cfc5c4bd. thanks!

-- 
thanks,
shafi
